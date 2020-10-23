//
//  BTCurrencyModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCurrencyModel : NSObject

@property (copy, nonatomic) NSString *currency;//母币
@property (copy, nonatomic) NSString *rate;
@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
