# Session-ready listener (v7 default spine)

**Purpose:** The SDK's official timing gate. The block you register fires after the SDK has resolved its readiness preconditions and is ready to send the install/session event. This is the v7 replacement for the v6 `NotificationCenter.didBecomeActive → start()` workaround.

Not a toggleable matrix flag — always on. The DevHub generator wires this in for every v7 integration. It's the backbone the other flags layer onto.

## Where it lives

| Sample | File | Line |
|--------|------|------|
| obj-c | `obj-c/obj-c/AppDelegate.m` | 44-67 |
| swift | `swift/basic_app/basic_app/AppDelegate.swift` | 39-61 |
| swiftui | `swiftui/basic_app_swiftui/AppDelegate.swift` | 54-76 |

Register **after** `initialize(...)`, the delegates, and `handleLaunchOptions(_:)`. `start()` lives **inside** the block.

## Swift

```swift
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
```

## Objective-C

```objectivec
#pragma mark - [Matrix flag] Session-ready listener (v7 default spine)
[[AppsFlyerLib shared] registerSessionReadyListener:^{
#pragma mark - [Matrix flag] ATT
    // ATT request goes here if the app needs it before start
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"[AFSDK] start failed: %@", error);
                    return;
                }
                NSLog(@"[AFSDK] start succeeded: %@", dictionary);
            }];
        }];
    } else {
        [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"[AFSDK] start failed: %@", error);
                return;
            }
            NSLog(@"[AFSDK] start succeeded: %@", dictionary);
        }];
    }
}];
```

## Behavioral notes

- **Readiness preconditions:** the listener fires after the SDK has resolved:
  - dev key set via `initialize(...)`
  - `appleAppID` set via `initialize(...)`
  - `handleLaunchOptions(_:)` has returned
  - any cold-launch Universal Link resolved (with a 5s watchdog so the listener can't be permanently blocked)
- **Lifecycle-agnostic:** fires correctly whether your app is `UIApplicationDelegate`-only, AppDelegate + SceneDelegate, or pure SwiftUI `App` with `WindowGroup`. You don't need a `didBecomeActive` observer on top.
- **Threading:** the block runs on an internal serial queue. Don't touch UIKit directly inside it. ATT's completion handler and `start()`'s completion handler are also off-main — dispatch back to main if you need to update UI.
- **Timeout:** 5s watchdog on Universal Link resolution. If a cold-launch UL doesn't resolve in time, the listener still fires so `start()` isn't permanently blocked.
- **Order matters:** call `handleLaunchOptions(launchOptions)` **before** `registerSessionReadyListener`. The listener checks completion of `handleLaunchOptions` as a precondition.
- **If omitted:** `start()` never runs (no install event, no session, no attribution). This is a revenue-critical failure — the SDK has no fallback for "developer forgot to call `start()`." Treat the listener and its `start()` call as mandatory; the matrix flag never turns it off.
- **Idempotency:** `start()` is safe to call again after the first session. Subsequent calls do nothing useful — the SDK's session logic dedupes — but they don't crash. Don't rely on this; call it exactly once from inside the listener.
