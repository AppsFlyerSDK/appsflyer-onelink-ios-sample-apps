#import <UIKit/UIKit.h>
#import "DLViewController.h"

@interface PeachesViewController : DLViewController

@property (strong, nonatomic) NSDictionary *deepLinkData;

- (NSAttributedString *)attributionDataToString:(NSDictionary *)data;
- (NSString *)getFruitAmount:(NSDictionary *)data;

@end
