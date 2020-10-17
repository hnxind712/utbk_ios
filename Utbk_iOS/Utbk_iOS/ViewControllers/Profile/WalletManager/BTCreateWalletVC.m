//
//  BTCreateWalletVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCreateWalletVC.h"
#import "BTCreateSuccessVC.h"
#import "MineNetManager.h"
#import "BTAssetsModel.h"
#import "BTBackupMnemonicsVC.h"
#import <V5Client/V5ClientAgent.h>

@interface BTCreateWalletVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceh;
@end

@implementation BTCreateWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"创建钱包");
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.textViewPlaceh.hidden = textView.text.length == 0 ? NO : YES;
    if (textView.text.length && self.passwordSecond.text.length && self.password.text.length) {
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xcccccc);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    UITextField *_textfield = textField == self.password ? self.passwordSecond : self.password;
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (checkStr.length && _textfield.text.length && self.textView.text.length) {
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.createBtn.userInteractionEnabled = NO;
        self.createBtn.backgroundColor = RGBOF(0xcccccc);
    }
    return checkStr.length <= 25;
}

- (IBAction)showPasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 103:
            self.password.secureTextEntry = sender.selected;
            break;
        case 104:
            self.passwordSecond.secureTextEntry = sender.selected;
            break;
        default:
            break;
    }
}

//确认创建
- (IBAction)createAction:(UIButton *)sender {
    if (!_textView.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入用户名") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_password.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入密码") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (![_password.text isEqualToString:_passwordSecond.text]) {
        [self.view makeToast:LocalizationKey(@"两次输入的密码不一致") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _textView.text;
    params[@"password"] = _password.text;
    [[XBRequest sharedInstance]postDataWithUrl:CreateAddressAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            YLUserInfo *info = [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];//缓存个人数据
            [MineNetManager getMyWalletInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {//获取个人BTCK地址
                if (NetSuccess) {
                    NSArray *dataArr = [BTAssetsModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                    for (BTAssetsModel *walletModel in dataArr) {
                        if ([walletModel.coin.unit isEqualToString:KOriginalCoin]) {//个人中心显示BTCK的地址
                            info.address = walletModel.address;break;
                        }
                    }
                    [YLUserInfo saveUser:info];
                    NSMutableArray *array = [NSMutableArray array];
                    //取出
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
                    NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
                    [array addObjectsFromArray:list];
                    [array insertObject:info atIndex:0];
                    //存
                    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
                    [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    BTBackupMnemonicsVC *backup = [[BTBackupMnemonicsVC alloc]init];
                    [self.navigationController pushViewController:backup animated:YES];
                }
            }];
            
        }else{
            ErrorToast
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
