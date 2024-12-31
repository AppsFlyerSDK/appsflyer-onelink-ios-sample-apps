//
//  DLViewController.h
//  projectiv-c
//
//  Created by Test1 on 13/12/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLViewController : UIViewController

@property (nonatomic, strong) NSDictionary<NSString *, id> *deepLinkData;
@property (nonatomic, copy) NSString *fruitAmountStr;

- (void)copyShareInviteLinkWithFruitName:(NSString *)fruitName;
@end

NS_ASSUME_NONNULL_END
