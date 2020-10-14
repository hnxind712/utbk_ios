//
//  BTSweepAccountVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSweepAccountVC.h"
#import "BTWithdrawRecordVC.h"

@interface BTSweepAccountVC ()
@property (weak, nonatomic) IBOutlet UITextField *countInput;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *tips;

@end

@implementation BTSweepAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"划转");
    [self addRightNavigation];
    [self setupBind];
    self.tips.text = LocalizationKey(@"温馨提示：只能划转一次，最多划转300到BTCK,超出部分自动销毁");
    self.countInput.keyboardType = UIKeyboardTypeDecimalPad;
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
                strongSelf.balance.text = @"0";
            }else
                strongSelf.balance.text = [ToolUtil stringFromNumber:[responseResult[@"data"][@"balance"]doubleValue] withlimit:4];
        }
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = KLimitAssetInputDigits;//小数点后需要限制的个数
    for (int i = (int)(futureString.length - 1); i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}
- (void)transferRecordAction{
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    withdrawRecord.recordType = KRecordTypeMotherCoinSweep;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (!self.countInput.text.length) {
        [self.view makeToast:LocalizationKey(@"inputTransferNumber") duration:ToastHideDelay position:ToastPosition];return;
    }
    [[XBRequest sharedInstance]postDataWithUrl:motherCoinWalletTransferAPI Parameter:@{@"amount":self.countInput.text} ResponseObject:^(NSDictionary *responseResult) {
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
