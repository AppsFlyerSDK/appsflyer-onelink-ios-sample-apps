# ATT (App Tracking Transparency)

**Purpose:** Request the user's tracking-authorization decision before `start()` so the SDK can include IDFA in the install/session payload when granted. Required by App Store policy for any SDK that reads IDFA.

## Where it lives

| Sample | File | Line |
|--------|------|------|
| obj-c | `obj-c/obj-c/AppDelegate.m` | 46-65 |
| swift | `swift/basic_app/basic_app/AppDelegate.swift` | 41-60 |
| swiftui | `swiftui/basic_app_swiftui/AppDelegate.swift` | 56-75 |

ATT lives **inside** the `registerSessionReadyListener` block, **before** `start()`. This replaces v6's `waitForATTUserAuthorization:` — v7 has no built-in ATT timeout. The session-ready listener guarantees the SDK is ready, and your code controls when ATT is requested.

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

- **Info.plist:** `NSUserTrackingUsageDescription` is required. Without it, the prompt never displays and `requestTrackingAuthorization` resolves with `.denied`.
- **Timing:** the prompt only shows once per install. After the user decides, subsequent calls resolve immediately with the stored status.
- **Threading:** the completion handler fires on an arbitrary queue. Don't touch UIKit there. Calling `start()` from the completion is fine — `AppsFlyerLib` handles its own threading.
- **iOS < 14:** the `#available` / `@available` else branch calls `start()` directly. IDFA is available unconditionally on pre-iOS-14 devices.
- **If omitted:** `start()` runs without IDFA on iOS 14+ devices (treated as ATT-denied by Apple). Attribution still works via probabilistic and SKAdNetwork paths, but install-quality signals degrade.
- **tvOS:** ATT is unavailable. Skip this block entirely on tvOS targets.
- **Don't:** call `start()` outside the `registerSessionReadyListener` block just because ATT denied. The listener is the gate; the ATT branch only decides whether to prompt first.
