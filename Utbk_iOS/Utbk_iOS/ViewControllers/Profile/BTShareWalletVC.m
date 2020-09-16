//
//  BTShareWalletVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTShareWalletVC.h"
#import "BTShareSecondVC.h"

@interface BTShareWalletVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation BTShareWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)setupBind{
    self.codeImageView.image = [BTCommonUtils createQRCodeWithUrl:@"测试" image:BTUIIMAGE(@"icon_registerLogo") size:self.codeImageView.bounds.size.width];
    //[BTCommonUtils logoQrCode:BTUIIMAGE(@"icon_registerLogo") code:@"cehsi"];
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(UIButton *)sender {
    BTShareSecondVC *share = [[BTShareSecondVC alloc]init];
    share.url = @"测试";
    share.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:share animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
