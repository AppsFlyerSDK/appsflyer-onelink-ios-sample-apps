#import <UIKit/UIKit.h>
#import "DLViewController.h"

@interface ApplesViewController : DLViewController

@property (strong, nonatomic) NSDictionary *deepLinkData;

- (NSAttributedString *)attributionDataToString:(NSDictionary *)data;
- (NSString *)getFruitAmount:(NSDictionary *)data;

@end
