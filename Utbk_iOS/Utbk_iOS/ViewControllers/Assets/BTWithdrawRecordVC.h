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
    KRecordTypeRecharge = 0,
    KRecordTypeWithdraw
};
@interface BTWithdrawRecordVC : BTBaseViewController

@property (assign, nonatomic) KRecordType recordType;

@end

NS_ASSUME_NONNULL_END
