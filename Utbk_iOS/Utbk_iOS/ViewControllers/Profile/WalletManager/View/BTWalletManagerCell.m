//
//  BTWalletManagerCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWalletManagerCell.h"
#import "BTWalletManagerModel.h"

@interface BTWalletManagerCell ()
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (copy, nonatomic) NSString *address;

@end

@implementation BTWalletManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureWithModel:(YLUserInfo *)model{
    self.selectedBtn.selected = [[YLUserInfo shareUserInfo].username isEqualToString:model.username];
    self.currentLabel.textColor = [[YLUserInfo shareUserInfo].username isEqualToString:model.username] ? RGBOF(0x333333) : RGBOF(0xcccccc);
    self.nickName.text = model.username;
    self.addressLabel.text = model.address;
    self.activityView.backgroundColor = (model.activeStatus == 1 || model.activeStatus == 2)  ? RGBOF(0xDAC49D) : RGBOF(0xcccccc);
    self.activityLabel.textColor = (model.activeStatus == 1 || model.activeStatus == 2) ? RGBOF(0x786236) : RGBOF(0x333333);
    self.activityLabel.text = (model.activeStatus == 1 || model.activeStatus == 2) ?  (model.activeStatus == 2 ? LocalizationKey(@"已激活") : LocalizationKey(@"网体激活")) : LocalizationKey(@"未激活");
}
- (IBAction)copyAddressAction:(UIButton *)sender {
    if (!_address.length) {
        [BTKeyWindow makeToast:LocalizationKey(@"地址为空") duration:ToastHideDelay position:ToastPosition];return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _address;
    [self makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];
}
- (IBAction)walletDetail:(UIButton *)sender {
    if (self.walletDetailAction) {
        self.walletDetailAction();
    }
}
- (IBAction)SwitchAccountAction:(UIButton *)sender {
    if (self.switchAccountAction) {
        self.switchAccountAction();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
    // Configure the view for the selected state
}

@end
