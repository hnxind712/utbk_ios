//
//  MyEntrustTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/10.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "MyEntrustTableViewCell.h"

@implementation MyEntrustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)completeBtnClick:(id)sender {
    if (self.entrustBlock) {
        self.entrustBlock();
    }
}

- (void)setInfomodel:(MyEntrustInfoModel *)infomodel{
    _infomodel = infomodel;
    self.timeTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"time" value:nil table:@"Localizable"];
    self.entrustPriceTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"enterPrice" value:nil table:@"Localizable"],_infomodel.baseSymbol];//委托价格
    self.entrustNumTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"entrustNum" value:nil table:@"Localizable"],_infomodel.coinSymbol];//委托量
    self.dealTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"dealTotal" value:nil table:@"Localizable"],_infomodel.baseSymbol];//成交总额
    self.dealPerPriceTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"dealPerPrice" value:nil table:@"Localizable"],_infomodel.baseSymbol];
    self.dealNumTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"dealNum" value:nil table:@"Localizable"],_infomodel.coinSymbol];
    
    self.lastLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Entrustmentamount" value:nil table:@"Localizable"];
    
    self.symbolLabel.text = _infomodel.symbol;
    //时间
    NSString *time ;
    if (_infomodel.time.length > 9) {
        time = [ToolUtil timeIntervalToTimeString:_infomodel.time  WithDateFormat:@"yyyy-MM-dd-HH-mm"];

    }else{
        time = @"0000-00-00-00-00";
    }
    NSArray *times = [time componentsSeparatedByString:@"-"];
    self.timeData.text = [NSString stringWithFormat:@"%@:%@ %@/%@", times[3], times[4], times[1], times[2]];
    
//    if ([_infomodel.type isEqualToString:@"LIMIT_PRICE"]) {//委托价数据
//        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"limitPrice" value:nil table:@"Localizable"];
//    }else if ([_infomodel.type isEqualToString:@"CHECK_FULL_STOP"]){
//        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"Stoploss" value:nil table:@"Localizable"];
//    }else{
//        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"marketPrice" value:nil table:@"Localizable"];
//    }
    //委托价
    self.ntrustPriceData.text = [ToolUtil stringFromNumber:infomodel.price.doubleValue withlimit:KLimitAssetInputDigits];
    //委托量
    self.entrustNumData.text = [ToolUtil stringFromNumber:infomodel.amount.doubleValue withlimit:KLimitAssetInputDigits];
    //
//    if ([_infomodel.tradedAmount floatValue] <= 0) {
//        self.entrustNumData.text = [NSString stringWithFormat:@"0.00"];
//    }else{
//        NSDecimalNumber *dec = [[NSDecimalNumber alloc] initWithString:_infomodel.price];
//        self.entrustNumData.text = [dec stringValue];
//    }
    //成交总量
    self.dealData.text = [ToolUtil stringFromNumber:infomodel.turnover.doubleValue withlimit:KLimitAssetInputDigits];
//    if ([_infomodel.type isEqualToString:@"MARKET_PRICE"]) {
//        NSDecimalNumber *dec = [[NSDecimalNumber alloc] initWithString:_infomodel.tradedAmount];
//        self.dealData.text =  [dec stringValue];
//    }else{
//        NSDecimalNumber *dec = [[NSDecimalNumber alloc] initWithString:_infomodel.amount];
//        self.dealData.text =  [dec stringValue];
//    }
    //成交均价
//    NSDecimalNumber *tradedAmount = [[NSDecimalNumber alloc] initWithString:_infomodel.tradedAmount];
    self.dealPerPriceData.text = infomodel.tradedAmount.doubleValue == 0 ? @"0.0000" : [ToolUtil stringFromNumber:infomodel.turnover.doubleValue/infomodel.tradedAmount.doubleValue withlimit:KLimitAssetInputDigits];;
    //成交价
    self.dealNumData.text = [ToolUtil stringFromNumber:infomodel.tradedAmount.doubleValue withlimit:KLimitAssetInputDigits];
