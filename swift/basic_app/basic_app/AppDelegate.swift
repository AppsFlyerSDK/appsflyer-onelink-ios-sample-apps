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
    var deferred_deep_link_processed_flag:Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: - [Matrix flag] Debug logs
        AppsFlyerLib.shared().isDebug = true

        // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
        AppsFlyerLib.shared().initialize(devKey: "sQ84wpdxRTR4RMCaE9YqS4", appId: "1512793879")

        // MARK: - [Matrix flag] Customer User ID (CUID)
        AppsFlyerLib.shared().customerUserID = "my user id"

        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().appInviteOneLinkID = "H5hv"

        // Required before registerSessionReadyListener. In iOS 13+ scene apps,
        // UL/URI cold-launch payloads are NOT in launchOptions — they arrive via
        // connectionOptions in SceneDelegate, so the two paths don't double-fire.
        AppsFlyerLib.shared().handleLaunchOptions(launchOptions)

        // MARK: - [Matrix flag] Session-ready listener (v7 default spine)
        AppsFlyerLib.shared().registerSessionReadyListener {
            // MARK: - [Matrix flag] ATT
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    AppsFlyerLib.shared().start { (dictionary, error) in
                        if let error = error {
                            NSLog("[AFSDK] start failed: \(error)")
                            return
                        }
                        NSLog("[AFSDK] start succeeded: \(dictionary ?? [:])")
                    }
                }
            } else {
                AppsFlyerLib.shared().start { (dictionary, error) in
                    if let error = error {
                        NSLog("[AFSDK] start failed: \(error)")
                        return
                    }
                    NSLog("[AFSDK] start succeeded: \(dictionary ?? [:])")
                }
            }
        }

        return true
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
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    // User logic
    fileprivate func walkToSceneWithParams(fruitName: String, deepLinkData: [String: Any]?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
               
        let destVC = fruitName + "_vc"
        if let newVC = storyBoard.instantiateVC(withIdentifier: destVC) {
            
            NSLog("[AFSDK] AppsFlyer routing to section: \(destVC)")
            newVC.deepLinkData = deepLinkData
            
             UIApplication.shared.windows.first?.rootViewController?.present(newVC, animated: true, completion: nil)
        } else {
            NSLog("[AFSDK] AppsFlyer: could not find section: \(destVC)")
        }
    }
}

extension AppDelegate: AppsFlyerDeepLinkDelegate {
     
    func didResolveDeepLink(_ result: DeepLinkResult) {
        var fruitNameStr: String?
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
        
        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }
        
        if let referrerId = deepLinkObj.clickEvent["deep_link_sub2"] as? String {
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(referrerId)")
        }
        
        let deepLinkStr:String = deepLinkObj.toString()
        NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
            
        if( deepLinkObj.isDeferred == true) {
            NSLog("[AFSDK] This is a deferred deep link")
            if (deferred_deep_link_processed_flag == true) {
                NSLog("Deferred deep link was already processed by GCD. This iteration can be skipped.")
                deferred_deep_link_processed_flag = false
                return
            }
        }
        else {
            NSLog("[AFSDK] This is a direct deep link")
        }
        
        fruitNameStr = deepLinkObj.deeplinkValue
        
        //If deep_link_value doesn't exist
        if fruitNameStr == nil || fruitNameStr == "" {
            //check if fruit_name exists
            switch deepLinkObj.clickEvent["fruit_name"] {
                case let s as String:
                    fruitNameStr = s
                default:
                    print("[AFSDK] Could not extract deep_link_value or fruit_name from deep link object with unified deep linking")
                    return
            }
        }
        
        // This marks to GCD that UDL already processed this deep link.
        // It is marked to both DL and DDL, but GCD is relevant only for DDL
        deferred_deep_link_processed_flag = true
        
        walkToSceneWithParams(fruitName: fruitNameStr!, deepLinkData: deepLinkObj.clickEvent)
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
     
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        ConversionData = data
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
        if let conversionData = data as NSDictionary? as! [String:Any]? {
        
            if let status = conversionData["af_status"] as? String {
                if (status == "Non-organic") {
                    if let sourceID = conversionData["media_source"],
                        let campaign = conversionData["campaign"] {
                        NSLog("[AFSDK] This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    }
                } else {
                    NSLog("[AFSDK] This is an organic install.")
                }
                
                if let is_first_launch = conversionData["is_first_launch"] as? Bool,
                    is_first_launch {
                    NSLog("[AFSDK] First Launch")
                    if (deferred_deep_link_processed_flag == true) {
                        NSLog("Deferred deep link was already processed by UDL. The DDL processing in GCD can be skipped.")
                        deferred_deep_link_processed_flag = false
                        return
                    }
                    
                    deferred_deep_link_processed_flag = true
                    
                    guard let fruitNameStr = (conversionData["deep_link_value"] as? String)
                                          ?? (conversionData["fruit_name"] as? String) else {
                        NSLog("[AFSDK] Could not extract deep_link_value or fruit_name from conversion data")
                        return
                    }
                    
                    NSLog("This is a deferred deep link opened using conversion data")
                    walkToSceneWithParams(fruitName: fruitNameStr, deepLinkData: conversionData)
                } else {
                    NSLog("[AFSDK] Not First Launch")
                }
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        NSLog("[AFSDK] \(error)")
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
