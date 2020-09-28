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
    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:model.coin.usdRate];
    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:model.balance];
    ass1 = [balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle];
    self.convertAccount.text = [ass1 stringValue];
    if ([model.coin.name isEqualToString:@"USDT"]) {
        [self.receiveBtn setTitle:LocalizationKey(@"充币") forState:UIControlStateNormal];
        [self.transiferBtn setTitle:LocalizationKey(@"提币") forState:UIControlStateNormal];
        [self.sTransferBtn setTitle:LocalizationKey(@"转币") forState:UIControlStateNormal];
    }else{
        [self.receiveBtn setTitle:LocalizationKey(@"收币") forState:UIControlStateNormal];
        [self.transiferBtn setTitle:LocalizationKey(@"转账") forState:UIControlStateNormal];
        [self.sTransferBtn setTitle:LocalizationKey(@"划转") forState:UIControlStateNormal];
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
