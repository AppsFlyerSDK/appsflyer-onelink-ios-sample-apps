#import "BananasViewController.h"

@interface BananasViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *bananasDlTextView;

@end

@implementation BananasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.deepLinkData != nil) {
        self.bananasDlTextView.attributedText = [self attributionDataToStringWithData:self.deepLinkData];
        self.bananasDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmountWithData:self.deepLinkData];
    }
}

- (IBAction)copyShareInviteLink:(UIButton *)sender {
    [super copyShareInviteLinkWithFruitName:@"bananas"];
}

@end
