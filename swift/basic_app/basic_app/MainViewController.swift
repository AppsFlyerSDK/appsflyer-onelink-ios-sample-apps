//
//  MainViewController.swift
//  basic_app
//
//  Created by Liaz Kamper on 28/03/2023.
//  Copyright © 2023 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib


class MainViewController: UIViewController {
    
    var afSdkStartedKey = "AF_SDK_STARTED"
    var registeredKey = "IS_RESGISTERED"
    var ConversionData: [AnyHashable: Any]? = nil
    // This boolean flag signals between the UDL and GCD callbacks that this deep_link was
    // already processed, and the callback functionality for deep linking can be skipped.
    // When GCD or UDL finds this flag true it MUST set it to false before skipping.
    var deferred_deep_link_processed_flag:Bool = false
    @IBOutlet weak var loginBtn: UIButton!
        
    var loginController: LoginViewController?
    
    var savedFruitName : String?
    var savedDlData : [String: Any]?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init user registered to false
        let defaults = UserDefaults.standard
        NSLog("Register user")
        defaults.set(false, forKey: registeredKey)
        
        NSLog("####### I'm here viewDidLoad ##########")
        
        // 1 - Get AppsFlyer preferences from .plist file
        guard let propertiesPath = Bundle.main.path(forResource: "afdevkey", ofType: "plist"),
            let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String:String] else {
                fatalError("Cannot find `afdevkey`")
        }
        guard let appsFlyerDevKey = properties["appsFlyerDevKey"],
                   let appleAppID = properties["appleAppID"] else {
            fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key")
        }
        
        //  Set isDebug to true to see AppsFlyer debug logs
        AppsFlyerLib.shared().isDebug = true
        
        // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
        AppsFlyerLib.shared().appsFlyerDevKey = appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = appleAppID
                       
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self
        
        //set the OneLink template id for share invite links
        AppsFlyerLib.shared().appInviteOneLinkID = "H5hv"
        
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        loginController = story.instantiateViewController(identifier: "login_vc")
        loginController?.delegate = self
    }
   
    @IBAction func loginBtnClicked(_ sender: Any) {
        self.present(loginController!, animated: true)
    }
    
    @IBAction func applesClicked(_ sender: Any) {
        if(isUserRegistered()) {
            walkToSceneWithParams(fruitName: "apples", deepLinkData: nil)
        }
    }
    
    @IBAction func bananasClicked(_ sender: Any) {
        if(isUserRegistered()) {
            walkToSceneWithParams(fruitName: "bananas", deepLinkData: nil)
        }
    }
    
    @IBAction func peachesClicked(_ sender: Any) {
        if(isUserRegistered()) {
            walkToSceneWithParams(fruitName: "peaches", deepLinkData: nil)
        }
    }    
    
    // User logic
    private func walkToSceneWithParams(fruitName: String, deepLinkData: [String: Any]?) {
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
    
    private func isUserRegistered() -> Bool {
        let defaults = UserDefaults.standard
        NSLog("isUserRegistered")
        let isRegistered = defaults.bool(forKey: registeredKey)
        if (isRegistered == true) {
            NSLog("User is registered")
            return true
        } else {
            NSLog("User is not registered");
            return false
        }
    }
    
    private func processDeepLinkIfExists() {
        if(isUserRegistered() == false) {
            NSLog("User is not registered. Wait to register")
        } else if (savedFruitName == nil) {
            NSLog("No deep linking occurred")
        } else {
            NSLog("Perform deep linking")
            let tmp_savedFruitName = savedFruitName
            let tmp_savedDlData = savedDlData
            savedFruitName = nil
            savedDlData = nil
            walkToSceneWithParams(fruitName: tmp_savedFruitName!, deepLinkData: tmp_savedDlData)
        }
        return
    }
       
    private func savedDlData(fruitName : String, dlData : [String: Any]?)
    {
        savedFruitName = fruitName
        savedDlData = dlData
    }
    
    private func markRegistered() {
        let defaults = UserDefaults.standard
        NSLog("Register user")
        defaults.set(true, forKey: registeredKey)
    }

}

extension MainViewController: LoginDoneDelegate {
    
    func loginDone() {
        dismiss(animated: true) {
            NSLog("Registering user")
            self.markRegistered()
            if (self.isUserRegistered()) {
                self.loginBtn.backgroundColor = UIColor.green
                self.loginBtn.isEnabled = false
                self.processDeepLinkIfExists()
            }
        }
    }
}

extension MainViewController: DeepLinkDelegate {

    func didResolveDeepLink(_ result: DeepLinkResult) {
        var fruitNameStr: String?
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
            return
        case .failure:
            print("Error %@", result.error!)
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }

        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }

        if deepLinkObj.clickEvent.keys.contains("deep_link_sub2") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub2"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
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
        
        savedDlData(fruitName: fruitNameStr!, dlData: deepLinkObj.clickEvent)
        processDeepLinkIfExists()
    }
}

extension MainViewController: AppsFlyerLibDelegate {
     
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
                    
                    var fruitNameStr:String
                    
                    if conversionData.keys.contains("deep_link_value") {
                        fruitNameStr = conversionData["deep_link_value"] as! String
                    } else if conversionData.keys.contains("fruit_name") {
                        fruitNameStr = conversionData["fruit_name"] as! String
                    } else {
                        NSLog("Could not extract deep_link_value or fruit_name from deep link object using conversion data")
                        return
                    }
                    
                    NSLog("This is a deferred deep link opened using conversion data")
                    savedDlData(fruitName: fruitNameStr, dlData: conversionData)
                    processDeepLinkIfExists()
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

