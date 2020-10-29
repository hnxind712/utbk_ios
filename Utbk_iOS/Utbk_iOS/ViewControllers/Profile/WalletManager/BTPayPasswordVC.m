//
//  BTPayPasswordVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTPayPasswordVC.h"
#import "MineNetManager.h"

@interface BTPayPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@end

@implementation BTPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"支付密码");
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)setInputSecrity:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 103:
            self.passwordNew.secureTextEntry = !sender.selected;
            break;
        case 104:
            self.passwordSecond.secureTextEntry = !sender.selected;
            break;
        default:
            break;
    }
}
- (IBAction)completedAction:(UIButton *)sender {
    if ([self.passwordNew.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"请输入交易密码") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    if (![ToolUtil matchPassword:_passwordNew.text]) {
        [self.view makeToast:LocalizationKey(@"请输入6-20位大小写加数字的密码组合") duration:ToastHideDelay position:ToastPosition];return;
    }
    if ([self.passwordSecond.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"请再次输入交易密码") duration:ToastHideDelay position:ToastPosition];
        return;
    }

    if (![self.passwordSecond.text isEqualToString:self.passwordNew.text]) {
        [self.view makeToast:LocalizationKey(@"两次输入的密码不一致") duration:ToastHideDelay position:ToastPosition];
        return;
    }
    sender.userInteractionEnabled = NO;
    [MineNetManager moneyPasswordForJyPassword:self.passwordSecond.text CompleteHandle:^(id resPonseObj, int code) {
        sender.userInteractionEnabled = YES;
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    YLUserInfo *info = [YLUserInfo shareUserInfo];
                    info.isSetPw = YES;
                    [YLUserInfo saveUser:info];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
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
