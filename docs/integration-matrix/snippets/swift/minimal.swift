// Minimal v7 init: Debug logs + initialize + delegates + handleLaunchOptions
// + registerSessionReadyListener wrapping start with completion handler.
// Derived from swift/basic_app/basic_app/AppDelegate.swift with ATT, CUID,
// and SceneDelegate hookup stripped.

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // MARK: - [Matrix flag] Debug logs
    AppsFlyerLib.shared().isDebug = true

    AppsFlyerLib.shared().initialize(devKey: "sQ84wpdxRTR4RMCaE9YqS4", appId: "1512793879")

    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().deepLinkDelegate = self

    // Required before listener registration if app supports Universal Links
    AppsFlyerLib.shared().handleLaunchOptions(launchOptions)

    // MARK: - [Matrix flag] Session-ready listener (v7 default spine)
    AppsFlyerLib.shared().registerSessionReadyListener {
        AppsFlyerLib.shared().start { (dictionary, error) in
            if let error = error {
                NSLog("[AFSDK] start failed: \(error)")
                return
            }
            NSLog("[AFSDK] start succeeded: \(dictionary ?? [:])")
        }
    }

    return true
}
