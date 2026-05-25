//
//  Route.swift
//  basic_app_swiftui
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import Foundation

enum Route: Hashable, Identifiable {
    case apples
    case bananas
    case peaches
    case deepLink        // shows resolved deep-link payload + share invite
    case conversionData  // shows attribution payload

    var id: Self { self }

    /// Map a raw value (deep_link_value or fruit_name) to a fruit Route.
    /// Returns nil for unknown values so the caller can decide what to do.
    static func fruit(from raw: String?) -> Route? {
        switch raw?.lowercased() {
        case "apples":  return .apples
        case "bananas": return .bananas
        case "peaches": return .peaches
        default:        return nil
        }
    }
}
