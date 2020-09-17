//
//  KLineModel.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "KLineModel.h"

@implementation KLineModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"vol" : @"volume",
    };
}

- (double)id {
    return self.time/1000.0f;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
