//
//  BTImportWalletVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTImportWalletVC.h"
#import "YLTabBarController.h"
#import "MineNetManager.h"
#import "BTAssetsModel.h"

@interface BTImportWalletVC ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mnemonicWordBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateKeyBtn;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;//线的左边间距
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;

@end

@implementation BTImportWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedBtn = self.mnemonicWordBtn;
    self.lineLeftConstraint.constant = (SCREEN_WIDTH - 22)/4 - 7.5;
    self.title = LocalizationKey(@"导入钱包");
    // Do any additional setup after loading the view from its nib.
}
#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.textViewPlaceh.hidden = textView.text.length == 0 ? NO : YES;
    if (textView.text.length && self.passwordSecond.text.length && self.password.text.length) {
        self.importBtn.userInteractionEnabled = YES;
        self.importBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.importBtn.userInteractionEnabled = YES;
        self.importBtn.backgroundColor = RGBOF(0xcccccc);
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
        self.importBtn.userInteractionEnabled = YES;
        self.importBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.importBtn.userInteractionEnabled = YES;
        self.importBtn.backgroundColor = RGBOF(0xcccccc);
    }
    return YES;
}
//切换方式
- (IBAction)changeImportMethodAction:(UIButton *)sender {
    if (sender == self.selectedBtn) return;
    sender.selected = YES;
    self.selectedBtn = sender;
    NSString *plac = @"";
    CGFloat left = 0;
    switch (sender.tag) {
        case 100:
            self.privateKeyBtn.selected = NO;
            plac = LocalizationKey(@"请输入助记词单词，并使用逗号分隔");
            left = (SCREEN_WIDTH - 22)/4 - 7.5;
            break;
            case 101:
            self.mnemonicWordBtn.selected = NO;
            plac = LocalizationKey(@"请输入秘钥，可长按粘贴导入钱包地址");
            left = (SCREEN_WIDTH - 22) * 3/4 - 7.5;
        default:
            break;
    }
    self.textViewPlaceh.text = plac;
    self.lineLeftConstraint.constant = left;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
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
//查看隐私服务
- (IBAction)checkServiceAction:(UIButton *)sender {
}
//确认导入
- (IBAction)importAction:(UIButton *)sender {
    if (self.selectedBtn == _mnemonicWordBtn && !self.textView.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入助记词单词") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (self.selectedBtn == _privateKeyBtn && !self.textView.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入私钥") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_password.text.length || !_passwordSecond.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入钱包密码") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (![_password.text isEqualToString:_passwordSecond.text]) {
        [self.view makeToast:LocalizationKey(@"请检测两次输入的密码是否一致") duration:ToastHideDelay position:ToastPosition];return;
    }
    WeakSelf(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.selectedBtn == self.mnemonicWordBtn) {
        params[@"remberWords"] = self.textView.text;
        params[@"primaryKey"] = @"";
    }else if (self.selectedBtn == self.privateKeyBtn){
        params[@"remberWords"] = @"";
        params[@"primaryKey"] = self.textView.text;
    }
    params[@"password"] = self.password.text;
    [[XBRequest sharedInstance]postDataWithUrl:importMnemonicAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            YLUserInfo *info = [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];
            [YLUserInfo saveUser:info];
            NSMutableArray *array = [NSMutableArray array];
            //取出
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
            NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
            [array addObjectsFromArray:list];
            [MineNetManager getMyWalletInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
                if (NetSuccess) {
                    NSArray *dataArr = [BTAssetsModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                    for (BTAssetsModel *walletModel in dataArr) {
                        if ([walletModel.coin.unit isEqualToString:KOriginalCoin]) {//个人中心显示BTCK的地址
                            info.address = walletModel.address;break;
                        }
                    }
                    [YLUserInfo saveUser:info];//拿到资产之后再保存一次，避免两个接口请求失败了没有将用户信息保存在本地
                    //获取激活状态
                    [[XBRequest sharedInstance]postDataWithUrl:getMemberStatusAPI Parameter:@{@"memberId":info.ID} ResponseObject:^(NSDictionary *responseResult) {
                        if (NetSuccess) {
                            info.activeStatus = [responseResult[@"data"][@"status"] isKindOfClass:[NSNull class]] ? 0 : [responseResult[@"data"][@"status"] integerValue];
                            [array insertObject:info atIndex:0];
                            //存
                            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
                            [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
                            }else{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }else{
                            //存
                            [array insertObject:info atIndex:0];
                            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
                            [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
                            }else{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    }];
                }else{
                    ErrorToast
                    //存
                    [array insertObject:info atIndex:0];
                    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
                    [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
                    }else{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
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
