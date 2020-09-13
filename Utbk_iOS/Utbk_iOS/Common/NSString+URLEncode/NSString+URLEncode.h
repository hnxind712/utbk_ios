//
//  NSString+URLEncode.h
//  BTExchange
//
//  Created by LS on 2020/4/13.
//  Copyright © 2020 链世网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLEncode)

- (NSString *)URLEncode;
- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLDecode;
- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
