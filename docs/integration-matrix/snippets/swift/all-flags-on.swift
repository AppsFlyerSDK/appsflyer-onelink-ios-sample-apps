// Source: swift/basic_app/basic_app/AppDelegate.swift lines 19-63
// All matrix flags ON: Debug logs + CUID + delegates + handleLaunchOptions
// + Session-ready listener wrapping ATT + start with completion handler.

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // MARK: - [Matrix flag] Debug logs
    AppsFlyerLib.shared().isDebug = true

    // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
    AppsFlyerLib.shared().initialize(devKey: "sQ84wpdxRTR4RMCaE9YqS4", appId: "1512793879")

    // MARK: - [Matrix flag] Customer User ID (CUID)
    AppsFlyerLib.shared().customerUserID = "my user id"

    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().deepLinkDelegate = self

    //set the OneLink template id for share invite links
    AppsFlyerLib.shared().appInviteOneLinkID = "H5hv"

    // Required before listener registration if app supports Universal Links
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
