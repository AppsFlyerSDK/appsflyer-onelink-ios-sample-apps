# Debug logs

**Purpose:** Enable verbose SDK logging during development. Logs install, session, attribution, deep-link, and network events to the Xcode console.

## Where it lives

| Sample | File | Line |
|--------|------|------|
| obj-c | `obj-c/obj-c/AppDelegate.m` | 25-27 |
| swift | `swift/basic_app/basic_app/AppDelegate.swift` | 21-22 |
| swiftui | `swiftui/basic_app_swiftui/AppDelegate.swift` | 33-34 |

Set this **before** anything else on `AppsFlyerLib.shared()`. It costs nothing to set early, and a few setters log at construction time.

## Swift

```swift
// MARK: - [Matrix flag] Debug logs
AppsFlyerLib.shared().isDebug = true
```

## Objective-C

```objectivec
#pragma mark - [Matrix flag] Debug logs
// Set isDebug to true to see AppsFlyer debug logs
[AppsFlyerLib shared].isDebug = YES;
```

## Behavioral notes

- **Default:** `false`. The SDK ships silent.
- **Timing:** safe at any point, but earlier is better — late toggles miss bootstrap-time logs.
- **Threading:** main thread is conventional; the property is a simple BOOL set.
- **If omitted:** the SDK still runs normally. You just get no console output. Set this when reproducing an attribution issue or wiring up a new integration.
- **Production:** ship with `isDebug = false`. Leaving it on inflates console noise and can leak request/response payloads to anyone with a device log.
