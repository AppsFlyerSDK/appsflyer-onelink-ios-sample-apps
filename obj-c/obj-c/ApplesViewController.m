#import "ApplesViewController.h"

@interface ApplesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *applesDlTextView;

@end

@implementation ApplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.deepLinkData != nil) {
        self.applesDlTextView.attributedText = [self attributionDataToStringWithData:self.deepLinkData];
        self.applesDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmountWithData:self.deepLinkData];
    }
}

- (IBAction)copyShareInviteLink:(UIButton *)sender {
    [super copyShareInviteLinkWithFruitName:@"apples"];
}

@end
