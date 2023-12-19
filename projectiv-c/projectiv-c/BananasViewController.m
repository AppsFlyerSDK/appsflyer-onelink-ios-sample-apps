#import "BananasViewController.h"

@interface BananasViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *bananasDlTextView;

@end

@implementation BananasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.deepLinkData != nil) {
        self.bananasDlTextView.attributedText = [self attributionDataToString:self.deepLinkData];
        self.bananasDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmount:self.deepLinkData];
    }
}

//- (IBAction)copyShareInviteLink:(UIButton *)sender {
//    [super copyShareInviteLinkWithFruitName:@"apples"];
//}

@end
