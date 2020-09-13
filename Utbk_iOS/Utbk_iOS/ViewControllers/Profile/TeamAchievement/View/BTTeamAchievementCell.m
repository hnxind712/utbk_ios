//
//  BTTeamAchievementCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTTeamAchievementCell.h"
#import "BTTeamAchievementModel.h"

@interface BTTeamAchievementCell ()
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *activityStatus;

@end
@implementation BTTeamAchievementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//已激活#A8865A 未激活#9A9A9A
- (void)configureCellWithAchievementModel:(BTTeamAchievementModel *)model{
    _activityStatus.textColor = model.activity ? RGBOF(0xA8865A) : RGBOF(0x9A9A9A);
    _activityStatus.text = model.activity ? LocalizationKey(@"已激活") : LocalizationKey(@"未激活");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
