//
//  AppsFlyerLib.h
//  AppsFlyerLib
//
//  AppsFlyer iOS SDK 6.12.2 (999)
//  Copyright (c) 2012-2023 AppsFlyer Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppsFlyerLib/AppsFlyerCrossPromotionHelper.h>
#import <AppsFlyerLib/AppsFlyerShareInviteHelper.h>
#import <AppsFlyerLib/AppsFlyerDeepLinkResult.h>
#import <AppsFlyerLib/AppsFlyerDeepLink.h>
#import <AppsFlyerLib/AFSDKPurchaseType.h>
#import <AppsFlyerLib/AFSDKPurchaseDetails.h>
#import <AppsFlyerLib/AFSDKValidateAndLogResult.h>
#import <AppsFlyerLib/AFAdRevenueData.h>


NS_ASSUME_NONNULL_BEGIN

// In app event names constants
#define AFEventLevelAchieved            @"af_level_achieved"
#define AFEventAddPaymentInfo           @"af_add_payment_info"
#define AFEventAddToCart                @"af_add_to_cart"
#define AFEventAddToWishlist            @"af_add_to_wishlist"
#define AFEventCompleteRegistration     @"af_complete_registration"
#define AFEventTutorial_completion      @"af_tutorial_completion"
#define AFEventInitiatedCheckout        @"af_initiated_checkout"
#define AFEventPurchase                 @"af_purchase"
#define AFEventRate                     @"af_rate"
#define AFEventSearch                   @"af_search"
#define AFEventSpentCredits             @"af_spent_credits"
#define AFEventAchievementUnlocked      @"af_achievement_unlocked"
#define AFEventContentView              @"af_content_view"
#define AFEventListView                 @"af_list_view"
#define AFEventTravelBooking            @"af_travel_booking"
#define AFEventShare                    @"af_share"
#define AFEventInvite                   @"af_invite"
#define AFEventLogin                    @"af_login"
#define AFEventReEngage                 @"af_re_engage"
#define AFEventUpdate                   @"af_update"
#define AFEventOpenedFromPushNotification @"af_opened_from_push_notification"
#define AFEventLocation                 @"af_location_coordinates"
#define AFEventCustomerSegment          @"af_customer_segment"

#define AFEventSubscribe                @"af_subscribe"
#define AFEventStartTrial               @"af_start_trial"
#define AFEventAdClick                  @"af_ad_click"
#define AFEventAdView                   @"af_ad_view"

// In app event parameter names
#define AFEventParamContent                @"af_content"
#define AFEventParamAchievementId          @"af_achievement_id"
#define AFEventParamLevel                  @"af_level"
#define AFEventParamScore                  @"af_score"
#define AFEventParamSuccess                @"af_success"
#define AFEventParamPrice                  @"af_price"
#define AFEventParamContentType            @"af_content_type"
#define AFEventParamContentId              @"af_content_id"
#define AFEventParamContentList            @"af_content_list"
#define AFEventParamCurrency               @"af_currency"
#define AFEventParamQuantity               @"af_quantity"
#define AFEventParamRegistrationMethod     @"af_registration_method"
#define AFEventParamPaymentInfoAvailable   @"af_payment_info_available"
#define AFEventParamMaxRatingValue         @"af_max_rating_value"
#define AFEventParamRatingValue            @"af_rating_value"
#define AFEventParamSearchString           @"af_search_string"
#define AFEventParamDateA                  @"af_date_a"
#define AFEventParamDateB                  @"af_date_b"
#define AFEventParamDestinationA           @"af_destination_a"
#define AFEventParamDestinationB           @"af_destination_b"
#define AFEventParamDescription            @"af_description"
#define AFEventParamClass                  @"af_class"
#define AFEventParamEventStart             @"af_event_start"
#define AFEventParamEventEnd               @"af_event_end"
#define AFEventParamLat                    @"af_lat"
#define AFEventParamLong                   @"af_long"
#define AFEventParamCustomerUserId         @"af_customer_user_id"
#define AFEventParamValidated              @"af_validated"
#define AFEventParamRevenue                @"af_revenue"
#define AFEventProjectedParamRevenue       @"af_projected_revenue"
#define AFEventParamNetRevenue             @"af_net_revenue"
#define AFEventParamReceiptId              @"af_receipt_id"
#define AFEventParamTutorialId             @"af_tutorial_id"
#define AFEventParamVirtualCurrencyName    @"af_virtual_currency_name"
#define AFEventParamDeepLink               @"af_deep_link"
#define AFEventParamOldVersion             @"af_old_version"
#define AFEventParamNewVersion             @"af_new_version"
#define AFEventParamReviewText             @"af_review_text"
#define AFEventParamCouponCode             @"af_coupon_code"
#define AFEventParamOrderId                @"af_order_id"
#define AFEventParam1                      @"af_param_1"
#define AFEventParam2                      @"af_param_2"
#define AFEventParam3                      @"af_param_3"
#define AFEventParam4                      @"af_param_4"
#define AFEventParam5                      @"af_param_5"
#define AFEventParam6                      @"af_param_6"
#define AFEventParam7                      @"af_param_7"
#define AFEventParam8                      @"af_param_8"
#define AFEventParam9                      @"af_param_9"
#define AFEventParam10                     @"af_param_10"
#define AFEventParamTouch                  @"af_touch_obj"
#define AFEventParamNetworkToken           @"net_token"

