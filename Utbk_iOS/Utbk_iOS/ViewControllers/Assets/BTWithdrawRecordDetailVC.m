//
//  BTWithdrawRecordDetailVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWithdrawRecordDetailVC.h"

@interface BTWithdrawRecordDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *withdrawCount;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation BTWithdrawRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Detail");
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    if (self.model) {
        self.withdrawCount.text = [NSString stringWithFormat:@"%@%@ %@",self.model.type == 0 ? @"-" : @"+",[ToolUtil judgeStringForDecimalPlaces:self.model.amount],self.model.coinId];
        self.time.text = [ToolUtil transformForTimeString:self.model.createTime];
        self.address.text = self.model.address;
        self.status.text = LocalizationKey(@"Success");
        self.type.text = [self typeString];
    }else if (self.assetModel){
        //对应的转账、资产转矿池为-号，充值以及矿池转资产为+
        self.withdrawCount.text = [NSString stringWithFormat:@"%@%@ %@",self.assetModel.type ? @"-" : @"+",self.assetModel.amount,self.assetModel.coinId];
        self.time.text = [ToolUtil transformForTimeString:self.assetModel.createTime];
        self.address.text = self.assetModel.address;
        self.status.text = LocalizationKey(@"Success");
        self.type.text = [self typeStringWithModelType];
        
    }else if (self.recordModel){
        self.withdrawCount.text = [NSString stringWithFormat:@"-%@ %@",[ToolUtil judgeStringForDecimalPlaces:self.recordModel.totalAmount],self.recordModel.coin.unit];
        self.time.text = [ToolUtil transformForTimeString:self.recordModel.createTime];
        self.address.text = self.recordModel.address;
        if (self.recordModel.status == 0) {
             self.status.text = LocalizationKey(@"auditing");
         }else if (self.recordModel.status == 1){
             self.status.text = LocalizationKey(@"Assetstoreleased");

         }else if (self.recordModel.status == 2){
             self.status.text = LocalizationKey(@"failure");
         }else if(self.recordModel.status == 3){
             self.status.text = LocalizationKey(@"Success");
         }
        self.type.text = self.index == 1 ? LocalizationKey(@"提币") : LocalizationKey(@"转账");
    }
    
}
- (NSString *)typeString{
    NSDictionary *dic = @{
        @(5):LocalizationKey(@"母币转账"),
        @(6):LocalizationKey(@"母币划转"),
        @(7):LocalizationKey(@"母币收款"),
        @(8):LocalizationKey(@"邀请激活")
    };
    return dic[@(self.index)];
}
- (NSString *)typeStringWithModelType{//需按照类型来处理
    NSDictionary *dic = @{
        @(0):LocalizationKey(@"充币"),
        @(1):LocalizationKey(@"转出"),
    };
    return dic[@(self.assetModel.type)];
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
