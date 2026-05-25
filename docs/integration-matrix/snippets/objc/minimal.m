// Minimal v7 init: Debug logs + initialize + delegates + handleLaunchOptions
// + registerSessionReadyListener wrapping startWithCompletionHandler:.
// Derived from obj-c/obj-c/AppDelegate.m with ATT, CUID, and SceneDelegate
// hookup stripped.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark - [Matrix flag] Debug logs
    [AppsFlyerLib shared].isDebug = YES;

    [[AppsFlyerLib shared] initWithDevKey:@"sQ84wpdxRTR4RMCaE9YqS4" appleAppId:@"1512793879"];

    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].deepLinkDelegate = self;

    // Required before listener registration if app supports Universal Links
    [[AppsFlyerLib shared] handleLaunchOptions:launchOptions];

#pragma mark - [Matrix flag] Session-ready listener (v7 default spine)
    [[AppsFlyerLib shared] registerSessionReadyListener:^{
        [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"[AFSDK] start failed: %@", error);
                return;
            }
            NSLog(@"[AFSDK] start succeeded: %@", dictionary);
        }];
    }];

    return YES;
}
