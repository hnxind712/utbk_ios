//
//  BTWithdrawRecordVC.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KRecordType) {
    KRecordTypeRecharge = 0,//充币
    KRecordTypeWithdraw,//USDT提币
    KRecordTypeTransfer,//转账
    KRecordTypeTransterIn,//资产转矿池
    KRecordTypeTransterOut,//矿池转资产
    KRecordTypeMotherCoinTransfer,//原始母币转账
    KRecordTypeMotherCoinSweep,//原始母币划转
    KRecordTypeMotherCoinRecharge,//原始母币收款
    KRecordTypeInvitationRecord,//邀请记录
    KRecordTypeContributionRecord,//贡献记录
    KRecordTypeUSDTRecharge,//USDT的充币记录
};
@interface BTWithdrawRecordVC : BTBaseViewController

@property (assign, nonatomic) KRecordType recordType;

@property (copy, nonatomic) NSString *unit;//币种名

@end

NS_ASSUME_NONNULL_END
