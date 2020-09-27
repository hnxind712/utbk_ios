//
//  BTMarketTableViewCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTMarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coin;//币种
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;//24H 0
@property (weak, nonatomic) IBOutlet UILabel *currenctLabel;//当前价
@property (weak, nonatomic) IBOutlet UILabel *convertLabel;//折合价
@property (weak, nonatomic) IBOutlet UILabel *riseFall;//涨跌幅
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
