//
//  BTWalletManageDetailVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWalletManageDetailVC.h"
#import "BTWalletPopView.h"
#import "BTModifyTradePasswordVC.h"
#import "BTBackupMnemonicsVC.h"

@interface BTWalletManageDetailVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mnemonicHeight;//助记词高度
@property (weak, nonatomic) IBOutlet UIView *mnemonicView;
@property (strong, nonatomic) BTWalletPopView *walletPopView;

@end

@implementation BTWalletManageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.userInfo.username;
    if (!self.userInfo.mnemonicWords.length) {
        self.mnemonicHeight.constant = 0;
        self.mnemonicView.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)verifyTradepssword:(NSString *)password type:(KWalletType)type{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:verifyTradepsswordAPI Parameter:@{@"jyPassword":password} ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if (type == KWalletTypeExportPrivateKey) {//导出私钥
                [strongSelf.walletPopView show:KWalletTypeCopyPrivateKey];
            }else if(type == KWalletTypeBackUpMnemonicWord){
                BTBackupMnemonicsVC *mnemonics = [[BTBackupMnemonicsVC alloc]init];
                mnemonics.userInfo = [YLUserInfo shareUserInfo];
                [strongSelf.navigationController pushViewController:mnemonics animated:YES];
            }
        }else
            ErrorToast
    }];
}
#pragma mark actions
//修改钱包名称
- (IBAction)modifyWalletName:(UITapGestureRecognizer *)sender {
    if (![self.userInfo.username isEqualToString:[YLUserInfo shareUserInfo].username]) {
        [self.view makeToast:LocalizationKey(@"请切换到当前用户再进行修改") duration:ToastHideDelay position:ToastPosition];return;
    }
    [self.walletPopView show:KWalletTypeModifyWalletName];
}
//备份助记词
- (IBAction)backUpMnemonicWord:(UITapGestureRecognizer *)sender {
    [self.walletPopView show:KWalletTypeBackUpMnemonicWord];
}
//导出秘钥
- (IBAction)exportPrivateKey:(UITapGestureRecognizer *)sender {
    [self.walletPopView show:KWalletTypeExportPrivateKey];
}
//修改密码
- (IBAction)modifyWalletPassword:(UITapGestureRecognizer *)sender {
    if (![self.userInfo.username isEqualToString:[YLUserInfo shareUserInfo].username]) {
        [self.view makeToast:LocalizationKey(@"请切换到当前用户再进行修改") duration:ToastHideDelay position:ToastPosition];return;
    }
    BTModifyTradePasswordVC *modify = [[BTModifyTradePasswordVC alloc]init];
    [self.navigationController pushViewController:modify animated:YES];
}
- (IBAction)deleteWallet:(UIButton *)sender {
    if ([self.userInfo.username isEqualToString:[YLUserInfo shareUserInfo].username]) {
        [self.view makeToast:LocalizationKey(@"不能删除当前钱包") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    NSMutableArray *datasource = [NSMutableArray arrayWithArray:arr];
    for (YLUserInfo *info in arr) {
        if ([info.username isEqualToString:self.userInfo.username]) {
            [datasource removeObject:info];break;
        }
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:datasource];
    [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view makeToast:LocalizationKey(@"删除成功") duration:ToastHideDelay position:ToastPosition];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark getter
- (BTWalletPopView *)walletPopView{
    if (!_walletPopView) {
        _walletPopView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BTWalletPopView class]) owner:nil options:nil].firstObject;
        WeakSelf(weakSelf)
        _walletPopView.comfirmAction = ^(KWalletType wallteType, NSString * _Nonnull string) {
            StrongSelf(strongSelf)
            [strongSelf verifyTradepssword:string type:wallteType];
        };
    }
    return _walletPopView;
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
