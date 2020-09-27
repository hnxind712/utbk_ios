//
//  BTMarketTableViewCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTMarketTableViewCell.h"
#import "symbolModel.h"

@implementation BTMarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithModel:(symbolModel *)model{
    self.coin.text = model.symbol;
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithDecimal:[model.close decimalValue]];
    NSDecimalNumber *baseUsdRate = [NSDecimalNumber decimalNumberWithDecimal:[model.baseUsdRate decimalValue]];
    
     if (((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate) {
    
         NSDecimalNumber *result = [[close decimalNumberByMultiplyingBy:baseUsdRate] decimalNumberByMultiplyingBy:((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate];
         NSString *resultStr = [result stringValue];
         if ([resultStr containsString:@"."]) {
             NSArray *arr = [resultStr componentsSeparatedByString:@"."];
             if (arr.count > 1 && [arr[1] length] > 2) {
                 resultStr = [NSString stringWithFormat:@"%@.%@",arr[0],[arr[1] substringWithRange:NSMakeRange(0, 2)]];
             }
         }
         self.convertLabel.text=[NSString stringWithFormat:@"≈￥%@ CNY",resultStr];
         
     }else{
         self.convertLabel.text = @"≈￥0.00 CNY";
     }
    self.leading.constant = (SCREEN_WIDTH - 24)/2 - 30;
    self.currenctLabel.text = [NSString stringWithFormat:@"%@",[ToolUtil judgeStringForDecimalPlaces:[close stringValue]]];
    self.lineLabel.text = [NSString stringWithFormat:@"24H %.2f",model.volume];
    if (model.change <0) {
        self.currenctLabel.textColor = RedColor;
        self.riseFall.backgroundColor=RedColor;
        self.riseFall.text = [NSString stringWithFormat:@"%.2f%%", model.chg*100];

    }else{
        self.currenctLabel.textColor = GreenColor;
        self.riseFall.backgroundColor = GreenColor;
        self.riseFall.text = [NSString stringWithFormat:@"+%.2f%%", model.chg*100];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
