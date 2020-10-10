//
//  BTWithdrawRecordCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWithdrawRecordCell.h"
#import "BTWithdrawRecordModel.h"
#import "BTMotherCoinModel.h"
#import "BTPoolShareContributionRecordModel.h"

@interface BTWithdrawRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation BTWithdrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//提币记录
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
//流水记录
- (void)configureCellWithStreamRecordModel:(BTWithdrawRecordModel *)model{
    
}

- (void)configureCellWithMotherTransferRecordModel:(BTMotherCoinModel *)model{
//    self.title.text = model.coinId;
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:model.amount];
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
    self.moreBtn.hidden = (self.index != 6) ? NO : YES;
    self.title.text = [self typeString];
}
- (void)configureCellWithContributionRecordModel:(BTPoolShareContributionRecordModel *)model{
    self.title.text = model.remarks;
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:[NSString stringWithFormat:@"%.2f",model.amount]];
    self.time.text = [ToolUtil transformForTimeString:model.saveTime];
    self.status.text = LocalizationKey(@"已完成");
}
- (NSString *)typeString{
    NSDictionary *dic = @{
        @(0):LocalizationKey(@"充币"),
        @(1):LocalizationKey(@"提币"),
        @(2):LocalizationKey(@"转账"),
        @(5):LocalizationKey(@"母币转账"),
        @(6):LocalizationKey(@"母币划转"),
        @(7):LocalizationKey(@"母币收款"),
        @(8):LocalizationKey(@"邀请记录"),
    };
    return dic[@(self.index)];
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
