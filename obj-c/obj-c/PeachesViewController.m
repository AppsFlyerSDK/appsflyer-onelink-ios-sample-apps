#import "PeachesViewController.h"

@interface PeachesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *peachesDlTextView;

@end

@implementation PeachesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    if (self.deepLinkData != nil) {
        self.peachesDlTextView.attributedText = [self attributionDataToString:self.deepLinkData];
        self.peachesDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmount:self.deepLinkData];
    }
}

- (IBAction)copyShareInviteLink:(UIButton *)sender {
    [super copyShareInviteLinkWithFruitName:@"peaches"];
}

@end
