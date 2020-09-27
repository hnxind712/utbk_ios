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
@property (weak, nonatomic) IBOutlet UILabel *yesearningBTK;
@property (weak, nonatomic) IBOutlet UILabel *yesearningCoinBTK;
@property (weak, nonatomic) IBOutlet UILabel *totalearnings;
@property (weak, nonatomic) IBOutlet UILabel *hold;//持币
@property (weak, nonatomic) IBOutlet UILabel *extend;//推广

@end

@implementation BTHoldCoinsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)confiureCellWithModel:(BTPoolHoldCoinModel *)model{
    self.coinName.text = model.coinName;
    self.totalearnings.text = [ToolUtil formartScientificNotationWithString:model.profitAmount];
    self.yesearningsCoin.text = model.coinName;
    self.yesearnings.text = [ToolUtil formartScientificNotationWithString:model.yesterdayProfit];
    self.yesearningBTK.text = [ToolUtil formartScientificNotationWithString:model.subcoinYesterdayProfit];
    self.yesearningCoinBTK.text = model.subcoinCoin;
    self.hold.text = self.extend.text = [ToolUtil formartScientificNotationWithString:model.big_airdrop_profit];;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end