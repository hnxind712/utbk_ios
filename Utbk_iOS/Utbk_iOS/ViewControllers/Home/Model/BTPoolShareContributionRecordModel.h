//
//  BTPoolShareContributionRecordModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/25.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTPoolShareContributionRecordModel : NSObject
/**
 afterQty = 2;
 afterWalletBalance = 6;
 amount = 2;
 beforeQty = 2;
 beforeWalletBalance = 4;
 coin = BTCK;
 contributionValue = 20;
 groupQty = 2;
 id = 5;
 produce = 2;
 remarks = "\U5171\U4eab\U77ff\U6c60\U4ea7\U51fa";
 saveTime = "2020-09-24 16:02:01";
 type = 2;
 userId = 83;
 */
@property (assign, nonatomic) NSInteger afterQty;
@property (assign, nonatomic) CGFloat afterWalletBalance;
@property (assign, nonatomic) CGFloat amount;
@property (assign, nonatomic) NSInteger beforeQty;
@property (assign, nonatomic) CGFloat beforeWalletBalance;
@property (copy, nonatomic) NSString *coin;
@property (assign, nonatomic) CGFloat contributionValue;
@property (assign, nonatomic) NSInteger groupQty;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) CGFloat produce;
@property (copy, nonatomic) NSString *remarks;
@property (copy, nonatomic) NSString *saveTime;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) CGFloat multiple;//倍数
@property (assign, nonatomic) NSInteger star;//星级

@end

NS_ASSUME_NONNULL_END
