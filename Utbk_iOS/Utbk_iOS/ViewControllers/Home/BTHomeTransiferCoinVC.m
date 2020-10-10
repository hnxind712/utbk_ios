//
//  BTHomeTransiferCoinVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeTransiferCoinVC.h"
#import "STQRCodeController.h"
#import "BTWithdrawRecordVC.h"

@interface BTHomeTransiferCoinVC ()<STQRCodeControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressInput;
@property (weak, nonatomic) IBOutlet UITextField *coinCountInput;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordInput;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (assign, nonatomic) CGFloat feeRate;//旷工费

@end

@implementation BTHomeTransiferCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"转币");
    [self addRightNavigation];
    [self setupBind];
    self.coinCountInput.keyboardType = UIKeyboardTypeDecimalPad;
    [self.coinCountInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
- (void)transferRecordAction{
    BTWithdrawRecordVC *withdraw = [[BTWithdrawRecordVC alloc]init];
    withdraw.recordType = KRecordTypeMotherCoinTransfer;
    [self.navigationController pushViewController:withdraw animated:YES];
}

-(void)textFieldDidChange :(UITextField *)textField{
    if (!textField.text.length) {
        self.fee.text = @"0";
    }else{
        self.fee.text = [NSString stringWithFormat:@"%.2f",self.feeRate * textField.text.doubleValue];
    }
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMotherCoinWalletAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if ([responseResult[@"data"]isKindOfClass:[NSNull class]]) {
                strongSelf.balance.text = @"0.00";
                strongSelf.fee.text = @"0";
            }else{
                strongSelf.balance.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",responseResult[@"data"][@"balance"]]];
                strongSelf.feeRate = [responseResult[@"data"][@"rate"]doubleValue];
            }
        }
    }];
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
    STQRCodeController *qrcode = [[STQRCodeController alloc]init];
    qrcode.delegate = self;
    [self.navigationController pushViewController:qrcode animated:YES];
}
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType{
    if (resultType == STQRCodeResultTypeSuccess) {
         self.addressInput.text = readerScanResult;
     }else if (resultType == STQRCodeResultTypeError){
         [self.view makeToast:LocalizationKey(@"没有扫描到任何结果") duration:ToastHideDelay position:ToastPosition];
     }
}
//全部输入
- (IBAction)inputAllCoinAccountAction:(UIButton *)sender {
    if (self.balance.text.doubleValue) {
        self.coinCountInput.text = self.balance.text;
    }
}
//显示密码
- (IBAction)showTradePasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _tradePasswordInput.secureTextEntry = sender.selected;
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (!_addressInput.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入收币账户地址") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_coinCountInput.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入转币数量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_tradePasswordInput.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入交易密码") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address"] = self.addressInput.text;
    params[@"amount"] = self.coinCountInput.text;
    params[@"jyPassword"] = self.tradePasswordInput.text;
    [[XBRequest sharedInstance]postDataWithUrl:mothertransferAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        [self.view makeToast:responseResult[MESSAGE] duration:ToastHideDelay position:ToastPosition];
        if (NetSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
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
