//
//  AppDelegate.swift
//  basic_app
//
//  Created by Liaz Kamper on 11/05/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ConversionData: [AnyHashable: Any]? = nil
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().initialize(devKey: "DzWhTw4F78vGTeTuYAucoF", appId: "1550796743")
        
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().handleLaunchOptions(launchOptions)

        AppsFlyerLib.shared().registerSessionReadyListener {
            AppsFlyerLib.shared().start()
        }

        
        return true
    }
    
    @objc func didBecomeActiveNotification() {
    }
    
    // Open Universal Links
    
    // For Swift version < 4.2 replace function signature with the commented out code
    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
            
    // Open URI-scheme for iOS 9 and above
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
}

extension AppDelegate: AppsFlyerLibDelegate {

    // Handle organic / non-organic install
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        ConversionData = data
        print("onConversionDataSuccess: \(data)")
    }

    func onConversionDataFail(_ error: Error) {
        print("onConversionDataFail: \(error)")
    }
}

extension AppDelegate: AppsFlyerDeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
            return
        case .failure:
            NSLog("[AFSDK] Deep link error: \(String(describing: result.error))")
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }
        guard let deepLinkObj = result.deepLink else { return }
        NSLog("[AFSDK] DeepLink data is: \(deepLinkObj.toString())")
        NSLog(deepLinkObj.isDeferred ? "[AFSDK] This is a deferred deep link" : "[AFSDK] This is a direct deep link")

        guard let fruitName = deepLinkObj.deeplinkValue, !fruitName.isEmpty else {
            NSLog("[AFSDK] deep_link_value is missing")
            return
        }
        walkToSceneWithParams(fruitName: fruitName, deepLinkData: deepLinkObj.clickEvent)
    }

    fileprivate func walkToSceneWithParams(fruitName: String, deepLinkData: [String: Any]?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        if let newVC = storyBoard.instantiateVC(withIdentifier: fruitName + "_vc") {
            newVC.deepLinkData = deepLinkData
            UIApplication.shared.windows.first?.rootViewController?.present(newVC, animated: true, completion: nil)
        } else {
            NSLog("[AFSDK] Could not find screen: \(fruitName)_vc")
        }
    }
}


extension UIStoryboard {
    func instantiateVC(withIdentifier identifier: String) -> DLViewController? {
        // "identifierToNibNameMap" – dont change it. It is a key for searching IDs
        if let identifiersList = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
            if identifiersList[identifier] != nil {
                return self.instantiateViewController(withIdentifier: identifier) as? DLViewController
            }
        }
        return nil
    }
}
