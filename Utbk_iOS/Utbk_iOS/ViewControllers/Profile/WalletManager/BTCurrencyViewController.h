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

@end

NS_ASSUME_NONNULL_END