#define AFEventParamDepartingDepartureDate  @"af_departing_departure_date"
#define AFEventParamReturningDepartureDate  @"af_returning_departure_date"
#define AFEventParamDestinationList         @"af_destination_list"  //array of string
#define AFEventParamCity                    @"af_city"
#define AFEventParamRegion                  @"af_region"
#define AFEventParamCountry                 @"af_country"


#define AFEventParamDepartingArrivalDate    @"af_departing_arrival_date"
#define AFEventParamReturningArrivalDate    @"af_returning_arrival_date"
#define AFEventParamSuggestedDestinations   @"af_suggested_destinations" //array of string
#define AFEventParamTravelStart             @"af_travel_start"
#define AFEventParamTravelEnd               @"af_travel_end"
#define AFEventParamNumAdults               @"af_num_adults"
#define AFEventParamNumChildren             @"af_num_children"
#define AFEventParamNumInfants              @"af_num_infants"
#define AFEventParamSuggestedHotels         @"af_suggested_hotels" //array of string

#define AFEventParamUserScore               @"af_user_score"
#define AFEventParamHotelScore              @"af_hotel_score"
#define AFEventParamPurchaseCurrency        @"af_purchase_currency"

#define AFEventParamPreferredStarRatings    @"af_preferred_star_ratings"    //array of int (basically a tuple (min,max) but we'll use array of int and instruct the developer to use two values)

#define AFEventParamPreferredPriceRange     @"af_preferred_price_range"    //array of int (basically a tuple (min,max) but we'll use array of int and instruct the developer to use two values)
#define AFEventParamPreferredNeighborhoods  @"af_preferred_neighborhoods" //array of string
#define AFEventParamPreferredNumStops       @"af_preferred_num_stops"


@class AppsFlyerConsent;

typedef NS_CLOSED_ENUM(NSInteger, AFSDKPlugin) {
    AFSDKPluginIOSNative,
    AFSDKPluginUnity,
    AFSDKPluginFlutter,
    AFSDKPluginReactNative,
    AFSDKPluginAdobeAir,
    AFSDKPluginAdobeMobile,
    AFSDKPluginCocos2dx,
    AFSDKPluginCordova,
    AFSDKPluginMparticle,
    AFSDKPluginNativeScript,
    AFSDKPluginExpo,
    AFSDKPluginUnreal,
    AFSDKPluginXamarin,
    AFSDKPluginCapacitor,
    AFSDKPluginSegment,
    AFSDKPluginAdobeSwiftAEP
} NS_SWIFT_NAME(Plugin);


NS_SWIFT_NAME(AppsFlyerDeepLinkDelegate)
@protocol AppsFlyerDeepLinkDelegate <NSObject>

@optional
- (void)didResolveDeepLink:(AppsFlyerDeepLinkResult *_Nonnull)result;

@end

/**
 Conform and subscribe to this protocol to allow getting data about conversion and
 install attribution
 */
@protocol AppsFlyerLibDelegate <NSObject>

/**
 `conversionInfo` contains information about install.
 Organic/non-organic, etc.
 @param conversionInfo May contain <code>null</code> values for some keys. Please handle this case.
 */
- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo;

/**
 Any errors that occurred during the conversion request.
 */
- (void)onConversionDataFail:(NSError *)error;

@optional

/**
 @abstract Sets the HTTP header fields of the ESP resolving to the given
 dictionary.
 @discussion This method replaces all header fields that may have
 existed before this method ESP resolving call.
 To keep default SDK behavior - return nil;
 */
- (NSDictionary <NSString *, NSString *> * _Nullable)allHTTPHeaderFieldsForResolveDeepLinkURL:(NSURL *)URL;

@end

/**
 You can log installs, app updates, sessions and additional in-app events
 (including in-app purchases, game levels, etc.)
 to evaluate ROI and user engagement.
 The iOS SDK is compatible with all iOS/tvOS devices with iOS version 7 and above.
 
 @see [SDK Integration Validator](https://support.appsflyer.com/hc/en-us/articles/207032066-AppsFlyer-SDK-Integration-iOS)
 for more information.
 
 */
@interface AppsFlyerLib : NSObject

/**
 Gets the singleton instance of the AppsFlyerLib class, creating it if
 necessary.
 
 @return The singleton instance of AppsFlyerLib.
 */
+ (AppsFlyerLib *)shared;

/// Use this method to initialize the SDK with your credentials.
/// This must be called before calling `start`.
///
/// @param devKey Your AppsFlyer developer key.
/// @param appId Your app's Apple App ID (e.g., "123456789").
- (void)initWithDevKey:(NSString *)devKey appleAppId:(NSString *)appId
NS_SWIFT_NAME(initialize(devKey:appId:));


- (void)setUpInteroperabilityObject:(id)object;

/**
 In case you use your own user ID in your app, you can set this property to that ID.
 Enables you to cross-reference your own unique ID with AppsFlyer’s unique ID and the other devices’ IDs
 */
@property(nonatomic, strong, nullable) NSString * customerUserID;

/**
 In case you use custom data and you want to receive it in the raw reports.
 
 @see [Setting additional custom data](https://support.appsflyer.com/hc/en-us/articles/207032066-AppsFlyer-SDK-Integration-iOS#setting-additional-custom-data) for more information.
 */
@property(nonatomic, strong, nullable) NSDictionary * customData;

/**
 Use this property to get your AppsFlyer's dev key
 */
@property(nonatomic, readonly) NSString * appsFlyerDevKey;

/**
 Use this property to get your app's Apple ID(taken from the app's page on iTunes Connect)
 */
@property(nonatomic, readonly) NSString * appleAppID;

#ifndef AFSDK_NO_IDFA
/**
 AppsFlyer SDK collect Apple's `advertisingIdentifier` if the `AdSupport.framework` included in the SDK.
 You can disable this behavior by setting the following property to YES
*/
@property(nonatomic) BOOL disableAdvertisingIdentifier;

@property(nonatomic, strong, readonly) NSString *advertisingIdentifier;

/**
 Waits for request user authorization to access app-related data
 */
- (void)waitForATTUserAuthorizationWithTimeoutInterval:(NSTimeInterval)timeoutInterval
    DEPRECATED_MSG_ATTRIBUTE("Use registerSessionReadyListener: instead. Register the listener in didFinishLaunching and call start() inside it. If ATT consent is needed before start, collect it inside the listener block. The SDK no longer manages ATT timing internally.")
    NS_SWIFT_NAME(waitForATTUserAuthorization(timeoutInterval:));

#endif

@property(nonatomic) BOOL disableSKAdNetwork;

/**
 In case of in app purchase events, you can set the currency code your user has purchased with.
 The currency code is a 3 letter code according to ISO standards
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] setCurrencyCode:@"USD"];
 </pre>
 
 Swift:
 
 <pre>
 AppsFlyerLib.shared().currencyCode = "USD"
 </pre>
 */
@property(nonatomic, strong, nullable) NSString *currencyCode;

/**
 Prints SDK messages to the console log. This property should only be used in `DEBUG` mode.
 The default value is `NO`
 */
@property(nonatomic, setter=isDebug:) BOOL isDebug;

/**
 Set this flag to `YES`, to collect the current device name(e.g. "My iPhone"). Default value is `NO`
 */
