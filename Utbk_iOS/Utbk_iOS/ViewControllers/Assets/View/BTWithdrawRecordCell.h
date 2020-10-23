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

@property (assign, nonatomic) NSInteger index;//当前的记录类型，需要着重处理对应币种流水的情况下是按照model里面的type来处理的

@property (copy, nonatomic) void(^recordDetailAction)(void);

- (void)configureCellWithRecordModel:(id)model;//提币记录

- (void)configureCellWithStreamRecordModel:(id)model;//资产流水记录

- (void)configureCellWithMotherTransferRecordModel:(id)model;//原始母币转账

- (void)configureCellWithMotherActivityRecordModel:(id)model;//邀请激活记录

- (void)configureCellWithContributionRecordModel:(id)model;//贡献值记录

@end

NS_ASSUME_NONNULL_END
