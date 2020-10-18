//
//  BTSharePoolTableViewCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSharePoolTableViewCell.h"
#import "BTPoolShareContributionRecordModel.h"

@interface BTSharePoolTableViewCell ()
//考虑到收益记录以及贡献记录公用cell，因此命名直接从左到右来处理

@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UILabel *two;
@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet UILabel *four;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeLeading;//由于收益记录不需要星级显示，因此需要调整当前leading，使其居中

@end

@implementation BTSharePoolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTPoolShareContributionRecordModel *)model{
    if (self.type == 1) {
        self.one.text = [NSString stringWithFormat:@"%.0fV/%.2fU", model.contributionValue,model.amount];
        self.two.text = [NSString stringWithFormat:@"%@",model.coin];//暂定
        self.three.text = [NSString stringWithFormat:@"%ld",(long)model.groupQty];
        self.four.text = [ToolUtil transformForDayTimeString:model.saveTime];
        self.threeLeading.constant = 0.f;
        self.two.hidden = NO;
    }else{
        self.one.text = [NSString stringWithFormat:@"%@", model.coin];
        self.three.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",model.produce]];
        self.four.text = [ToolUtil transformForDayTimeString:model.saveTime];
        //算出第二个的right
        CGFloat width = (SCREEN_WIDTH - 48)/4;
        CGFloat twoMaxX = width * 2 + 48;
        self.threeLeading.constant = -(twoMaxX - SCREEN_WIDTH/2 + 12) - width;//此处要改
        self.two.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
