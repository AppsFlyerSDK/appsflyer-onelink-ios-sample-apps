# SceneDelegate

**Purpose:** Route Universal Links (`NSUserActivity`) and URI schemes (`UIOpenURLContext`) into the SDK in scene-based apps. In v7, this flag generates the `SceneDelegate` file **only**. It does **not** add a `NotificationCenter.didBecomeActive` observer — see [migration/v6-to-v7.md](../migration/v6-to-v7.md).

## Where it lives

| Sample | File | Line |
|--------|------|------|
| obj-c | `obj-c/obj-c/SceneDelegate.m` | 15-39 |
| swift | `swift/basic_app/basic_app/SceneDelegate.swift` | 12-37 |
| swiftui | n/a — `App` lifecycle apps don't get a SceneDelegate; use `.onContinueUserActivity` + `.onOpenURL` view modifiers. See `swiftui/basic_app_swiftui/Screens/MainView.swift:71-78`. |

## Swift

```swift
// MARK: - [Matrix flag] SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first {
            AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        }
        for urlContext in connectionOptions.urlContexts {
            AppsFlyerLib.shared().handleOpen(urlContext.url, options: nil)
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            AppsFlyerLib.shared().handleOpen(context.url, options: nil)
        }
    }
}
```

## Objective-C

```objectivec
#pragma mark - [Matrix flag] SceneDelegate
@implementation SceneDelegate


- (void)scene:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
                 options:(UISceneConnectionOptions *)connectionOptions {
    NSUserActivity *userActivity = connectionOptions.userActivities.anyObject;
    if (userActivity) {
        [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
    }
    for (UIOpenURLContext *urlContext in connectionOptions.URLContexts) {
        [[AppsFlyerLib shared] handleOpenUrl:urlContext.URL options:nil];
    }
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *urlContext in URLContexts) {
        [[AppsFlyerLib shared] handleOpenUrl:urlContext.URL options:nil];
    }
}
```

## Behavioral notes

- **Three delivery channels:**
  - `scene(_:willConnectTo:options:)` — cold launch via deep link. The scene didn't exist yet; both Universal Links and URI schemes arrive in `connectionOptions`.
  - `scene(_:continue:)` — Universal Link delivered to an already-connected scene (warm path).
  - `scene(_:openURLContexts:)` — URI scheme delivered to an already-connected scene.
- **Symbol naming (ObjC):** the SDK exposes `handleOpenUrl:options:` (lowercase `u`). Do not write `handleOpenURL:options:`.
- **Timing:** these methods can fire before, during, or after `registerSessionReadyListener` resolves. The SDK buffers deep-link inputs internally and replays them once readiness is reached.
- **Threading:** UIKit calls these on the main thread.
- **If omitted in a scene-based app:** Universal Links and URI schemes silently drop. `AppDelegate`'s `continueUserActivity` / `openURL:` overrides are bypassed by UIKit once a SceneDelegate is wired up in `Info.plist`.
- **SwiftUI lifecycle:** see the migration callout — `WindowGroup` owns scene management, so the SDK is fed via `.onContinueUserActivity` and `.onOpenURL` instead.

## Migration

See [migration/v6-to-v7.md](../migration/v6-to-v7.md) for why the v6 `NotificationCenter.didBecomeActive` workaround is gone and what the flag means now.
