#import "ApplesViewController.h"

@interface ApplesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fruitAmount;
@property (weak, nonatomic) IBOutlet UITextView *applesDlTextView;

@end

@implementation ApplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.deepLinkData != nil) {
        self.applesDlTextView.attributedText = [self attributionDataToString:self.deepLinkData];
        self.applesDlTextView.textColor = UIColor.labelColor;
        self.fruitAmount.text = [self getFruitAmount:self.deepLinkData];
    }
}

//- (IBAction)copyShareInviteLink:(UIButton *)sender {
//    [super copyShareInviteLinkWithFruitName:@"apples"];
//}

@end
