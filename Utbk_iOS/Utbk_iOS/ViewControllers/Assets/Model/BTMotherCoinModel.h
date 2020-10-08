//
//  BTMotherCoinModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/10/8.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTMotherCoinModel : NSObject

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger motherCoinWalletId;
@property (nonatomic,copy) NSString *coinId;
@property (nonatomic,copy) NSString *beforeBalance;
@property (nonatomic,copy) NSString *afterBalance;
@property (nonatomic,copy) NSString *serviceFee;
@property (nonatomic,copy) NSString *destructionFee;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
