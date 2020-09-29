//
//  BTAssetsCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsCell.h"
#import "BTAssetsModel.h"
#import "ToolUtil.h"

@interface BTAssetsCell ()
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCoinAccount;//总额
@property (weak, nonatomic) IBOutlet UILabel *convertAccount;//折合
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;//收币
@property (weak, nonatomic) IBOutlet UIButton *transiferBtn;//转账
@property (weak, nonatomic) IBOutlet UIButton *sTransferBtn;//划转

@end
@implementation BTAssetsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithAssetsModel:(BTAssetsModel *)model{
    self.coinName.text = model.coin.name;
    self.totalCoinAccount.text = [ToolUtil judgeStringForDecimalPlaces:model.balance];
//    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
//    NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
//    NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:model.coin.usdRate];
//    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:model.balance];
//    ass1 = [balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle];
    self.convertAccount.text = [ToolUtil judgeStringForDecimalPlaces:model.frozenBalance];
    if ([model.coin.name isEqualToString:@"USDT"]) {
        [self.receiveBtn setTitle:LocalizationKey(@"充币") forState:UIControlStateNormal];
        [self.transiferBtn setTitle:LocalizationKey(@"提币") forState:UIControlStateNormal];
        [self.sTransferBtn setTitle:LocalizationKey(@"转币") forState:UIControlStateNormal];
    }else{
        [self.receiveBtn setTitle:LocalizationKey(@"收币") forState:UIControlStateNormal];
        [self.transiferBtn setTitle:LocalizationKey(@"转账") forState:UIControlStateNormal];
        [self.sTransferBtn setTitle:LocalizationKey(@"划转") forState:UIControlStateNormal];
    }
    if (_cellType == 0) {
        if (self.status == 1 || self.status == 2) {
            self.activityLabel.text = LocalizationKey(@"已激活");
            self.activityView.backgroundColor = [RGBOF(0x28B054)colorWithAlphaComponent:0.1];
            self.activityLabel.textColor = RGBOF(0x28B054);
        }else{
            self.activityLabel.text = LocalizationKey(@"未激活");
            self.activityView.backgroundColor = RGBOF(0xe8e8e8);
            self.activityLabel.textColor = RGBOF(0x666666);
        }
        self.transiferBtn.hidden = NO;
        self.sTransferBtn.hidden = NO;
        self.receiveBtn.backgroundColor = RGBOF(0xe8e8e8);
        [self.receiveBtn setTitleColor:RGBOF(0x343434) forState:UIControlStateNormal];
    }else{
        self.transiferBtn.hidden = YES;
        self.sTransferBtn.hidden = YES;
        self.receiveBtn.backgroundColor = RGBOF(0xA7865A);
        [self.receiveBtn setTitleColor:RGBOF(0xffffff) forState:UIControlStateNormal];
    }

}
- (IBAction)assetsDetail:(UIButton *)sender {
    if (self.assetsDetailAction) {
        self.assetsDetailAction();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cellBtnActions:(UIButton *)sender {
    if (self.cellBtnClickAction) {
        self.cellBtnClickAction(sender.tag - 100);
    }
}

@end
