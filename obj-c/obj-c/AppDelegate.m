//
//  AppDelegate.m
//  projectiv-c
//
//  Created by Test1 on 13/12/2023.
//

#import "AppDelegate.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#import "DLViewController.h"



@interface AppDelegate ()

@property (nonatomic, assign) BOOL deferredDeepLinkProcessedFlag;

@end

@implementation AppDelegate

@synthesize conversionData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set isDebug to true to see AppsFlyer debug logs
    [AppsFlyerLib shared].isDebug = YES;
    
    // Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
    [AppsFlyerLib shared].appsFlyerDevKey = @"sQ84wpdxRTR4RMCaE9YqS4";
    [AppsFlyerLib shared].appleAppID = @"1512793879";
    
    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:60];
    
    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].deepLinkDelegate = self;
    
    // Set the OneLink template id for share invite links
    [AppsFlyerLib shared].appInviteOneLinkID = @"H5hv";
    
    // Subscribe to didBecomeActiveNotification if you use SceneDelegate or just call
    // -[AppsFlyerLib start] from -[AppDelegate applicationDidBecomeActive:]
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    return YES;
}

- (void)didBecomeActiveNotification {
    [[AppsFlyerLib shared] start];
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"AuthorizationSatus is denied");
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"AuthorizationSatus is notDetermined");
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    NSLog(@"AuthorizationSatus is restricted");
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"AuthorizationSatus is authorized");
                    break;
                default:
                    NSLog(@"Invalid authorization status");
                    break;
            }
        }];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
    return YES;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
}

- (void)walkToSceneWithParams:(NSString *)fruitName deepLinkData:(NSDictionary *)deepLinkData {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[UIApplication sharedApplication].windows.firstObject.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *destVC = [fruitName stringByAppendingString:@"_vc"];
    DLViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:destVC];
    
    NSLog(@"[AFSDK] AppsFlyer routing to section: %@", destVC);
    newVC.deepLinkData = deepLinkData;
    
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:newVC animated:YES completion:nil];
}

#pragma mark - DeepLinkDelegate

- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *)result {
    NSString *fruitNameStr;
   NSLog(@"[AFSDK] Deep link lowkehy");
    switch (result.status) {
        case AFSDKDeepLinkResultStatusNotFound:
            NSLog(@"[AFSDK] Deep link not found");
            return;
        case AFSDKDeepLinkResultStatusFailure:
            NSLog(@"Error %@", result.error);
            return;
        case AFSDKDeepLinkResultStatusFound:
            NSLog(@"[AFSDK] Deep link found");
            break;
    }
    
    AppsFlyerDeepLink *deepLinkObj = result.deepLink;
    
    if ([deepLinkObj.clickEvent.allKeys containsObject:@"deep_link_sub2"]) {
        NSString *referrerId = deepLinkObj.clickEvent[@"deep_link_sub2"];
        NSLog(@"[AFSDK] AppsFlyer: Referrer ID: %@", referrerId);
    } else {
        NSLog(@"[AFSDK] Could not extract referrerId");
    }
    
    NSString *deepLinkStr = [deepLinkObj toString];
    NSLog(@"[AFSDK] DeepLink data is: %@", deepLinkStr);
    
    if (deepLinkObj.isDeferred) {
        NSLog(@"[AFSDK] This is a deferred deep link");
        if (self.deferredDeepLinkProcessedFlag) {
            NSLog(@"Deferred deep link was already processed by GCD. This iteration can be skipped.");
            self.deferredDeepLinkProcessedFlag = NO;
            return;
        }
    } else {
        NSLog(@"[AFSDK] This is a direct deep link");
    }
    
    fruitNameStr = deepLinkObj.deeplinkValue;
    
    // If deep_link_value doesn't exist
    if (!fruitNameStr || [fruitNameStr isEqualToString:@""]) {
        // Check if fruit_name exists
        id fruitNameValue = deepLinkObj.clickEvent[@"fruit_name"];
        if ([fruitNameValue isKindOfClass:[NSString class]]) {
            fruitNameStr = (NSString *)fruitNameValue;
        } else {
            NSLog(@"[AFSDK] Could not extract deep_link_value or fruit_name from deep link object with unified deep linking");
            return;
        }
    }
    
    // This marks to GCD that UDL already processed this deep link.
    // It is marked to both DL and DDL, but GCD is relevant only for DDL
    self.deferredDeepLinkProcessedFlag = YES;
    
    [self walkToSceneWithParams:fruitNameStr deepLinkData:deepLinkObj.clickEvent];
}

#pragma mark - AppsFlyerLibDelegate

