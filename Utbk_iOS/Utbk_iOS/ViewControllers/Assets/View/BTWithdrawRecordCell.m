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
#import "BTAssetRecordModel.h"

@interface BTWithdrawRecordCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusTitle;

@end

@implementation BTWithdrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//提币记录
- (void)configureCellWithRecordModel:(BTWithdrawRecordModel *)model{
    self.title.text = [NSString stringWithFormat:@"%@\n%@",[self typeString],_BTS(model.address)];
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
    self.topConstraint.constant = model.address.length ? 13.f : 23.f;
}
//流水记录
- (void)configureCellWithStreamRecordModel:(BTAssetRecordModel *)model{
    if (model.address.length) {
        self.title.text = [NSString stringWithFormat:@"%@\n%@",(self.index == 3 || self.index == 4) ? model.remarks : [self typeStringWithType:model.type],_BTS(model.address)];
    }else{
        self.title.text = [NSString stringWithFormat:@"%@",(self.index == 3 || self.index == 4) ? model.remarks : [self typeStringWithType:model.type]];
    }
    if (self.index == 2 && model.type == 0) {//资产转入一定有地址
        self.title.text = [NSString stringWithFormat:@"%@\n%@",LocalizationKey(@"转入"),_BTS(model.address)];
    }
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:model.amount];
    self.time.text = [ToolUtil transformForTimeString:(self.index == 3 || self.index == 4) ? model.saveTime : model.createTime];
    self.status.text = LocalizationKey(@"Success");
    self.moreBtn.hidden = (self.index == 3 || self.index == 4);
    self.topConstraint.constant = model.address.length ? 13.f : 23.f;
}
//邀请记录
- (void)configureCellWithMotherActivityRecordModel:(BTMotherCoinModel *)model{
    self.statusTitle.text = LocalizationKey(@"币种");
    if ([[NSString stringWithFormat:@"%@",model.memberId] isEqualToString:[YLUserInfo shareUserInfo].ID]) {
        self.title.text = [NSString stringWithFormat:@"%@ %@",model.username,LocalizationKey(@"为您激活")];
        self.count.text = @"+0.0100";
    }else{
        self.title.text = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"激活账户"),model.username];
        self.count.text = @"-0.0100";
    }
    self.status.text = [NSString stringWithFormat:@"BTCK%@",LocalizationKey(@"原始母币")];
    self.time.text = [ToolUtil transformForTimeString:model.saveTime];
    self.moreBtn.hidden = YES;
    self.topConstraint.constant = model.address.length ? 13.f : 23.f;
}
- (void)configureCellWithMotherTransferRecordModel:(BTMotherCoinModel *)model{
    self.title.text = [NSString stringWithFormat:@"%@\n%@",[self typeString],_BTS(model.address)];
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:model.amount];
    self.time.text = [ToolUtil transformForTimeString:model.createTime];
    self.status.text = LocalizationKey(@"Success");
    self.moreBtn.hidden = (self.index != 6) ? NO : YES;
    self.topConstraint.constant = model.address.length ? 13.f : 23.f;
}
- (void)configureCellWithContributionRecordModel:(BTPoolShareContributionRecordModel *)model{
    self.title.text = model.remarks;
    self.count.text = [ToolUtil judgeStringForDecimalPlaces:[NSString stringWithFormat:@"%.4f",model.amount]];
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
- (NSString *)typeStringWithType:(NSInteger)type{
    NSDictionary *dic = @{
        @(0):LocalizationKey(@"充币"),
        @(1):LocalizationKey(@"转出"),
    };
    return dic[@(type)];
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