//    if (_infomodel.triggerPrice) {
//        NSDecimalNumber *triggerPrice = [[NSDecimalNumber alloc] initWithString:_infomodel.triggerPrice];
//        self.dealNumData.text = [triggerPrice stringValue];
//    }
    //委托价格
    NSDecimalNumber *turnover = [[NSDecimalNumber alloc] initWithString:_infomodel.turnover];
    self.lastValueLabel.text = [turnover stringValue];
    
    self.payStatus.font = [UIFont systemFontOfSize:17];
    if ([_infomodel.direction isEqualToString:@"BUY"]) {
        self.payStatus.text = LocalizationKey(@"buyDirection");
        self.payStatus.textColor = RGBOF(0x00B274);
    }else{
        self.payStatus.text = LocalizationKey(@"sellDirection");
        self.payStatus.textColor = RGBOF(0xF15057);
    }
    
    [self.statusButton setTitleColor:RGBOF(0x666666) forState:UIControlStateNormal];
    if ([_infomodel.status isEqualToString:@"COMPLETED"]) {
        [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"completed" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    }else if ([_infomodel.status isEqualToString:@"WAITING_TRIGGER"]){
        [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"waitingTrigger" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    }else if ([_infomodel.status isEqualToString:@"TRADING"]){
        [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"trading" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    }else if ([_infomodel.status isEqualToString:@"CANCELED"]){
        [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"cancelled" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    }else{
        [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"Timeout" value:nil table:@"Localizable"] forState:UIControlStateNormal];
    }
    
}

- (void)setModel:(commissionModel *)model{
    _model = model;
    self.timeTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"time" value:nil table:@"Localizable"];
    self.entrustPriceTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"type" value:nil table:@"Localizable"];
    self.entrustNumTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"price" value:nil table:@"Localizable"],model.baseSymbol];
    self.dealTitle.text = [NSString stringWithFormat:@"%@(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"amonut" value:nil table:@"Localizable"],model.coinSymbol];
    self.dealPerPriceTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"tradeDeal" value:nil table:@"Localizable"];
    self.dealNumTitle.text = [[ChangeLanguage bundle] localizedStringForKey:@"Triggerprice" value:nil table:@"Localizable"];
    self.lastLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Entrustmentamount" value:nil table:@"Localizable"];
    
    self.symbolLabel.text = model.symbol;
    //时间
    NSString *time ;
    if (model.time.length > 9) {
        time = [ToolUtil timeIntervalToTimeString:model.time WithDateFormat:@"yyyy-MM-dd-HH-mm"];
    }else{
        time = @"0000-00-00-00-00";
    }
    NSArray *times = [time componentsSeparatedByString:@"-"];
    self.timeData.text = [NSString stringWithFormat:@"%@:%@ %@/%@", times[3], times[4], times[1], times[2]];
    
    if ([model.type isEqualToString:@"LIMIT_PRICE"]) {
        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"limitPrice" value:nil table:@"Localizable"];
    }else if ([model.type isEqualToString:@"CHECK_FULL_STOP"]){
        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"Stoploss" value:nil table:@"Localizable"];
    }else{
        self.ntrustPriceData.text = [[ChangeLanguage bundle] localizedStringForKey:@"marketPrice" value:nil table:@"Localizable"];
    }
    
    //价格
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:model.price];
    self.entrustNumData.text = [price stringValue];

    //数量
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:model.amount];
    self.dealData.text = [amount stringValue];
    //已成交
    NSDecimalNumber *tradedAmount = [NSDecimalNumber decimalNumberWithString:model.tradedAmount];
    self.dealPerPriceData.text = [tradedAmount stringValue];
    //触发价
    if (model.triggerPrice) {
        NSDecimalNumber *triggerPrice = [NSDecimalNumber decimalNumberWithString:model.triggerPrice];
        self.dealNumData.text = [triggerPrice stringValue];
    }else{
        self.dealNumData.text = @"0.00";
    }
    //委托价格
    self.lastValueLabel.text = [[price decimalNumberByMultiplyingBy:tradedAmount] stringValue];
    
    self.payStatus.font = [UIFont systemFontOfSize:14];
    if ([model.direction isEqualToString:@"BUY"]) {
        self.payStatus.text = LocalizationKey(@"buyDirection");
        self.payStatus.textColor = RGBOF(0x00B274);
    }else{
        self.payStatus.text = LocalizationKey(@"sellDirection");
        self.payStatus.textColor = RGBOF(0xF15057);
    }
    
    [self.statusButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"Revoke" value:nil table:@"Localizable"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
