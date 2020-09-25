//
//  BTPoolHoldCoinModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/25.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTPoolHoldCoinModel : NSObject
/**
 balance = "200.12";
 coinId = BTCK;
 coinName = BTCK;
 id = 1;
 profitAmount = 0;
 saveTime = "2020-09-22 18:08:20";
 updateTime = "2020-09-22 18:08:20";
 userId = 83;
 yesterdayProfit = 0;
 */
@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *coinId;
@property (copy, nonatomic) NSString *coinName;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) CGFloat profitAmount;
@property (copy, nonatomic) NSString *saveTime;
@property (copy, nonatomic) NSString *updateTime;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) CGFloat yesterdayProfit;

@end

NS_ASSUME_NONNULL_END
