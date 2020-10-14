//
//  BTAssetRecordModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/10/10.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTAssetRecordModel : NSObject
/**
 address = 30b56fa8ce96adace3ab0eb2ede94c3ac56cad2efc8ef94a35d1b4886b94125;
    airdropId = "<null>";
    amount = 10000;
    createTime = "2020-10-09 18:26:42";
    fee = 0;
    flag = 0;
    id = 811;
    memberId = 174;
    symbol = USDTTRC20;
    type = 2;
 */
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *airdropId;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *fee;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *symbol;
@property (nonatomic,assign)NSInteger type;
//以下为空投矿池记录新增
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *saveTime;

@end

NS_ASSUME_NONNULL_END