@property(nonatomic) BOOL shouldCollectDeviceName;

/**
 Set your `OneLink ID` from OneLink configuration. Used in User Invites to generate a OneLink.
 */
@property(nonatomic, strong, nullable, setter = setAppInviteOneLink:) NSString * appInviteOneLinkID;

/**
 Opt-out logging for specific user
 */
@property(atomic, setter=anonymizeUser:) BOOL anonymizeUser;

/**
 Opt-out for Apple Search Ads attributions
 */
@property(atomic) BOOL disableCollectASA;

/**
 Disable Apple Ads Attribution API +[AAAtribution attributionTokenWithError:]
 */
@property(nonatomic) BOOL disableAppleAdsAttribution;

/**
 AppsFlyer delegate. See `AppsFlyerLibDelegate`
 */
@property(weak, nonatomic) id<AppsFlyerLibDelegate> delegate;

@property(weak, nonatomic) id<AppsFlyerDeepLinkDelegate> deepLinkDelegate;

/**
 In app purchase receipt validation Apple environment(production or sandbox). The default value is NO
 */
@property(nonatomic) BOOL useReceiptValidationSandbox;

/**
 Set this flag to test uninstall on Apple environment(production or sandbox). The default value is NO
 */
@property(nonatomic) BOOL useUninstallSandbox;

/**
 For advertisers who wrap OneLink within another Universal Link.
 An advertiser will be able to deeplink from a OneLink wrapped within another Universal Link and also log this retargeting conversion.
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] setResolveDeepLinkURLs:@[@"domain.com", @"subdomain.domain.com"]];
 </pre>
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *resolveDeepLinkURLs;

/**
 For advertisers who use vanity OneLinks.
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] oneLinkCustomDomains:@[@"domain.com", @"subdomain.domain.com"]];
 </pre>
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *oneLinkCustomDomains;

/**
 To disable app's vendor identifier(IDFV), set disableIDFVCollection to true
 */
@property(nonatomic) BOOL disableIDFVCollection;

/**
 Set the language of the device. The data will be displayed in Raw Data Reports
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] setCurrentDeviceLanguage:@"EN"]
 </pre>
 
 Swift:
 
 <pre>
 AppsFlyerLib.shared().currentDeviceLanguage("EN")
 </pre>
 */
@property(nonatomic, nullable, copy) NSString *currentDeviceLanguage;

/**
 Internal API. Please don't use.
 */
- (void)setPluginInfoWith:(AFSDKPlugin)plugin
            pluginVersion:(NSString *)version
         additionalParams:(NSDictionary * _Nullable)additionalParams
NS_SWIFT_NAME(setPluginInfo(plugin:version:additionalParams:));

/**
 Enable the collection of Facebook Deferred AppLinks
 Requires Facebook SDK and Facebook app on target/client device.
 This API must be invoked prior to initializing the AppsFlyer SDK in order to function properly.
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] enableFacebookDeferredApplinksWithClass:[FBSDKAppLinkUtility class]]
 </pre>
 
 Swift:
 
 <pre>
 AppsFlyerLib.shared().enableFacebookDeferredApplinks(with: FBSDKAppLinkUtility.self)
 </pre>
 
 @param facebookAppLinkUtilityClass requeries method call `[FBSDKAppLinkUtility class]` as param.
 */
- (void)enableFacebookDeferredApplinksWithClass:(Class _Nullable)facebookAppLinkUtilityClass;

#pragma mark - Hashed PII collection

/**
 Hashed PII setters. Values are normalized and SHA-256 hashed before being
 appended to attribution and event payloads.

 The integrating app must declare the relevant @c NSPrivacyCollectedDataTypes
 entries in its own @c PrivacyInfo.xcprivacy manifest — the SDK does not.
 */

/// Sets the user's email. Sent as @c email_hashed.
- (void)setUserEmail:(NSString *)email NS_SWIFT_NAME(setUserEmail(_:));

/**
 Sets the user's phone number. Sent as two variants:
   - @c phone_number_hashed: digits-only, leading zeros stripped.
   - @c phone_number_e164_hashed: '+' prefix followed by digits.
 */
- (void)setUserPhoneWithCountryCode:(NSString *)countryCode
                        phoneNumber:(NSString *)phoneNumber
    NS_SWIFT_NAME(setUserPhone(countryCode:phoneNumber:));

