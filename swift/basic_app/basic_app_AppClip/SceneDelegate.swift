//
//  SceneDelegate.swift
//  basic_app_AppClip
//
//  Created by Oded Rinsky on 08/11/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Must for AppsFlyer attrib
        NSLog("[AFSDK] Scene continue userActivity")
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        //Get the invocation URL from the userActivity in order to add it to the shared user default
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let invocationURL = userActivity.webpageURL else {
            return
            }
        NSLog("[AFSDK] Scene add to SharedUserDefaults \(invocationURL)")
        addDlUrlToSharedUserDefaults(invocationURL)
        }
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            
        guard let _ = (scene as? UIWindowScene) else { return }
        NSLog("[AFSDK] Scene willConnectTo")
            
        if let userActivity = connectionOptions.userActivities.first {
            NSLog("[AFSDK] Scene willConnectTo continue userActivity")
            self.scene(scene, continue: userActivity)
        }
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func addDlUrlToSharedUserDefaults(_ url: URL){
        guard let sharedUserDefaults = UserDefaults(suiteName: "group.basic_app.appClipToFullApp") else {
            return
        }
        //Add invocation URL to the app group
           sharedUserDefaults.set(url, forKey: "dl_url")
        //Enable sending events
        sharedUserDefaults.set(true, forKey: "AppsFlyerReadyToSendEvents")
    }
    
}

