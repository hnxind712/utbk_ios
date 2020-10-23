//
//  BTContributionVC.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTContributionVC : BTBaseViewController

@property (copy, nonatomic) NSString *coinName;//显示的币种

@property (copy, nonatomic) NSString *motherCoin;//母币币种，选择币种时需要传递的参数，作为关联参数用

@end

NS_ASSUME_NONNULL_END
