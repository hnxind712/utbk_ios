//
//  UITextFeild+ChangePlaceholder.h
//  BTExchange
//
//  Created by Pizza on 2020/3/29.
//  Copyright © 2020 链世网络. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Change)

- (void)setPlaceholderFont:(UIFont *)font;

- (void)setPlaceholderColor:(UIColor *)color;

- (void)setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font;
@end

NS_ASSUME_NONNULL_END
