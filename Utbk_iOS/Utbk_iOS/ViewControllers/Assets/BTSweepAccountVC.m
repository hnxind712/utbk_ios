//
//  BTSweepAccountVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSweepAccountVC.h"
#import "BTWithdrawRecordVC.h"

@interface BTSweepAccountVC (){
    BOOL isHaveDian;
}
@property (weak, nonatomic) IBOutlet UITextField *countInput;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

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
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
     
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
         
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
             
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                     
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                 
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= KLimitAssetInputDigits) {
                        return YES;
                    }else{
                        [self.view makeToast:LocalizationKey(@"最多输入4位小数") duration:ToastHideDelay position:ToastPosition];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    return YES;
}
- (void)transferRecordAction{
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    withdrawRecord.recordType = KRecordTypeMotherCoinSweep;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (self.canTransfer) {
        [self.view makeToast:LocalizationKey(@"不支持划转") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!self.countInput.text.length) {
        [self.view makeToast:LocalizationKey(@"inputTransferNumber") duration:ToastHideDelay position:ToastPosition];return;
    }
    sender.userInteractionEnabled = NO;
    [[XBRequest sharedInstance]postDataWithUrl:motherCoinWalletTransferAPI Parameter:@{@"amount":self.countInput.text} ResponseObject:^(NSDictionary *responseResult) {
        sender.userInteractionEnabled = YES;
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
