//
//  BTWalletPopView.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWalletPopView.h"
@interface BTWalletPopView ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (assign, nonatomic) KWalletType walletType;
@property (weak, nonatomic) IBOutlet UILabel *secretWord;//私钥
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;//确认

@end

@implementation BTWalletPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show:(KWalletType)walletType{
    _walletType = walletType;
    [BTKeyWindow addSubview:self];
    self.frame = BTKeyWindow.bounds;
    [_confirmBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
    _secretWord.hidden = YES;
    _input.hidden = NO;
    switch (walletType) {
        case KWalletTypeModifyWalletName:
            _title.text = LocalizationKey(@"钱包名称");
            _input.placeholder = LocalizationKey(@"请输入钱包名称");
            break;
        case KWalletTypeBackUpMnemonicWord:
            _title.text = LocalizationKey(@"备份助记词");
            _input.placeholder = LocalizationKey(@"请输入钱包密码");
            break;
        case KWalletTypeExportPrivateKey:
            _title.text = LocalizationKey(@"导出私钥");
            _input.placeholder = LocalizationKey(@"请输入钱包密码");
            break;
        case KWalletTypeCopyPrivateKey:
            _title.text = LocalizationKey(@"复制私钥");
            _input.hidden = YES;
            _secretWord.hidden = NO;
            _secretWord.text = [YLUserInfo shareUserInfo].secretKey;
            [_confirmBtn setTitle:LocalizationKey(@"复制") forState:UIControlStateNormal];
        default:
            break;
    }
}
- (IBAction)cancleAction:(UIButton *)sender {
    [self removeFromSuperview];
}
- (IBAction)comfirmAction:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.walletType == KWalletTypeCopyPrivateKey) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [YLUserInfo shareUserInfo].secretKey;
        [BTKeyWindow makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_input.text.length) {
        [BTKeyWindow makeToast:LocalizationKey(@"请输入钱包密码") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (self.comfirmAction) {
        self.comfirmAction(_walletType, _input.text);
    }
}

@end
