//
//  BTWithdrawRecordCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWithdrawRecordCell.h"
#import "BTWithdrawRecordModel.h"

@interface BTWithdrawRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation BTWithdrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithRecordModel:(BTWithdrawRecordModel *)model{
    self.title.text = model.coin.name;
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:model.totalAmount];
    self.time.text = [ToolUtil transformForTimeString:model.createTime];
    if (model.status == 0) {
         self.status.text = LocalizationKey(@"auditing");
     }else if (model.status == 1){
         self.status.text = LocalizationKey(@"Assetstoreleased");

     }else if (model.status == 2){
         self.status.text = LocalizationKey(@"failure");
     }else if(model.status == 3){
         self.status.text = LocalizationKey(@"Success");
     }
}
- (IBAction)detailAction:(UIButton *)sender {
    if (self.recordDetailAction) {
        self.recordDetailAction();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
