//
//  AppDelegate.swift
//  basic_app_swiftui
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate, AppsFlyerDeepLinkDelegate {

    let appState = AppState()

    // Dedupes DDL between the UDL and GCD callback paths.
    private var deferredDeepLinkProcessedFlag: Bool = false

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: - [Matrix flag] Debug logs
        AppsFlyerLib.shared().isDebug = true

        AppsFlyerLib.shared().initialize(devKey: "sQ84wpdxRTR4RMCaE9YqS4", appId: "1512793879")

        // MARK: - [Matrix flag] Customer User ID (CUID)
        AppsFlyerLib.shared().customerUserID = "my user id"

        AppsFlyerLib.shared().appInviteOneLinkID = "H5hv"
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
                            NSLog("[AFSDK-SwiftUI] start failed: \(error)")
                            return
                        }
                        NSLog("[AFSDK-SwiftUI] start succeeded: \(dictionary ?? [:])")
                    }
                }
            } else {
                AppsFlyerLib.shared().start { (dictionary, error) in
                    if let error = error {
                        NSLog("[AFSDK-SwiftUI] start failed: \(error)")
                        return
                    }
                    NSLog("[AFSDK-SwiftUI] start succeeded: \(dictionary ?? [:])")
                }
            }
        }

        return true
    }

    // MARK: - Push attribution (re-engagement)

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
        completionHandler(.noData)
    }

    // MARK: - Direct deep linking (warm start)
    // Without a UIApplicationSceneManifest in Info.plist, SwiftUI's
    // .onOpenURL / .onContinueUserActivity modifiers don't fire — iOS routes
    // URLs through the AppDelegate. Forward both to the SDK.

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }

    // MARK: - AppsFlyerDeepLinkDelegate

    // SDK can fire this off the main thread; bounce to MainActor for AppState writes.
    nonisolated func didResolveDeepLink(_ result: DeepLinkResult) {
        Task { @MainActor in
            self.handleDeepLinkResult(result)
        }
    }

    private func handleDeepLinkResult(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            NSLog("[AFSDK-SwiftUI] Deep link not found")
            return
        case .failure:
            NSLog("[AFSDK-SwiftUI] Deep link failure: \(String(describing: result.error))")
            return
        case .found:
            NSLog("[AFSDK-SwiftUI] Deep link found")
        @unknown default:
            NSLog("[AFSDK-SwiftUI] Deep link unknown status")
            return
        }

        guard let deepLinkObj = result.deepLink else {
            NSLog("[AFSDK-SwiftUI] Could not extract deep link object")
            return
        }

        if let referrerId = deepLinkObj.clickEvent["deep_link_sub2"] as? String {
            NSLog("[AFSDK-SwiftUI] Referrer ID: \(referrerId)")
        }

        NSLog("[AFSDK-SwiftUI] DeepLink data is: \(deepLinkObj.toString())")

        if deepLinkObj.isDeferred {
            NSLog("[AFSDK-SwiftUI] This is a deferred deep link")
            if deferredDeepLinkProcessedFlag {
                NSLog("[AFSDK-SwiftUI] DDL already processed by GCD — skipping UDL pass")
                deferredDeepLinkProcessedFlag = false
                return
            }
        } else {
            NSLog("[AFSDK-SwiftUI] This is a direct deep link")
        }

        // Resolve the value: prefer deep_link_value, fall back to fruit_name
        var fruitNameStr: String? = deepLinkObj.deeplinkValue
        if fruitNameStr == nil || fruitNameStr?.isEmpty == true {
            fruitNameStr = deepLinkObj.clickEvent["fruit_name"] as? String
        }

        // Mark for the GCD pass that UDL handled this
        deferredDeepLinkProcessedFlag = true

        // Write into observable state — the view layer reacts
        appState.deepLinkData = deepLinkObj.clickEvent
        if let route = Route.fruit(from: fruitNameStr) {
            appState.currentRoute = route
        } else {
            NSLog("[AFSDK-SwiftUI] Unknown deep_link_value/fruit_name: \(fruitNameStr ?? "nil")")
            appState.currentRoute = nil
        }
    }

    // MARK: - AppsFlyerLibDelegate

    nonisolated func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        Task { @MainActor in
            self.handleConversionData(data)
        }
    }

    nonisolated func onConversionDataFail(_ error: Error) {
        NSLog("[AFSDK-SwiftUI] Conversion data failed: \(error)")
    }

    private func handleConversionData(_ data: [AnyHashable: Any]) {
        let stringKeyed = data.reduce(into: [String: Any]()) { acc, pair in
            if let k = pair.key as? String { acc[k] = pair.value }
        }
        appState.conversionData = stringKeyed

        guard let status = stringKeyed["af_status"] as? String else {
            NSLog("[AFSDK-SwiftUI] Conversion data missing af_status")
            return
        }

        if status == "Non-organic" {
            let source = stringKeyed["media_source"] ?? "?"
            let campaign = stringKeyed["campaign"] ?? "?"
            NSLog("[AFSDK-SwiftUI] Non-Organic install. media_source=\(source) campaign=\(campaign)")
        } else {
            NSLog("[AFSDK-SwiftUI] Organic install.")
        }

        // Only run GCD-based deferred deep link routing on first launch
        guard let isFirstLaunch = stringKeyed["is_first_launch"] as? Bool, isFirstLaunch else {
            NSLog("[AFSDK-SwiftUI] Not first launch — skipping GCD routing")
            return
        }

        NSLog("[AFSDK-SwiftUI] First launch")

        if deferredDeepLinkProcessedFlag {
            NSLog("[AFSDK-SwiftUI] DDL already processed by UDL — skipping GCD pass")
            deferredDeepLinkProcessedFlag = false
            return
        }
        deferredDeepLinkProcessedFlag = true

        // Only route via GCD if UDL did not already set a route
        guard appState.currentRoute == nil else {
            NSLog("[AFSDK-SwiftUI] Route already set by UDL — leaving as-is")
            return
        }

        let raw = (stringKeyed["deep_link_value"] as? String) ?? (stringKeyed["fruit_name"] as? String)
        if let route = Route.fruit(from: raw) {
            NSLog("[AFSDK-SwiftUI] Deferred deep link via conversion data → \(route)")
            // Mirror UIKit sample behavior: pass the conversion payload to the
            // fruit screen so it can render the same deep_link_value / sub1 / etc.
            // that didResolveDeepLink would have provided on the direct path.
            appState.deepLinkData = data
            appState.currentRoute = route
        } else {
            NSLog("[AFSDK-SwiftUI] No deep_link_value/fruit_name in conversion data")
        }
    }
}