- (void)onConversionDataSuccess:(NSDictionary *)data {
    self.conversionData = data;
    NSLog(@"onConversionDataSuccess data:");
    for (NSString *key in data.allKeys) {
        NSLog(@"%@: %@", key, data[key]);
    }
    
    NSString *status = data[@"af_status"];
    
    if ([status isEqualToString:@"Non-organic"]) {
        NSString *sourceID = data[@"media_source"];
        NSString *campaign = data[@"campaign"];
        NSLog(@"[AFSDK] This is a Non-Organic install. Media source: %@ Campaign: %@", sourceID, campaign);
    } else {
        NSLog(@"[AFSDK] This is an organic install.");
    }
    
    NSNumber *isFirstLaunch = data[@"is_first_launch"];
    
    if (isFirstLaunch.boolValue) {
        NSLog(@"[AFSDK] First Launch");
        
        if (self.deferredDeepLinkProcessedFlag) {
            NSLog(@"Deferred deep link was already processed by UDL. The DDL processing in GCD can be skipped.");
            self.deferredDeepLinkProcessedFlag = NO;
            return;
        }
        
        self.deferredDeepLinkProcessedFlag = YES;
        
        NSString *fruitNameStr = data[@"deep_link_value"];
        
        if (!fruitNameStr) {
            fruitNameStr = data[@"fruit_name"];
        }
        
        if (!fruitNameStr) {
            NSLog(@"Could not extract deep_link_value or fruit_name from deep link object using conversion data");
            return;
        }
        
        NSLog(@"This is a deferred deep link opened using conversion data");
        [self walkToSceneWithParams:fruitNameStr deepLinkData:data];
    } else {
        NSLog(@"[AFSDK] Not First Launch");
    }
}

- (void)onConversionDataFail:(NSError *)error {
    NSLog(@"[AFSDK] %@", error);
}

@end










//
//@interface AppDelegate ()
//
//@end
//
//@implementation AppDelegate
//
//-(void) sendLaunch: (UIApplication *)application {
//    NSLog(@"AAA in sendLaunch()");
//    [[AppsFlyerLib shared] start];
//}
//
//
//
//-(void)onConversionDataSuccess:(NSDictionary*) installData {
//    // Business logic for Non-organic install scenario is invoked
//    NSLog(@"AAA in onConversionDataSuccess()");
//    id status = [installData objectForKey:@"af_status"];
//    if([status isEqualToString:@"Non-organic"]) {
//        id sourceID = [installData objectForKey:@"media_source"];
//        id campaign = [installData objectForKey:@"campaign"];
//        NSLog(@"This is a Non-organic install. Media source: %@  Campaign: %@",sourceID,campaign);
//    }
//
//    else if([status isEqualToString:@"Organic"]) {
//        // Business logic for Organic install scenario is invoked
//        NSLog(@"This is an Organic install.");
//    }
//
//}
//
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"sQ84wpdxRTR4RMCaE9YqS4"];
//    [[AppsFlyerLib shared] setAppleAppID:@"1512793879"];
//    [[AppsFlyerLib shared] start];
//    NSLog(@"AAA in didFinishLaunchingWithOptions(). started shared instance");
//    return YES;
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [[AppsFlyerLib shared] start];
//    NSLog(@"aaa from applicationDidBecomeActive");
//    if (@available(iOS 14, *)) {
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            switch (status) {
//                case ATTrackingManagerAuthorizationStatusDenied:
//                    NSLog(@"AuthorizationSatus is denied");
//                    break;
//                case ATTrackingManagerAuthorizationStatusNotDetermined:
//                    NSLog(@"AuthorizationSatus is notDetermined");
//                    break;
//                case ATTrackingManagerAuthorizationStatusRestricted:
//                    NSLog(@"AuthorizationSatus is restricted");
//                    break;
//                case ATTrackingManagerAuthorizationStatusAuthorized:
//                    NSLog(@"AuthorizationSatus is authorized");
//                    break;
//            }
//        }];
//    }
//}
//
//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
//    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:nil];
//    return YES;
//}
//
//// Open URI-scheme for iOS 9 and above
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
//    return YES;
//}
//// Report Push Notification attribution data for re-engagements
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [[AppsFlyerLib shared] handlePushNotification:userInfo];
//}
//// User logic
//- (void)walkToSceneWithParamsWithFruitName:(NSString *)fruitName deepLinkData:(NSDictionary *)deepLinkData {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
//    [rootViewController dismissViewControllerAnimated:YES completion:nil];
//
//    NSString *destVC = [NSString stringWithFormat:@"%@_vc", fruitName];
//    DLViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:destVC];
//    
//    if (newVC != nil) {
//        NSLog(@"[AFSDK] AppsFlyer routing to section: %@", destVC);
//       newVC.deepLinkData = deepLinkData;
//        [rootViewController presentViewController:newVC animated:YES completion:nil];
//    } else {
//        NSLog(@"[AFSDK] AppsFlyer: could not find section: %@", destVC);
//    }
//}
//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:§.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}
//
//
//@end
