//
//  CrossPromotionHelper.h
//  AppsFlyerLib
//
//  Created by Gil Meroz on 27/01/2017.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 AppsFlyer allows you to log and attribute installs originating
 from cross promotion campaigns of your existing apps.
 Afterwards, you can optimize on your cross-promotion traffic to get even better results.
 */
@interface AppsFlyerCrossPromotionHelper : NSObject

/**
 To log an impression use the following API call.
 Make sure to use the promoted App ID as it appears within the AppsFlyer dashboard.

 @param appId Promoted App ID
 @param campaign A campaign name
 @param userParams Additional params like `@{@"af_sub1": @"val", @"custom_param": @"val2" }`
*/
+ (void)logCrossPromoteImpression:(nonnull NSString *)appId
                         campaign:(nullable NSString *)campaign
                       userParams:(nullable NSDictionary *)userParams;

/**
 iOS allows you to utilize the StoreKit component to open
 the App Store while remaining in the context of your app.
 More details at https://support.appsflyer.com/hc/en-us/articles/115004481946-Cross-Promotion-Tracking#tracking-cross-promotion-impressions

 @param promotedAppId Promoted App ID
 @param campaign A campaign name
 @param userParams Additional params like `@{@"af_sub1": @"val", @"custom_param": @"val2" }`
 @param openStoreBlock Contains promoted `clickURL`
 */
+ (void)logAndOpenStore:(nonnull NSString *)promotedAppId
               campaign:(nullable NSString *)campaign
             userParams:(nullable NSDictionary *)userParams
              openStore:(void (^)(NSURLSession *urlSession, NSURL *clickURL))openStoreBlock;

@end

NS_ASSUME_NONNULL_END
