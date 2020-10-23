//
//  BTCurrencyModel.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCurrencyModel.h"

@implementation BTCurrencyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"currency":@"coin"
    };
}
@end
