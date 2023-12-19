#import "ConversionDataViewController.h"
#import "AppDelegate.h"

@implementation ConversionDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"aaa from CDA");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    id conversionData = appDelegate.conversionData;
    NSLog(@"aaa from CDA %@",conversionData);
    
    NSLog(@"aaa from CDA %@",[self attributionDataToStringWithData:conversionData]);


    if (conversionData != nil && [conversionData isKindOfClass:[NSDictionary class]]) {
        self.conversionDataParams.attributedText = [self attributionDataToStringWithData:conversionData];
        self.conversionDataParams.textColor = [UIColor blackColor]; // Available in iOS 13.0 and later

    }
}

- (NSAttributedString *)attributionDataToStringWithData:(NSDictionary *)data {
    // Implement your conversion logic here
    // For example, you can create an NSAttributedString with data
    NSString *string = [NSString stringWithFormat:@"%@", data];
    return [[NSAttributedString alloc] initWithString:string];
}

@end
