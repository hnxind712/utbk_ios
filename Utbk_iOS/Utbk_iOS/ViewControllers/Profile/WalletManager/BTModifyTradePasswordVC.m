//
//  BTModifyTradePasswordVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTModifyTradePasswordVC.h"
#import "MineNetManager.h"

@interface BTModifyTradePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;
@property (weak, nonatomic) IBOutlet UILabel *tips;

@end

@implementation BTModifyTradePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"修改交易密码");
    self.tips.text = LocalizationKey(@"温馨提示：请牢记您的提币密码，如果遗忘将无法找回，将无法提现账户资产，请慎重！！");
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    if (self.passwordSecond.text.length && self.passwordNew.text.length && self.passwordOld.text.length) {
        self.completedBtn.userInteractionEnabled = YES;
        self.completedBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.completedBtn.userInteractionEnabled = YES;
        self.completedBtn.backgroundColor = RGBOF(0xcccccc);
    }
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (checkStr.length && _textfield.text.length && self.textView.text.length) {
//        self.createBtn.userInteractionEnabled = YES;
//        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
//    }else{
//        self.createBtn.userInteractionEnabled = YES;
//        self.createBtn.backgroundColor = RGBOF(0xcccccc);
//    }
    return YES;
}
- (IBAction)setInputSecrity:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 103:
            self.passwordNew.secureTextEntry = sender.selected;
            break;
        case 104:
            self.passwordSecond.secureTextEntry = sender.selected;
            break;
        default:
            break;
    }
}
- (IBAction)completedAction:(UIButton *)sender {
    if ([self.passwordOld.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"请输入旧密码") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    if ([self.passwordNew.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"请输入新密码") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    if ([self.passwordSecond.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"请再次输入新密码") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    if (![self.passwordSecond.text isEqualToString:self.passwordNew.text]) {
        [self.view makeToast:LocalizationKey(@"两次输入的密码不一致") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    WeakSelf(weakSelf)
    [MineNetManager resetMoneyPasswordForOldPassword:self.passwordOld.text withLatestPassword:self.passwordNew.text code:@"" googleCode:nil CompleteHandle:^(id resPonseObj, int code) {
        StrongSelf(strongSelf)
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
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
