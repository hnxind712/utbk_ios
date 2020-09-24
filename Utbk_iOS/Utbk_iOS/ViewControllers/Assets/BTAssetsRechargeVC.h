//
//  BTAssetsRechargeVC.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTAssetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAssetsRechargeVC : BTBaseViewController

@property (strong, nonatomic) BTAssetsModel *model;//直接将model给传过来
@property (assign, nonatomic) BOOL isRechage;//1代表充币，0代表收款，只需改title

@end

NS_ASSUME_NONNULL_END
