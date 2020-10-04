//
//  BTAssetSweepVC.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/29.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTAssetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAssetSweepVC : BTBaseViewController

@property (assign, nonatomic) NSInteger assetIndex;//1为资产转矿池，2为矿池转资产
@property (strong, nonatomic) BTAssetsModel *assets;

@end

NS_ASSUME_NONNULL_END