/// Sets the user's first name. Sent as @c first_name_hashed.
- (void)setUserFirstName:(NSString *)firstName NS_SWIFT_NAME(setUserFirstName(_:));

/// Sets the user's last name. Sent as @c last_name_hashed.
- (void)setUserLastName:(NSString *)lastName NS_SWIFT_NAME(setUserLastName(_:));

/**
 Sets the user's Facebook App-Scoped ID. Sent as @c fb_login_id (integer, not hashed).

 @c 0 is the unset sentinel and suppresses the field — Facebook App-Scoped IDs
 are never 0. Pass @c 0 to clear without calling @c clearUserPii.
 */
- (void)setUserFbLoginId:(int64_t)fbLoginId NS_SWIFT_NAME(setUserFbLoginId(_:));

/// Clears all hashed-PII fields set via the @c setUser* APIs above.
- (void)clearUserPii NS_SWIFT_NAME(clearUserPii());

/**
 Starts an SDK session.
 Call this inside a @c registerSessionReadyListener: block, not directly in
 @c applicationDidBecomeActive: — use the session readiness listener instead.
 */
- (void)start;

- (void)startWithCompletionHandler:(void (^ _Nullable)(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error))completionHandler;

#pragma mark - Session Readiness

/// Block invoked on the main queue when all session-readiness conditions are satisfied.
typedef void (^AppsFlyerSessionReadyListener)(void);

/**
 * Pre-registers a Universal Link deeplink from cold launch options.
 *
 * Call in @c application:didFinishLaunchingWithOptions: before @c registerSessionReadyListener:.
 * If @c launchOptions contains a Universal Link, session readiness waits for it to resolve
 * before firing. No-op if no Universal Link is present.
 */
- (void)handleLaunchOptions:(nullable NSDictionary *)launchOptions
    NS_SWIFT_NAME(handleLaunchOptions(_:));

/**
 * Registers a block invoked once per foreground cycle when the SDK is ready for @c start.
 *
 * Call @c start inside the block. The SDK does not call @c start automatically.
 *
 * @code
 * [[AppsFlyerLib shared] registerSessionReadyListener:^{
 *     [[AppsFlyerLib shared] start];
 * }];
 * @endcode
 *
 * Call in @c application:didFinishLaunchingWithOptions:, after @c handleLaunchOptions:
 * if you support Universal Links.
 *
 * Readiness conditions:
 * - Config: @c devKey and @c appleAppID must be set before the listener fires.
 * - Deeplink: evaluated for both cold-launch (@c handleLaunchOptions:) and warm-launch
 *   (@c continueUserActivity:) Universal Links. Has a bounded timeout so the listener
 *   always fires.
 *
 * Always dispatched on the main queue. Fires once per foreground cycle; resets on
 * background. A second call replaces the current listener.
 *
 * @note ATT is not a readiness condition. If ATT consent is needed before @c start,
 * collect it inside the block.
 */
- (void)registerSessionReadyListener:(AppsFlyerSessionReadyListener)listener
    NS_SWIFT_NAME(registerSessionReadyListener(_:));

/**
 * Removes the registered session-ready listener. No-op if none is registered.
 */
- (void)unregisterSessionReadyListener
    NS_SWIFT_NAME(unregisterSessionReadyListener());

/**
 * Returns YES if the session-ready listener has been fired in the current foreground cycle.
 */
- (BOOL)isSessionReady
    NS_SWIFT_NAME(isSessionReady());

/**
 Use this method to log an events with multiple values. See AppsFlyer's documentation for details.
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] logEvent:AFEventPurchase
        withValues: @{AFEventParamRevenue  : @200,
                      AFEventParamCurrency : @"USD",
                      AFEventParamQuantity : @2,
                      AFEventParamContentId: @"092",
                      AFEventParamReceiptId: @"9277"}];
 </pre>
 
 Swift:
 
 <pre>
 AppsFlyerLib.shared().logEvent(AFEventPurchase,
        withValues: [AFEventParamRevenue  : "1200",
                     AFEventParamContent  : "shoes",
                     AFEventParamContentId: "123"])
 </pre>
 
 @param eventName Contains name of event that could be provided from predefined constants in `AppsFlyerLib.h`
 @param values Contains dictionary of values for handling by backend
 */
