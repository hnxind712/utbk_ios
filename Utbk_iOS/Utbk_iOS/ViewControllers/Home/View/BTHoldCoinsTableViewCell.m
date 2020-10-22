//
//  BTHoldCoinsTableViewCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHoldCoinsTableViewCell.h"
#import "BTPoolHoldCoinModel.h"

@interface BTHoldCoinsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *yesearnings;
@property (weak, nonatomic) IBOutlet UILabel *yesearningsCoin;
@property (weak, nonatomic) IBOutlet UILabel *yesearningSub;//子币昨日收益
@property (weak, nonatomic) IBOutlet UILabel *totalearningM;
@property (weak, nonatomic) IBOutlet UILabel *totalearnings;//我的持币
@property (weak, nonatomic) IBOutlet UILabel *hold;//持币
@property (weak, nonatomic) IBOutlet UILabel *extend;//推广
@property (weak, nonatomic) IBOutlet UILabel *totalearningSub;
@property (weak, nonatomic) IBOutlet UILabel *myHoud;

@end

@implementation BTHoldCoinsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)confiureCellWithModel:(BTPoolHoldCoinModel *)model{
    self.myHoud.text = LocalizationKey(@"累计收益");
    self.coinName.text = model.coinName;
    self.totalearnings.text = [NSString stringWithFormat:@"%@",[ToolUtil formartScientificNotationWithString:model.balance]];//我的持币
    self.yesearnings.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:model.yesterdayProfit],model.coinName];//母币昨日收益
    self.yesearningSub.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:model.subcoinYesterdayProfit],model.subcoinCoin];//子币昨日收益
    self.totalearningM.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:model.profitAmount],model.coinName];
    self.totalearningSub.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:model.subcoinProfitAmount],model.subcoinCoin];
    self.hold.text = self.extend.text = [ToolUtil stringFromNumber:model.big_airdrop_profit.doubleValue withlimit:KLimitAssetInputDigits];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
