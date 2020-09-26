//
//  BTPoolRecordModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/26.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTPoolRecordModel : NSObject//空投收益记录、划转记录均用当前model
/**
 "id":2,
 "mineWalletId":1,
 "amount":100,//空投数量
 "type":1,//记录类型 1钱包转入矿池钱包 2矿池转出到钱包 3空投收益 4邀请收益
 "saveTime":"2020-09-22 14:25:53",
 "coinId":"BTCK", //币种
 "coinName":"BTCK", //币种
 "beforeAmount":200, 空投前矿池数量
 "afterAmount":null, //空投后矿池数量
 "remarks":"划转到矿池", //备注
 "direction":"input", //划转方向 inpue 转入 output转出
 "userId":83,
 "memberWalletBalance":400　//划转后资产钱包剩余数量
 */
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger mineWalletId;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *saveTime;
@property (nonatomic,copy) NSString *coinId;
@property (nonatomic,copy) NSString *coinName;
@property (nonatomic,copy) NSString *beforeAmount;
@property (nonatomic,copy) NSString *afterAmount;
@property (nonatomic,copy) NSString *remarks;
@property (nonatomic,copy) NSString *direction;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *memberWalletBalance;

@end

NS_ASSUME_NONNULL_END
