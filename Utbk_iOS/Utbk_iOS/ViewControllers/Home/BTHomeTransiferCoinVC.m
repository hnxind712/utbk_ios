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
{
    BOOL isHaveDian;
}
@property (weak, nonatomic) IBOutlet UITextField *addressInput;
@property (weak, nonatomic) IBOutlet UITextField *coinCountInput;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordInput;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (weak, nonatomic) IBOutlet UILabel *feeTitle;//矿工费标题
@property (assign, nonatomic) CGFloat feeRate;//旷工费
@property (weak, nonatomic) IBOutlet UILabel *unitL;

@end

@implementation BTHomeTransiferCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"转账");
    [self addRightNavigation];
    [self setupBind];
    self.coinCountInput.keyboardType = UIKeyboardTypeDecimalPad;
    [self.coinCountInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.feeTitle.text = LocalizationKey(@"矿工费每笔：");
    self.unitL.text = LocalizationKey(@"个");
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
/*
 if ([textField.text rangeOfString:@"."].location == NSNotFound) {
     isHaveDian = NO;
 }
 if ([string length] > 0) {
  
     unichar single = [string characterAtIndex:0];//当前输入的字符
     if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
      
         //首字母不能为0和小数点
         if([textField.text length] == 0){
             if(single == '.') {
                 [self showError:@"亲，第一个数字不能为小数点"];
                 [textField.text stringByReplacingCharactersInRange:range withString:@""];
                 return NO;
             }
             if (single == '0') {
                 [self showError:@"亲，第一个数字不能为0"];
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
                 [self showError:@"亲，您已经输入过小数点了"];
                 [textField.text stringByReplacingCharactersInRange:range withString:@""];
                 return NO;
             }
         }else{
             if (isHaveDian) {//存在小数点
              
                 //判断小数点的位数
                 NSRange ran = [textField.text rangeOfString:@"."];
                 if (range.location - ran.location <= 2) {
                     return YES;
                 }else{
                     [self showError:@"亲，您最多输入两位小数"];
                     return NO;
                 }
             }else{
                 return YES;
             }
         }
     }else{//输入的数据格式不正确
         [self showError:@"亲，您输入的格式不正确"];
         [textField.text stringByReplacingCharactersInRange:range withString:@""];
         return NO;
     }
 }
 else
 {
     return YES;
 }
 */
-(void)textFieldDidChange:(UITextField *)textField{
    if (!textField.text.length) {
        self.fee.text = @"0.0000";
    }else{
        self.fee.text = [NSString stringWithFormat:@"%.4f",self.feeRate * textField.text.doubleValue];
    }
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMotherCoinWalletAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if ([responseResult[@"data"]isKindOfClass:[NSNull class]]) {
                strongSelf.balance.text = @"0.0000";
                strongSelf.fee.text = @"0.0000";
            }else{
                strongSelf.balance.text = [ToolUtil stringFromNumber:[responseResult[@"data"][@"balance"]doubleValue] withlimit:KLimitAssetInputDigits];
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
    _tradePasswordInput.secureTextEntry = !sender.selected;
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
    sender.userInteractionEnabled = NO;
    NSString *inputAddress = [self.addressInput.text stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address"] = inputAddress;
    params[@"amount"] = self.coinCountInput.text;
    params[@"jyPassword"] = self.tradePasswordInput.text;
    [[XBRequest sharedInstance]postDataWithUrl:mothertransferAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
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