- (void)logEvent:(NSString *)eventName withValues:(NSDictionary * _Nullable)values;

- (void)logEventWithEventName:(NSString *)eventName
                  eventValues:(NSDictionary<NSString * , id> * _Nullable)eventValues
            completionHandler:(void (^ _Nullable)(NSDictionary<NSString *, id> * _Nullable dictionary, NSError * _Nullable error))completionHandler
NS_SWIFT_NAME(logEvent(name:values:completionHandler:));

typedef void (^AFSDKValidateAndLogCompletion)(AFSDKValidateAndLogResult * _Nullable result);

/**
 Validates and logs an in-app purchase using the updated VAL V2 flow.

 This method should be called after a successful transaction, typically from:
 - `paymentQueue:updatedTransactions:` in your `SKPaymentTransactionObserver` (StoreKit 1)
 - `transaction.listener` or `.finishTransaction()` or  `VerificationResult<SignedType>` in StoreKit 2 (iOS 15+)

 @param purchaseDetails a `AFSDKPurchaseDetails` object. Must include:
    - `productId` (non-empty)
    - `transactionId` (non-empty)
    - `purchaseType` ( `.subscription`, `.oneTimePurchase`)
 
 @param purchaseAdditionalDetails Optional metadata associated with the purchase
 (previously known as `extraEventValues`). This can include custom app-level context.

 @param completion Completion block with either a response dictionary or an NSError.
 On success: `response` contains a parsed result.
 On failure: `error` describes the reason (validation failure, networking issue...)
 */
- (void)validateAndLogInAppPurchase:(AFSDKPurchaseDetails *)purchaseDetails
          purchaseAdditionalDetails:(NSDictionary * _Nullable)purchaseAdditionalDetails
                         completion:(void (^)(NSDictionary * _Nullable response, NSError * _Nullable error))completion
NS_SWIFT_NAME(validateAndLogInAppPurchase(purchaseDetails:purchaseAdditionalDetails:completion:));

/**
 An API to provide the data from the impression payload to AdRevenue.
 
 @param adRevenueData object used to hold all mandatory parameters of AdRevenue event.
 @param additionalParameters non-mandatory dictionary which can include pre-defined keys (kAppsFlyerAdRevenueCountry, etc)
 */
- (void)logAdRevenue:(AFAdRevenueData *)adRevenueData additionalParameters:(NSDictionary * _Nullable)additionalParameters;

/**
 To log location for geo-fencing. Does the same as code below.
 
 <pre>
 AppsFlyerLib.shared().logEvent(AFEventLocation, withValues: [AFEventParamLong:longitude, AFEventParamLat:latitude])
 </pre>
 
 @param longitude The location longitude
 @param latitude The location latitude
 */
- (void)logLocation:(double)longitude latitude:(double)latitude NS_SWIFT_NAME(logLocation(longitude:latitude:));

/**
 This method returns AppsFlyer's internal id(unique for your app)
 
 @return Internal AppsFlyer Id
 */
- (NSString *)getAppsFlyerUID;

/**
 In case you want to log deep linking. Does the same as `-handleOpenURL:sourceApplication:withAnnotation`.
 
 @warning Preferred to use `-handleOpenURL:sourceApplication:withAnnotation`.
 
 @param url The URL that was passed to your AppDelegate.
 @param sourceApplication The sourceApplication that passed to your AppDelegate.
 */
- (void)handleOpenURL:(NSURL * _Nullable)url sourceApplication:(NSString * _Nullable)sourceApplication API_UNAVAILABLE(macos);

/**
 In case you want to log deep linking.
 Call this method from inside your AppDelegate `-application:openURL:sourceApplication:annotation:`
 
 @param url The URL that was passed to your AppDelegate.
 @param sourceApplication The sourceApplication that passed to your AppDelegate.
 @param annotation The annotation that passed to your app delegate.
 */
- (void)handleOpenURL:(NSURL * _Nullable)url
    sourceApplication:(NSString * _Nullable)sourceApplication
       withAnnotation:(id _Nullable)annotation API_UNAVAILABLE(macos);

