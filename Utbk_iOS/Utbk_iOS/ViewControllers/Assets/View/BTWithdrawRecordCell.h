//
//  BTWithdrawRecordCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTWithdrawRecordCell : UITableViewCell

@property (copy, nonatomic) void(^recordDetailAction)(void);

- (void)configureCellWithRecordModel:(id)model;

@end

NS_ASSUME_NONNULL_END
