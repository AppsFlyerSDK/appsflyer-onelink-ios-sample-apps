//
//  AFSDKPurchaseDetails.h
//  AppsFlyerLib
//
//  Created by Moris Gateno on 13/03/2024.
//

@interface AFSDKPurchaseDetails : NSObject

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@property (strong, nullable, nonatomic) NSString *productId;
@property (strong, nullable, nonatomic) NSString *price;
@property (strong, nullable, nonatomic) NSString *currency;
@property (strong, nullable, nonatomic) NSString *transactionId;

- (instancetype _Nonnull )initWithProductId:(NSString *_Nullable)productId
                                      price:(NSString *_Nullable)price
                                   currency:(NSString *_Nullable)currency
                              transactionId:(NSString *_Nullable)transactionId;

@end
