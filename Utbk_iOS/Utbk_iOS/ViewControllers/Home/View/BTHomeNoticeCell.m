//
//  BTHomeNoticeCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeNoticeCell.h"
#import "BTNoticeModel.h"

@implementation BTHomeNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//已读颜色e8e8e8  未读颜色#A78659
- (void)configureCellWithNoticeModel:(BTNoticeModel *)model{
    self.redView.backgroundColor = model.read ? RGBOF(0xe8e8e8) : RGBOF(0xa78659);
}
@end
