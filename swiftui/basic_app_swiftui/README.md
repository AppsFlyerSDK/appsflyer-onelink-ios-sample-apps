# basic_app_swiftui

A small SwiftUI iOS app that shows how to integrate the AppsFlyer iOS SDK and
handle OneLink deep links end‑to‑end:

- Cold‑start (deferred) deep links resolved from conversion data
- Warm‑start direct deep links from Universal Links and custom URI schemes
- A shareable OneLink invite generated from inside the app
- A simple SwiftUI navigation flow driven by the resolved link payload

The app is intentionally tiny — three "fruit" screens (Apples, Bananas, Peaches)
plus two info screens that surface the raw deep‑link and conversion‑data
payloads — so you can focus on the integration code, not the UI.

## Requirements

- Xcode 15 or later
- iOS 17+ simulator or device (uses `@Observable`)
- CocoaPods
- An Apple Developer team for signing (required for Universal Links)

## Getting started

```bash
cd swiftui/basic_app_swiftui
pod install
open basic_app_swiftui.xcworkspace
```

Then in Xcode:

1. Select the `basic_app_swiftui` target.
2. Under **Signing & Capabilities**, set your development team.
3. Build and run on a simulator or device.

> Always open the **`.xcworkspace`**, not the `.xcodeproj` — CocoaPods needs the
> workspace to link the AppsFlyer SDK.

## How it's wired together

```
BasicAppSwiftUIApp  (SwiftUI @main)
        │
        │  @UIApplicationDelegateAdaptor
        ▼
   AppDelegate
        │   • Initializes AppsFlyerLib
        │   • Receives delegate callbacks (conversion data, deep link)
        │   • Forwards Universal Links and URL scheme opens to the SDK
        │   • Owns the shared AppState
        ▼
    AppState  (@Observable, injected into the SwiftUI environment)
        │   • conversionData
        │   • deepLinkData
        │   • currentRoute
        ▼
     MainView
        │   • Three fruit buttons
        │   • Presents a sheet whenever currentRoute is set
        ▼
  Fruit / DeepLink / ConversionData screens
```

When a OneLink is opened, the SDK resolves it and calls `didResolveDeepLink`.
The app maps the resolved `deep_link_value` (or legacy `fruit_name`) to a
`Route`, writes it to `AppState`, and SwiftUI presents the matching screen.

## Project layout

| Path | What it does |
|---|---|
| `BasicAppSwiftUIApp.swift` | SwiftUI app entry point, bridges to `AppDelegate`. |
| `AppDelegate.swift` | SDK initialization, conversion + deep link delegates, URL forwarding. |
| `AppState.swift` | Observable state container shared across the view tree. |
| `Routing/Route.swift` | Enum of navigable destinations and the `deep_link_value` → `Route` mapping. |
| `Screens/MainView.swift` | Landing screen + sheet presentation of the active route. |
| `Screens/ApplesView.swift`, `BananasView.swift`, `PeachesView.swift` | Fruit destination screens. |
| `Screens/DeepLinkView.swift` | Inspector for the most recent deep‑link payload. |
| `Screens/ConversionDataView.swift` | Inspector for the conversion‑data payload. |
| `Info.plist` | URL scheme + standard SwiftUI lifecycle config. |
| `basic_app_swiftui.entitlements` | Associated Domains for Universal Links. |

## Testing deep links

With the app installed on a booted simulator:

```bash
# Universal Link
xcrun simctl openurl booted https://onelink-basic-app.onelink.me/H5hv/apples
xcrun simctl openurl booted https://onelink-basic-app.onelink.me/H5hv/bananas
xcrun simctl openurl booted https://onelink-basic-app.onelink.me/H5hv/peaches
```

To test a **deferred** deep link (first‑time install flow):

1. Uninstall the app from the simulator.
2. Click a OneLink in Notes or Messages.
3. After install, watch the Xcode console — the conversion‑data callback
   should fire and the app should auto‑navigate to the resolved fruit screen.

Console lines tagged `[AFSDK-SwiftUI]` trace the integration flow and are a
good first stop when something doesn't behave as expected.

## Configuring the sample for your own AppsFlyer account

The values below live in `AppDelegate.swift` and are throwaway demo
credentials. Replace them with your own to point the sample at your app:

| Setting | Where to change it |
|---|---|
| Dev key | `AppsFlyerLib.shared().initialize(devKey:appId:)` |
| App ID  | `AppsFlyerLib.shared().initialize(devKey:appId:)` |
| OneLink ID | `AppsFlyerLib.shared().appInviteOneLinkID` |
| Bundle Identifier | Target → General → Bundle Identifier |
| Associated Domain | Target → Signing & Capabilities → Associated Domains |

> The bundle identifier in Xcode **must** match the iOS bundle ID registered
> for your OneLink template in the AppsFlyer dashboard — a mismatch will cause
> Universal Links to silently fail to open the app.

## License

Sample code provided by AppsFlyer for demonstration purposes.
