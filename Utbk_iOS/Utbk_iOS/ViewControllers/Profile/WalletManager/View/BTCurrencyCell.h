//
//  BTCurrencyCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCurrencyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
