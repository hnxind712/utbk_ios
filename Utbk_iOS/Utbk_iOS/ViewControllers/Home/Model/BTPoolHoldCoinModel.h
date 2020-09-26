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
@property (copy, nonatomic) NSString *big_airdrop_profit;
@property (copy, nonatomic) NSString *coinId;
@property (copy, nonatomic) NSString *coinName;
@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *profitAmount;
@property (copy, nonatomic) NSString *saveTime;
@property (copy, nonatomic) NSString *subcoinCoin;
@property (copy, nonatomic) NSString *subcoinProfitAmount;
@property (copy, nonatomic) NSString *subcoinYesterdayProfit;
@property (copy, nonatomic) NSString *updateTime;
@property (assign, nonatomic) NSInteger userId;
@property (copy, nonatomic) NSString *yesterdayProfit;
@property (copy, nonatomic) NSString *smallTotalBanance;//小区合计

@end

NS_ASSUME_NONNULL_END
