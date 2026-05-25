//
//  AppState.swift
//  basic_app_swiftui
//
//  Single source of truth for the SwiftUI sample app.
//  Written from delegate callbacks, observed by views.
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class AppState {

    /// Full conversion data payload from onConversionDataSuccess.
    var conversionData: [String: Any]? = nil

    /// Resolved deep link clickEvent from didResolveDeepLink (.found).
    var deepLinkData: [AnyHashable: Any]? = nil

    /// Drives NavigationStack(path:). Nil means root.
    var currentRoute: Route? = nil

    /// Reset every observable property. Useful for "back to root" actions.
    func reset() {
        conversionData = nil
        deepLinkData = nil
        currentRoute = nil
    }
}
