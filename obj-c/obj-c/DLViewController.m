#import "DLViewController.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

@interface DLViewController ()

//@property (nonatomic, strong) NSDictionary<NSString *, id> *deepLinkData;
//@property (nonatomic, copy) NSString *fruitAmountStr;

- (void)copyShareInviteLinkWithFruitName:(NSString *)fruitName;
@end

//#import "AppsFlyerLib/AppsFlyerLib.h"



@implementation DLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSMutableAttributedString *)attributionDataToStringWithData:(NSDictionary<NSString *, id> *)data {
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] init];
    NSDictionary *boldAttribute = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next Bold" size:18.0]};
    NSDictionary *regularAttribute = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18.0]};

    NSArray<NSString *> *sortedKeys = [data.allKeys sortedArrayUsingSelector:@selector(compare:)];

    for (NSString *key in sortedKeys) {
        NSLog(@"ViewController %@ : %@", key, data[key] ?: @"null");

        NSAttributedString *boldKeyStr = [[NSAttributedString alloc] initWithString:key attributes:boldAttribute];
        [newString appendAttributedString:boldKeyStr];

        NSString *valueStr;

        if ([data[key] isKindOfClass:[NSString class]]) {
            valueStr = data[key];
        } else if ([data[key] isKindOfClass:[NSNumber class]]) {
            valueStr = [(NSNumber *)data[key] stringValue];
        } else {
            valueStr = @"null";
        }

        NSAttributedString *normalValueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@\n", valueStr] attributes:regularAttribute];
        [newString appendAttributedString:normalValueStr];
    }

    return newString;
}

- (void)showToastWithMessage:(NSString *)message font:(UIFont *)font {
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75, 20, 150, 35)];
    toastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.font = font;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.text = message;
    toastLabel.alpha = 1.0;
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = YES;
    [self.view addSubview:toastLabel];

    [UIView animateWithDuration:4.0 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toastLabel.alpha = 0.0;
    } completion:^(BOOL isCompleted) {
        [toastLabel removeFromSuperview];
    }];
}

- (void)copyShareInviteLinkWithFruitName:(NSString *)fruitName {
    [AppsFlyerShareInviteHelper generateInviteUrlWithLinkGenerator:^AppsFlyerLinkGenerator *(AppsFlyerLinkGenerator *generator) {
        [generator addParameterValue:fruitName forKey:@"deep_link_value"];
        [generator addParameterValue:self.fruitAmountStr forKey:@"deep_link_sub1"];
        [generator addParameterValue:@"THIS_USER_ID" forKey:@"deep_link_sub2"];
        [generator setCampaign:@"share_invite"];
        [generator setChannel:@"mobile_share"];
//        [[AppsFlyerLib shared] setAppInviteOneLinkID:@"H5hv"];
        [AppsFlyerLib shared].appInviteOneLinkID = @"H5hv";
//        [[AppsFlyerLib shared]setAppInviteOneLink];
        return generator;
    } completionHandler:^(NSURL *url) {
        if (url) {
            // Copy url to clipboard
            [UIPasteboard generalPasteboard].string = url.absoluteString;
            // Show toast to let the user know the link has been copied to clipboard
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastWithMessage:@"Link copied to clipboard" font:[UIFont systemFontOfSize:12.0]];
            });

            [AppsFlyerShareInviteHelper logInvite:@"mobile_share"
                                       parameters:@{@"referrerId": @"THIS_USER_ID",
                                                    @"campaign": @"share_invite"}];
        } else {
            NSLog(@"url is nil");
        }
    }];
}

- (NSString *)getFruitAmountWithData:(NSDictionary<NSString *, id> *)data {
    // Make sure either deep_link_sub1 or fruit_amount exists
    NSSet<NSString *> *keys = [NSSet setWithArray:data.allKeys];
    id fruitAmount = nil;

    if ([keys containsObject:@"deep_link_value"] && [keys containsObject:@"deep_link_sub1"]) {
        fruitAmount = data[@"deep_link_sub1"];
        NSLog(@"deep_link_sub1 found and is %@", fruitAmount);
    } else if ([keys containsObject:@"fruit_name"] && [keys containsObject:@"fruit_amount"]) {
        fruitAmount = data[@"fruit_amount"];
        NSLog(@"fruit_amount found and is %@", fruitAmount);
    } else {
        NSLog(@"deep_link_sub1/fruit_amount not found");
        return nil;
    }

    // Make sure fruitAmount is a valid number
    NSCharacterSet *decimalDigits = [NSCharacterSet decimalDigitCharacterSet];
    if ([fruitAmount isKindOfClass:[NSString class]] && [decimalDigits isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:(NSString *)fruitAmount]]) {
        self.fruitAmountStr = (NSString *)fruitAmount;
        return (NSString *)fruitAmount;
    } else {
        NSLog(@"[AFSDK] Fruit amount is not a whole number");
        return nil;
    }
}

@end
