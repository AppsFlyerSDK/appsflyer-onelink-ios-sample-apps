#import "PeachesViewController.h"

@interface PeachesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *peachesDlTextView;

@end

@implementation PeachesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.deepLinkData != nil) {
        self.peachesDlTextView.attributedText = [self attributionDataToStringWithData:self.deepLinkData];
        self.peachesDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmountWithData:self.deepLinkData];
    }
}

- (IBAction)copyShareInviteLink:(UIButton *)sender {
    [super copyShareInviteLinkWithFruitName:@"peaches"];
}

@end
