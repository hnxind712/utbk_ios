//
//  BTCurrencyCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCurrencyCell.h"
#import "BTCurrencyModel.h"

@implementation BTCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTCurrencyModel *)model{
    self.selectedBtn.selected = model.isSelected;
    self.currency.textColor = model.isSelected ? RGBOF(0x786236) : RGBOF(0x333333);
    self.currency.text = model.currency;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
