// Source: obj-c/obj-c/AppDelegate.m lines 24-69
// All matrix flags ON: Debug logs + CUID + delegates + handleLaunchOptions
// + Session-ready listener wrapping ATT + start with completion handler.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark - [Matrix flag] Debug logs
    // Set isDebug to true to see AppsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;

    // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
    [[AppsFlyerLib shared] initWithDevKey:@"sQ84wpdxRTR4RMCaE9YqS4" appleAppId:@"1512793879"];

#pragma mark - [Matrix flag] Customer User ID (CUID)
    [AppsFlyerLib shared].customerUserID = @"my user id";

    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].deepLinkDelegate = self;

    // Set the OneLink template id for share invite links
    [AppsFlyerLib shared].appInviteOneLinkID = @"H5hv";

    // Required before listener registration if app supports Universal Links
    [[AppsFlyerLib shared] handleLaunchOptions:launchOptions];

#pragma mark - [Matrix flag] Session-ready listener (v7 default spine)
    [[AppsFlyerLib shared] registerSessionReadyListener:^{
#pragma mark - [Matrix flag] ATT
        // ATT request goes here if the app needs it before start
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"[AFSDK] start failed: %@", error);
                        return;
                    }
                    NSLog(@"[AFSDK] start succeeded: %@", dictionary);
                }];
            }];
        } else {
            [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"[AFSDK] start failed: %@", error);
                    return;
                }
                NSLog(@"[AFSDK] start succeeded: %@", dictionary);
            }];
        }
    }];

    return YES;
}
