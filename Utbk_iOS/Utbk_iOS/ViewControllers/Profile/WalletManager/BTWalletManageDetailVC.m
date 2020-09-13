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

@interface BTWalletManageDetailVC ()

@property (strong, nonatomic) BTWalletPopView *walletPopView;

@end

@implementation BTWalletManageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark actions
//修改钱包名称
- (IBAction)modifyWalletName:(UITapGestureRecognizer *)sender {
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
    BTModifyTradePasswordVC *modify = [[BTModifyTradePasswordVC alloc]init];
    [self.navigationController pushViewController:modify animated:YES];
}
- (IBAction)deleteWallet:(UIButton *)sender {
}
#pragma mark getter
- (BTWalletPopView *)walletPopView{
    if (!_walletPopView) {
        _walletPopView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BTWalletPopView class]) owner:nil options:nil].firstObject;
        _walletPopView.comfirmAction = ^(KWalletType wallteType, NSString * _Nonnull string) {
            
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
