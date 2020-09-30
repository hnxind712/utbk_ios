//
//  BTAssetsModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WalletManageCoinInfoModel;

@interface BTAssetsModel : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,strong)WalletManageCoinInfoModel *coin;
@property(nonatomic,copy)NSString *frozenBalance;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *clickIndex;
@property(nonatomic,copy)NSString *toReleased;
@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,assign)BOOL isLock;
@property(nonatomic,assign)BOOL isHidden;
@property(nonatomic,copy)NSString *releaseBalance;
@property(nonatomic,strong)NSDictionary *usdtAddress;

@end


@interface WalletManageCoinInfoModel : NSObject
@property(nonatomic,copy)NSString *canAutoWithdraw;
@property(nonatomic,assign)BOOL canRecharge;//能否充币
@property(nonatomic,assign)BOOL canWithdraw;//能否提币
@property(nonatomic,assign)BOOL canTransfer;//能否转账
@property(nonatomic,copy)NSString *cnyRate;
@property(nonatomic,copy)NSString *enableRpc;
@property(nonatomic,copy)NSString *maxTxFee;
@property(nonatomic,copy)NSString *maxWithdrawAmount;
@property(nonatomic,copy)NSString *minTxFee;
@property(nonatomic,copy)NSString *minWithdrawAmount;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *nameCn;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *usdRate;
@property(nonatomic,copy)NSString *withdrawThreshold;

@end
NS_ASSUME_NONNULL_END
