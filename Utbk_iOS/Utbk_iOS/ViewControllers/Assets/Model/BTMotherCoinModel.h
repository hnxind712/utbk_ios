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
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *address;
//母币激活列表字段
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *saveTime;
@property (nonatomic,copy)NSString *memberId;//通过当前参数来判断是否为激活还是被激活

@end

NS_ASSUME_NONNULL_END
