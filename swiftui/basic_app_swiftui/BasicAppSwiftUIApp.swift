//
//  BasicAppSwiftUIApp.swift
//  basic_app_swiftui
//
//  Copyright © 2026 AppsFlyer. All rights reserved.
//

import SwiftUI

@main
struct BasicAppSwiftUIApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appDelegate.appState)
        }
    }
}
