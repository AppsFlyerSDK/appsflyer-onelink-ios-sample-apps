import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import BranchSDK
import AppsFlyerMigrationHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ConversionData: [AnyHashable: Any]? = nil
    var window: UIWindow?
    var deferred_deep_link_processed_flag: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppsFlyer()
        configureBranch(with: launchOptions)
        AppsFlyerLib.shared().start()
        return true
    }
    
    private func configureBranch(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Branch.enableLogging()
        handlePasteboardOnInstall()
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            NSLog("[Branch] initSession, deep link data: %@", params ?? [:])
            if let params = params as? [String: AnyObject] {
                AppsFlyerMigrationHelper.shared.setDeepLinkingData(params)
            }
        }
        
        if let sessionParams = Branch.getInstance().getLatestReferringParams() {
            AppsFlyerMigrationHelper.shared.setDeepLinkingData(sessionParams)
        }
        
        Branch.getInstance().lastAttributedTouchData(withAttributionWindow: 0) { (params, error) in
            if let params = params {
                AppsFlyerMigrationHelper.shared.setAttributionData(params.lastAttributedTouchJSON)
            }
        }
    }
    
    private func configureAppsFlyer() {
        AppsFlyerLib.shared().appleAppID = "1201211633"
        AppsFlyerLib.shared().appsFlyerDevKey = "WdpTVAcYwmxsaQ4WeTspmh"
        AppsFlyerLib.shared().isDebug = true
    }
    
    private func handlePasteboardOnInstall() {
        if #available(iOS 16.0, *) {
            return
        } else if #available(iOS 15.0, *) {
            Branch.getInstance().checkPasteboardOnInstall()
        }
        
        if Branch.getInstance().willShowPasteboardToast() {
            NSLog("[Branch] willShowPasteboardToast")
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return Branch.getInstance().continue(userActivity)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }
}

extension UIStoryboard {
    func instantiateVC(withIdentifier identifier: String) -> DLViewController? {
        if let identifiersList = self.value(forKey: "identifierToNibNameMap") as? [String: Any], identifiersList[identifier] != nil {
            return self.instantiateViewController(withIdentifier: identifier) as? DLViewController
        }
        return nil
    }
}
