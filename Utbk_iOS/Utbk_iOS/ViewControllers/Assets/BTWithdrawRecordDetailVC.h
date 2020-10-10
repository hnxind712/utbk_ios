//
//  BTWithdrawRecordDetailVC.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTWithdrawRecordModel.h"
#import "BTMotherCoinModel.h"
#import "BTAssetRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTWithdrawRecordDetailVC : BTBaseViewController

@property (assign, nonatomic) NSInteger index;//

@property (strong, nonatomic) BTWithdrawRecordModel *recordModel;//提币详情
@property (strong, nonatomic) BTAssetRecordModel *assetModel;//资产流水详情
@property (strong, nonatomic) BTMotherCoinModel *model;//母币记录详情

@end

NS_ASSUME_NONNULL_END