/**
 Call this method from inside of your AppDelegate `-application:openURL:options:` method.
 This method is functionally the same as calling the AppsFlyer method
 `-handleOpenURL:sourceApplication:withAnnotation`.
 
 @param url The URL that was passed to your app delegate
 @param options The options dictionary that was passed to your AppDelegate.
 */
- (void)handleOpenUrl:(NSURL * _Nullable)url options:(NSDictionary * _Nullable)options API_UNAVAILABLE(macos);

/**
 Allow AppsFlyer to handle restoration from an NSUserActivity.
 Use this method to log deep links with OneLink.
 
 @param userActivity The NSUserActivity that caused the app to be opened.
 */
- (BOOL)continueUserActivity:(NSUserActivity * _Nullable)userActivity
          restorationHandler:(void (^ _Nullable)(NSArray * _Nullable))restorationHandler NS_AVAILABLE_IOS(9_0) API_UNAVAILABLE(macos);

/**
 Handle a link delivered as a bare URL from SwiftUI `.onOpenURL`.

 SwiftUI apps receive both universal links and custom-scheme deep links as a `URL`,
 with no `NSUserActivity`, so `-continueUserActivity:restorationHandler:` is never invoked.
 You can safely route every `.onOpenURL` URL through this method: `https` URLs are
 classified as Universal Links; custom-scheme URLs (e.g. `myapp://`) are classified
 exactly as `-handleOpenUrl:options:` would classify them. No need to branch in your closure.

 @note `af_web_referrer` is not populated for universal links on Apple platforms
       (the OS no longer provides `NSUserActivity.referrerURL`); a bare URL has no referrer.
 @param url The URL that was passed to your SwiftUI `.onOpenURL` handler.
 */
- (void)handleUniversalLink:(NSURL * _Nullable)url
    NS_SWIFT_NAME(handleUniversalLink(_:)) NS_AVAILABLE_IOS(9_0) API_UNAVAILABLE(macos);

/**
 Enable AppsFlyer to handle a push notification.
 
 @see [Learn more here](https://support.appsflyer.com/hc/en-us/articles/207364076-Measuring-Push-Notification-Re-Engagement-Campaigns)
 
 @warning To make it work - set data, related to AppsFlyer under key @"af".
 
 @param pushPayload The `userInfo` from received remote notification. One of root keys should be @"af".
 */
- (void)handlePushNotification:(NSDictionary * _Nullable)pushPayload;


/**
 Register uninstall - you should register for remote notification and provide AppsFlyer the push device token.
 
 @param deviceToken The `deviceToken` from `-application:didRegisterForRemoteNotificationsWithDeviceToken:`
 */
- (void)registerUninstall:(NSData * _Nullable)deviceToken;

/**
 Get SDK version.

 @return The AppsFlyer SDK version info.
 */
- (NSString *)getSdkVersion;

/**
 This is for internal use.
 */
- (void)remoteDebuggingCallWithData:(NSString *)data;

/**
 This is for internal use.
 */
- (void)remoteDebuggingCallV2WithData:(NSString *)dataAsString;

/**
 Used to force deep link resolution via `DeepLinkDelegate.didResolveDeepLink:`.
 Notice, re-engagement, session and launch won't be counted.
 Only for OneLink/UniversalLink/Deeplink resolving.
 
 @param URL The URL to resolve.
 */
- (void)performOnAppAttributionWithURL:(NSURL * _Nullable)URL;

/**
 @brief This property accepts a string value representing the host name for all endpoints.
 Can be used to Zero rate your application’s data usage. Contact your CSM for more information.
 
 @warning To use `default` SDK endpoint – set value to `nil`.
 
 Objective-C:
 
 <pre>
 [[AppsFlyerLib shared] setHost:@"example.com"];
 </pre>
 
 Swift:
 
 <pre>
 AppsFlyerLib.shared().host = "example.com"
 </pre>
 */
@property(nonatomic, strong, readonly) NSString *host;

/**
 Sets the host prefix and host name for all SDK endpoints.

 @param hostPrefixName Prefix prepended to the endpoint hostname (first positional).
 @param hostName Base hostname for all SDK endpoints (second positional).

 @warning SDK7 migration: the selector changed from
 `setHost:withHostPrefix:` (host, hostPrefix) to `setHost:hostName:`
 (hostPrefixName, hostName). Note the argument order is swapped to match
 the Android SDK: the first positional argument is now the host prefix.
 Callers must update both the selector and argument order.
 */
