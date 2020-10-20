//
//  BTSharePoolCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/26.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSharePoolCell.h"
#import "BTSharePoolModel.h"

@interface BTSharePoolCell ()
@property (weak, nonatomic) IBOutlet UILabel *yesEarnings;
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *subAmount;
@property (weak, nonatomic) IBOutlet UILabel *subCoin;
@property (weak, nonatomic) IBOutlet UILabel *motherCoin;//累计收益母币币种
@property (weak, nonatomic) IBOutlet UILabel *yesMotherCoin;

@property (weak, nonatomic) IBOutlet UILabel *destroyTotal;
@property (weak, nonatomic) IBOutlet UILabel *totalOutput;
@property (weak, nonatomic) IBOutlet UILabel *contributionValue;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn;
@property (weak, nonatomic) IBOutlet UILabel *sections;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *subOutput;//子币累计收益
@property (weak, nonatomic) IBOutlet UILabel *subOutputCoin;

@end
@implementation BTSharePoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTSharePoolModel *)model{
    self.coinName.text = model.coinName;
    if (model.subCoin.length) {
        self.subAmount.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f %@",model.subCoinYesterdayProduce,model.subCoin]];//子币昨日收益
    }
    self.destroyTotal.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f %@",model.parentCoinAmount,model.coinName]];//母币累计产出
    self.yesEarnings.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f %@",model.yesterdayProduce,model.coinName]];//母币昨日收益
    self.totalOutput.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.0f",model.totalProduce]];//累计产出
    self.subOutput.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f %@",model.subCoinAmount,model.subCoin]];//子币累计产出
    if (model.type >=2 ) {//说明是矿主200组以上就是矿主
        self.starView.hidden = NO;
        [self.levelBtn setTitle:LocalizationKey(@"矿主") forState:UIControlStateNormal];
    }else{
        self.starView.hidden = YES;
    }
//    else{
//        [self.starArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            double value = obj.doubleValue;
//            if (model.groupsQty * KContributionValue < value) {
//                [self.levelBtn setTitle:[NSString stringWithFormat:@"%ld",idx + 1] forState:UIControlStateNormal];*stop = YES;
//            }
//        }];
//    }
    self.contributionValue.text = [ToolUtil formartScientificNotationWithString:model.contributionValue];//贡献值
    self.sections.text = [NSString stringWithFormat:@"%d",model.groupsQty];//组数
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
