//
//  BTHistoryRecordModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTHistoryRecordModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) CGFloat balance;
@property (nonatomic,assign) NSInteger sort;

@end

NS_ASSUME_NONNULL_END
