//
//  BTDropRecordTableViewCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTDropRecordTableViewCell.h"
#import "BTPoolRecordModel.h"

@interface BTDropRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *earning;
@property (weak, nonatomic) IBOutlet UILabel *coin;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation BTDropRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTPoolRecordModel *)model{
    self.earning.text = [NSString stringWithFormat:@"+%@",[ToolUtil formartScientificNotationWithString:model.amount]];
    self.coin.text = model.coinName;
    self.time.text = model.saveTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
