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
        self.subAmount.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.4f %@",model.subCoinYesterdayProduce,model.subCoin]];//子币昨日收益
    }
    self.destroyTotal.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:model.parentCoinAmount withlimit:KLimitAssetInputDigits],model.coinName];
    self.yesEarnings.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:model.yesterdayProduce withlimit:KLimitAssetInputDigits],model.coinName];
    self.totalOutput.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.0f",model.totalProduce]];//累计产出
    self.subOutput.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:model.subCoinAmount withlimit:KLimitAssetInputDigits],model.subCoin];
    if (model.type >=2 ) {//说明是矿主200组以上就是矿主
        self.starView.hidden = NO;
        [self.levelBtn setTitle:LocalizationKey(@"矿主") forState:UIControlStateNormal];
    }else{
        self.starView.hidden = YES;
    }
    self.contributionValue.text = [ToolUtil formartScientificNotationWithString:model.contributionValue];//贡献值
    self.sections.text = [ToolUtil stringFromNumber:model.smallTotal.doubleValue withlimit:4];//小区合计
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
