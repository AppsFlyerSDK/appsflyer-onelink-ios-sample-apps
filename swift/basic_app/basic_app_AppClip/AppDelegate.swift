//
//  AppDelegate.swift
//  basic_app_AppClip
//
//  Created by Oded Rinsky on 08/11/2021.
//  Copyright © 2021 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ConversionData: [AnyHashable: Any]? = nil
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            NSLog("[AFSDK] AppsFlyer start application")
            
            //Set isDebug to true to see AppsFlyer debug logs
            AppsFlyerLib.shared().isDebug = true
            //Disable unecessary attributions
            AppsFlyerLib.shared().disableSKAdNetwork = true
            AppsFlyerLib.shared().disableCollectASA = true
            AppsFlyerLib.shared().disableAppleAdsAttribution = true
            
            AppsFlyerLib.shared().deepLinkDelegate = self
            
            // Get AppsFlyer preferences from .plist file
            guard let propertiesPath = Bundle.main.path(forResource: "afdevkey", ofType: "plist"),
                let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String:String] else {
                    fatalError("Cannot find `afdevkey`")
            }
            guard let appsFlyerDevKey = properties["appsFlyerDevKey"],
                       let appleAppID = properties["appleAppID"] else {
                fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key")
            }

            // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
            AppsFlyerLib.shared().appsFlyerDevKey = appsFlyerDevKey
            AppsFlyerLib.shared().appleAppID = appleAppID
            
            // Subscribe to didBecomeActiveNotification if you use SceneDelegate or just call
            // -[AppsFlyerLib start] from -[AppDelegate applicationDidBecomeActive:]
            NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification),
            // For Swift version < 4.2 replace name argument with the commented out code
            name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
            object: nil)

            return true
        }

    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
    }
    
    // For Swift version < 4.2 replace function signature with the commented out code
    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        NSLog("[AFSDK] application continue userActivity")
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Open Deeplinks
    
    // Open URI-scheme for iOS 8 and below
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Open URI-scheme for iOS 9 and above
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    // User logic
    
    fileprivate func presentParamsInMainViewController(deepLinkObj: DeepLink?) {
        //Get the root view controller - MainViewController
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? MainViewController
        if rootVC == nil {
            NSLog("[AFSDK] AppsFlyer: could not find the rootViewController")
        }
        NSLog("[AFSDK] AppsFlyer showing DL parameters")
        rootVC?.viewControllerFirstLaunch = false
        rootVC?.deepLinkData = deepLinkObj
        rootVC?.showDeepLinkData()
    }
}

extension AppDelegate: DeepLinkDelegate {
     
    func didResolveDeepLink(_ result: DeepLinkResult) {
        NSLog("[AFSDK] didResolveDeepLink called")
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
        case .found:
            let deepLinkStr:String = result.deepLink!.toString()
            NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
            
            if( result.deepLink?.isDeferred == true) {
                NSLog("[AFSDK] This is a deferred deep link")
            } else {
                NSLog("[AFSDK] This is a direct deep link")
                presentParamsInMainViewController(deepLinkObj: result.deepLink!)
            }
        case .failure:
            NSLog("[AFSDK] Failed to perform Deep Link operation")
            print("Error %@", result.error ?? "<nil>")
        }
    }
}

