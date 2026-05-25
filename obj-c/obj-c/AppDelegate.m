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
#pragma mark - [Matrix flag] Debug logs
    [AppsFlyerLib shared].isDebug = YES;

    [[AppsFlyerLib shared] initWithDevKey:@"sQ84wpdxRTR4RMCaE9YqS4" appleAppId:@"1512793879"];

#pragma mark - [Matrix flag] Customer User ID (CUID)
    [AppsFlyerLib shared].customerUserID = @"my user id";

    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].deepLinkDelegate = self;
    [AppsFlyerLib shared].appInviteOneLinkID = @"H5hv";

    // Required before registerSessionReadyListener:. In iOS 13+ scene apps, UL/URI
    // cold-launch payloads are NOT in launchOptions — they arrive via connectionOptions
    // in SceneDelegate, so the two paths are mutually exclusive (no double-dispatch).
    [[AppsFlyerLib shared] handleLaunchOptions:launchOptions];

#pragma mark - [Matrix flag] Session-ready listener (v7 default spine)
    [[AppsFlyerLib shared] registerSessionReadyListener:^{
#pragma mark - [Matrix flag] ATT
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
    newVC.deepLinkData = deepLinkData;

    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:newVC animated:YES completion:nil];
}

#pragma mark - AppsFlyerDeepLinkDelegate

- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *)result {
    switch (result.status) {
        case AFSDKDeepLinkResultStatusNotFound:
            NSLog(@"[AFSDK] Deep link not found");
            return;
        case AFSDKDeepLinkResultStatusFailure:
            NSLog(@"[AFSDK] Deep link error: %@", result.error);
            return;
        case AFSDKDeepLinkResultStatusFound:
            break;
    }

    AppsFlyerDeepLink *deepLinkObj = result.deepLink;

    if (deepLinkObj.isDeferred && self.deferredDeepLinkProcessedFlag) {
        // GCD already processed this deferred deep link; skip duplicate UDL handling.
        self.deferredDeepLinkProcessedFlag = NO;
        return;
    }

    NSString *fruitNameStr = deepLinkObj.deeplinkValue;
    if (!fruitNameStr || [fruitNameStr isEqualToString:@""]) {
        id fruitNameValue = deepLinkObj.clickEvent[@"fruit_name"];
        if ([fruitNameValue isKindOfClass:[NSString class]]) {
            fruitNameStr = (NSString *)fruitNameValue;
        } else {
            NSLog(@"[AFSDK] Could not extract deep_link_value or fruit_name");
            return;
        }
    }

    // Mark for GCD path so onConversionDataSuccess skips the deferred branch.
    self.deferredDeepLinkProcessedFlag = YES;

    [self walkToSceneWithParams:fruitNameStr deepLinkData:deepLinkObj.clickEvent];
}

#pragma mark - AppsFlyerLibDelegate

- (void)onConversionDataSuccess:(NSDictionary *)data {
    self.conversionData = data;

    NSNumber *isFirstLaunch = data[@"is_first_launch"];
    if (!isFirstLaunch.boolValue) {
        return;
    }

    if (self.deferredDeepLinkProcessedFlag) {
        // UDL already processed this deferred deep link; skip GCD path.
        self.deferredDeepLinkProcessedFlag = NO;
        return;
    }
    self.deferredDeepLinkProcessedFlag = YES;

    NSString *fruitNameStr = data[@"deep_link_value"] ?: data[@"fruit_name"];
    if (!fruitNameStr) {
        NSLog(@"[AFSDK] Could not extract deep_link_value or fruit_name from conversion data");
        return;
    }

    [self walkToSceneWithParams:fruitNameStr deepLinkData:data];
}

- (void)onConversionDataFail:(NSError *)error {
    NSLog(@"[AFSDK] onConversionDataFail: %@", error);
}

@end
