//
//  BTDropRecordViewController.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTPoolHoldCoinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTDropRecordViewController : BTBaseViewController

@property (strong, nonatomic) BTPoolHoldCoinModel *model;//需要传入当前币种的ID对应的model

@end

NS_ASSUME_NONNULL_END
