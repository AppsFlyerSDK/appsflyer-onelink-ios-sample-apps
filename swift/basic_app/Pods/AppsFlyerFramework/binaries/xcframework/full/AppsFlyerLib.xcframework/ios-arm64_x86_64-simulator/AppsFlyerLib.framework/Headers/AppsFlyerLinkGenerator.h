//
//  LinkGenerator.h
//  AppsFlyerLib
//
//  Created by Gil Meroz on 27/01/2017.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Payload container for the `generateInviteLinkWithLinkGenerator:completionHandler:` from `AppsFlyerShareInviteHelper`
 */
@interface AppsFlyerLinkGenerator : NSObject

/// Instance initialization is not allowed. Use generated instance
/// from `-[AppsFlyerShareInviteHelper generateInviteLinkWithLinkGenerator:completionHandler]`
- (instancetype)init NS_UNAVAILABLE;
/// Instance initialization is not allowed. Use generated instance
/// from `-[AppsFlyerShareInviteHelper generateInviteLinkWithLinkGenerator:completionHandler]`
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic, nullable, copy) NSString *brandDomain;

/// The channel through which the invite was sent (e.g. Facebook/Gmail/etc.). Usage: Recommended
- (void)setChannel           :(nonnull NSString *)channel;
/// ReferrerCustomerId setter
- (void)setReferrerCustomerId:(nonnull NSString *)referrerCustomerId;
/// A campaign name. Usage: Optional
- (void)setCampaign          :(nonnull NSString *)campaign;
/// ReferrerUID setter
- (void)setReferrerUID       :(nonnull NSString *)referrerUID;
/// Referrer name
- (void)setReferrerName      :(nonnull NSString *)referrerName;
/// The URL to referrer user avatar. Usage: Optional
- (void)setReferrerImageUrl  :(nonnull NSString *)referrerImageUrl;
/// Base deeplink path
- (void)setBaseDeepLink      :(nonnull NSString *)baseDeepLink;
/// A single key value custom parameter. Usage: Optional
- (void)addParameterValue    :(nonnull NSString *)value forKey:(NSString *)key;
/// Multiple key value custom parameters. Usage: Optional
- (void)addUserParams        :(nonnull NSDictionary *)userParams;

@end

NS_ASSUME_NONNULL_END
