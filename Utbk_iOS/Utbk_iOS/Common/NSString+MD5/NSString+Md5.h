//
//  NSString+Md5.h
//  BTExchange
//
//  Created by Pizza on 2020/3/17.
//  Copyright © 2020 链世网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Md5)
- (NSString *)MD5String;
- (NSString *)passwordMD5String;
@end

NS_ASSUME_NONNULL_END
