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

NS_ASSUME_NONNULL_BEGIN

@interface BTWithdrawRecordDetailVC : BTBaseViewController

@property (assign, nonatomic) NSInteger index;//

@property (strong, nonatomic) BTWithdrawRecordModel *recordModel;
@property (strong, nonatomic) BTMotherCoinModel *model;

@end

NS_ASSUME_NONNULL_END