- (void)setHost:(NSString *)hostPrefixName hostName:(NSString *)hostName;

/**
 * This property accepts a string value representing the prefix host name for all endpoints.
 * for example "test" prefix with default host name will have the address "host.appsflyer.com"
 */
@property(nonatomic, strong, readonly) NSString *hostPrefix;

/**
 This property is responsible for timeout between sessions in seconds.
 Default value is 5 seconds.
 */
@property(atomic) NSUInteger minTimeBetweenSessions;

/**
 API to shut down all SDK activities.

 @warning This will disable all requests from AppsFlyer SDK.
 */
@property(atomic, getter=isStopped, setter=stop:) BOOL isStopped;

/**
 API to set manually Facebook deferred app link
 */
@property(nonatomic, nullable, copy) NSURL *facebookDeferredAppLink;

/**
 Block an events from being shared with ad networks and other 3rd party integrations
 Must only include letters/digits or underscore, maximum length: 45
 */
@property(nonatomic, nullable, copy) NSArray<NSString *> *sharingFilter;

@property(nonatomic) NSUInteger deepLinkTimeout;

/**
 Block an events from being shared with ad networks and other 3rd party integrations
 Must only include letters/digits or underscore, maximum length: 45
 
 The sharing filter is cleared in case if `nil` or empty array passed as a parameter.
 "all" keyword sets sharing filter for ALL partners, it is case insencitive and has highest priority
 if passed along with another values. For example, if ["all", "examplePartner1_int", "examplePartner2_int" ] passed,
 the sharing filter will be set for ALL partners.
 */
- (void)setSharingFilterForPartners:(NSArray<NSString *> * _Nullable)sharingFilter;


/**
    Sets Custom Install Id - this overrides the default AppsFlyer Install ID.
    Only effective if Info.plist has `AppsFlyerAllowCustomInstallId=YES`
     * Must be called before calling set appsFlyerDevKey and appleAppID
    @param customID the customId.
    */
- (void)setInstallId:(NSString *)customID;

/**
    Sets or updates the user consent data related to GDPR and DMA regulations for advertising and data usage
    purposes within the application. This method must be invoked with the user's current consent status each
    time the app starts or whenever there is a change in the user's consent preferences.
    
    Note that this method does not persist the consent data across app sessions; it only applies for the
    duration of the current app session. If you wish to stop providing the consent data, you should
    cease calling this method.
     
    @param consent an instance of AppsFlyerConsent that encapsulates the user's consent information.
    */
- (void)setConsentData:(AppsFlyerConsent *)consent;

/**
    Enable the SDK to collect and send TCF data

    @param shouldCollect indicates if the TCF data collection is enabled.
 */
- (void)enableTCFDataCollection:(BOOL)shouldCollect;

/**
 Validate if URL contains certain string and append quiery
 parameters to deeplink URL. In case if URL does not contain user-defined string,
 parameters are not appended to the url.
 
 @param containsString string to check in URL.
 @param parameters NSDictionary, which containins parameters to append to the deeplink url after it passed validation.
 */
- (void)appendParametersToDeepLinkingURLWithString:(NSString *)containsString
                                        parameters:(NSDictionary<NSString *, NSString*> *)parameters
NS_SWIFT_NAME(appendParametersToDeepLinkingURL(contains:parameters:));

/**
 Adds array of keys, which are used to compose key path
 to resolve deeplink from push notification payload `userInfo`.
 
 @param deepLinkPath an array of strings which contains keys to search for deeplink in payload.
 */
- (void)addPushNotificationDeepLinkPath:(NSArray<NSString *> *)deepLinkPath;

/**
 * Allows sending custom data for partner integration purposes.
 *
 * @param partnerId ID of the partner (usually has "_int" suffix)
 * @param data customer data, depends on the integration nature with specific partner
 */

- (void)setPartnerDataWithPartnerId:(NSString * _Nullable)partnerId data:(NSDictionary<NSString *, id> * _Nullable)data
NS_SWIFT_NAME(setPartnerData(partnerId:data:));

@end

NS_ASSUME_NONNULL_END
