//
//  BTWalletManagerModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTWalletManagerModel : NSObject

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) BOOL isCurrent;//当前的
@property (assign, nonatomic) BOOL isActive;//是否激活

@end

NS_ASSUME_NONNULL_END
