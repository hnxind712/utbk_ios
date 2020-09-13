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
- (void)configureWithModel:(BTWalletManagerModel *)model{
    
}
- (IBAction)copyAddressAction:(UIButton *)sender {
    if (!_address.length) {
        //LocalizationKey(@"地址为空")
        [BTKeyWindow makeToast:LocalizationKey(@"地址为空") duration:ToastHideDelay position:ToastPosition];return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _address;
    [self makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];
//    [MBProgressHUD bwm_showTitle:NSLocalizedString(@"复制成功",nil) toView:[UIApplication sharedApplication].keyWindow hideAfter:2.f];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
    // Configure the view for the selected state
}

@end
