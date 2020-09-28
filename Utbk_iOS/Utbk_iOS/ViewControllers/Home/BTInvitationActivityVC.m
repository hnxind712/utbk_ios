//
//  BTInvitationActivityVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTInvitationActivityVC.h"
#import "STQRCodeController.h"

@interface BTInvitationActivityVC ()<STQRCodeControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *coinAddress;
@property (weak, nonatomic) IBOutlet UILabel *feeTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end

@implementation BTInvitationActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"邀请激活");
    [self addRightNavigation];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecordR") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMotherCoinWalletAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if ([responseResult[@"data"]isKindOfClass:[NSNull class]]) {
                [strongSelf.view makeToast:LocalizationKey(@"当前没有母币，无法激活") duration:ToastHideDelay position:ToastPosition];return;
            }
            strongSelf.balance.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",responseResult[@"data"][@"balance"]]];
        }
    }];
}
- (void)transferRecordAction{
    
}
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType{
    
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
    STQRCodeController *qrcode = [[STQRCodeController alloc]init];
    qrcode.delegate = self;
    [self.navigationController pushViewController:qrcode animated:YES];
}
//确认
- (IBAction)comfirmAction:(UIButton *)sender {
    if (!_coinAddress.text.length) {
        [self.view makeToast:LocalizationKey(@"请填写对方账户地址") duration:ToastHideDelay position:ToastPosition];return;
    }
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:activeOneAPI Parameter:@{@"toAddr":self.coinAddress.text} ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            [strongSelf.view makeToast:responseResult[@"message"] duration:ToastHideDelay position:ToastPosition];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else
            ErrorToast
    }];
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
