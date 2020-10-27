//
//  BTTeamHoldTableViewCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTTeamHoldTableViewCell.h"
#import "BTTeamHoldModel.h"

@interface BTTeamHoldTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalAddessCount;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *personalHold;
@property (weak, nonatomic) IBOutlet UILabel *regionHold;//大区总持
@property (weak, nonatomic) IBOutlet UILabel *communityHold;//小区总持
@end

@implementation BTTeamHoldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTTeamHoldModel *)model{
    self.address.text = model.address;
    self.totalAddessCount.text = [NSString stringWithFormat:@"%d",model.allAddress];
    self.personalHold.text = [NSString stringWithFormat:@"%.2f",model.allChicang];
    self.regionHold.text = [NSString stringWithFormat:@"%.2f",model.daChicang];
    self.communityHold.text = [NSString stringWithFormat:@"%.2f",model.xiaoquChicang];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
