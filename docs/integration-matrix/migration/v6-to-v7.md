# V6 → V7 SceneDelegate migration

## TL;DR

In v7, the **SceneDelegate** matrix flag generates `SceneDelegate.swift` (or `.m`) for **deep-link routing only**. The v6 `NotificationCenter.didBecomeActive` observer that called `AppsFlyerLib.shared().start()` is gone. `registerSessionReadyListener` is the SDK's official timing gate; the v6 observer was a workaround for a problem v7 solves natively.

If you're migrating a v6 integration:

- **Remove** the `UIApplicationDidBecomeActiveNotification` observer and any `@objc func sendLaunch()` selector that calls `start()`.
- **Keep** the SceneDelegate file — but only for `scene(_:continue:)`, `scene(_:openURLContexts:)`, and the cold-launch path in `scene(_:willConnectTo:options:)`.
- **Move** `start()` inside a `registerSessionReadyListener` block in `application(_:didFinishLaunchingWithOptions:)`.

## What the v6 pattern was solving

The v6 DevHub generator emitted code like this in `application(_:didFinishLaunchingWithOptions:)`:

```swift
// v6 — DO NOT COPY
NotificationCenter.default.addObserver(
    self,
    selector: #selector(sendLaunch),
    name: UIApplication.didBecomeActiveNotification,
    object: nil
)

// ...

@objc func sendLaunch() {
    AppsFlyerLib.shared().start()
}
```

```objectivec
// v6 — DO NOT COPY
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(sendLaunch)
                                             name:UIApplicationDidBecomeActiveNotification
                                           object:nil];

// ...

- (void)sendLaunch {
    [[AppsFlyerLib shared] start];
}
```

**Why this existed:** in a scene-based app, `application(_:didFinishLaunchingWithOptions:)` can return **before any scene is connected**. Calling `start()` directly there raced the scene lifecycle:

- Universal Links delivered via `scene(_:willConnectTo:options:)` hadn't arrived yet.
- The first foreground signal hadn't fired.
- Attribution context (specifically, cold-launch deep-link state) could be missing from the install event.

Deferring `start()` to `didBecomeActive` guaranteed a scene was alive and any UL was already in flight. It worked, but it was a downstream patch on the SDK's timing model.

## Why v7 doesn't need it

`registerSessionReadyListener` fires only after the SDK has resolved its readiness conditions:

- dev key set
- `appleAppID` set
- `handleLaunchOptions(_:)` returned
- any cold-launch Universal Link resolved (with a 5s watchdog so the listener can't be permanently blocked)

It's **lifecycle-agnostic by design**. It fires correctly whether the app is:

- `UIApplicationDelegate`-only (legacy iOS 12 layout)
- AppDelegate + SceneDelegate (UIKit scene-based)
- pure SwiftUI `App` with `WindowGroup`

Layering `didBecomeActive → start()` on top is at best redundant; at worst it triggers a second `start()` call when the user backgrounds and foregrounds the app. The SDK dedupes internally, but the extra call is a smell.

## What the SceneDelegate flag means now

It scaffolds the `SceneDelegate` file that routes Universal Links and URI schemes into the SDK:

- `scene(_:continue:)` — Universal Link delivered to an active scene (warm path).
- `scene(_:openURLContexts:)` — URI scheme delivered to an active scene.
- `scene(_:willConnectTo:options:)` — both channels on cold launch, where the scene didn't exist yet.

Without this file in a scene-based app, deep links silently drop on the floor. UIKit stops routing `continueUserActivity` / `openURL:` to `AppDelegate` once a `SceneDelegate` is declared in `Info.plist`.

## Code diff — AppDelegate region

### v6 (deprecated)

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    AppsFlyerLib.shared().appsFlyerDevKey = "..."
    AppsFlyerLib.shared().appleAppID = "..."
    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().deepLinkDelegate = self
    AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(sendLaunch),
        name: UIApplication.didBecomeActiveNotification,
        object: nil
    )

    return true
}

@objc func sendLaunch() {
    AppsFlyerLib.shared().start()
}
```

### v7 (canonical)

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // MARK: - [Matrix flag] Debug logs
    AppsFlyerLib.shared().isDebug = true

    AppsFlyerLib.shared().initialize(devKey: "...", appId: "...")

    // MARK: - [Matrix flag] Customer User ID (CUID)
    AppsFlyerLib.shared().customerUserID = "my user id"

    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().deepLinkDelegate = self
    AppsFlyerLib.shared().handleLaunchOptions(launchOptions)

    // MARK: - [Matrix flag] Session-ready listener (v7 default spine)
    AppsFlyerLib.shared().registerSessionReadyListener {
        // MARK: - [Matrix flag] ATT
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                AppsFlyerLib.shared().start { (dictionary, error) in
                    if let error = error {
                        NSLog("[AFSDK] start failed: \(error)")
                        return
                    }
                    NSLog("[AFSDK] start succeeded: \(dictionary ?? [:])")
                }
            }
        } else {
            AppsFlyerLib.shared().start { (dictionary, error) in
                if let error = error {
                    NSLog("[AFSDK] start failed: \(error)")
                    return
                }
                NSLog("[AFSDK] start succeeded: \(dictionary ?? [:])")
            }
        }
    }

    return true
}
```

Key differences:

- `appsFlyerDevKey` / `appleAppID` property setters replaced by `initialize(devKey:appId:)`.
- `waitForATTUserAuthorization` gone. ATT lives inside `registerSessionReadyListener`, before `start()`.
- `NotificationCenter` observer gone. `start()` lives inside `registerSessionReadyListener`.
- `handleLaunchOptions(_:)` is now a hard precondition for the readiness listener.
- `start { dictionary, error in ... }` reports success/failure via completion handler.

## SwiftUI footnote

`App`-lifecycle apps don't get a `SceneDelegate` even when the matrix flag is on. `WindowGroup` owns scene management; `UIWindowSceneDelegate` is bypassed. Use the SwiftUI view modifiers instead:

```swift
.onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
    AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
}
.onOpenURL { url in
    AppsFlyerLib.shared().handleOpen(url, options: nil)
}
```

Reference: [`swiftui/basic_app_swiftui/Screens/MainView.swift:71-78`](../../../swiftui/basic_app_swiftui/Screens/MainView.swift).

`registerSessionReadyListener` still belongs in your `UIApplicationDelegateAdaptor`'s `application(_:didFinishLaunchingWithOptions:)` — see [`swiftui/basic_app_swiftui/AppDelegate.swift:54-76`](../../../swiftui/basic_app_swiftui/AppDelegate.swift).

## If you really must call `start()` on `didBecomeActive`

You shouldn't. But if you have a custom SDK lifecycle requirement that demands it:

- `start()` is idempotent under v7 session-readiness. Calling it again after the first session succeeds does nothing useful — the SDK dedupes the session event internally.
- You will not crash, but you will burn cycles and add noise to your logs.
- The recommended pattern is to call `start()` exactly once, from inside the `registerSessionReadyListener` block. If you need to trigger something on every foreground, observe `didBecomeActive` yourself and call your own code — not `start()`.

This escape hatch exists for backward compatibility with shipped v6 code while you migrate. It is not a v7-blessed pattern.
