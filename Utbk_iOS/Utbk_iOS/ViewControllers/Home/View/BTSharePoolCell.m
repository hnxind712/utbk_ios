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
@property (weak, nonatomic) IBOutlet UILabel *destroyTotal;
@property (weak, nonatomic) IBOutlet UILabel *totalOutput;
@property (weak, nonatomic) IBOutlet UILabel *contributionValue;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn;
@property (weak, nonatomic) IBOutlet UILabel *sections;

@end
@implementation BTSharePoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTSharePoolModel *)model{
    self.yesEarnings.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%f",model.yesterdayProduce]];//昨日收益
    self.totalOutput.text = [ToolUtil formartScientificNotationWithString:model.totalProduce];//累计产出
    if (model.groupsQty * KContributionValue > KContributionValue * 200) {//说明是矿主200组以上就是矿主
        [self.levelBtn setTitle:LocalizationKey(@"矿主") forState:UIControlStateNormal];
    }else{
        [self.starArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            double value = obj.doubleValue;
            if (model.groupsQty * KContributionValue < value) {
                [self.levelBtn setTitle:[NSString stringWithFormat:@"%ld",idx + 1] forState:UIControlStateNormal];*stop = YES;
            }
        }];
    }
    self.contributionValue.text = [ToolUtil formartScientificNotationWithString:model.contributionValue];//贡献值
    self.sections.text = [NSString stringWithFormat:@"%d",model.groupsQty];//组数
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
