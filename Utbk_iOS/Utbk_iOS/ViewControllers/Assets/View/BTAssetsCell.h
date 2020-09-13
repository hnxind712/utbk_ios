//
//  BTAssetsCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTAssetsCell : UITableViewCell

@property (copy, nonatomic) void(^cellBtnClickAction)(NSInteger index);//0代表收款，1代表转账，2代表划转

- (void)configureCellWithAssetsModel:(id)model;

@end

NS_ASSUME_NONNULL_END
