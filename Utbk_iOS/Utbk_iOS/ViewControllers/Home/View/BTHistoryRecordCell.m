//
//  BTHistoryRecordCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHistoryRecordCell.h"
#import "BTHistoryRecordModel.h"
@interface BTHistoryRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
@implementation BTHistoryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithModel:(BTHistoryRecordModel *)model{
    self.rankLabel.text = [NSString stringWithFormat:@"%.2f",model.balance];
    self.address.text = model.address;
}
@end
