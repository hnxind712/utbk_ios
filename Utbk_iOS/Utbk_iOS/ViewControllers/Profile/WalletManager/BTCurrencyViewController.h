//
//  BTCurrencyViewController.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCurrencyViewController : BTBaseViewController

@property (copy, nonatomic) void(^selectedCurrency)(id model);//将选中的model回调过去

@property (copy, nonatomic) NSString *curreny;//暂定

@property (copy, nonatomic) NSString *motherCoin;//母币

//由于不同的需求取不同的数据或者请求不同的数据
@property (assign, nonatomic) NSInteger index;//0代表贡献，1代表团队持仓

@end

NS_ASSUME_NONNULL_END
