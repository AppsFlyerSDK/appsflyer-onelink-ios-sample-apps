//
//  SceneDelegate.swift
//  basic_app
//
//  v7 SceneDelegate flag: deep-link routing only.
//  No NotificationCenter.didBecomeActive observer — registerSessionReadyListener
//  is the SDK's official timing gate. See docs/integration-matrix/migration/v6-to-v7.md.
//

import UIKit
import AppsFlyerLib

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
