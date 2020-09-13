//
//  UITextFeild+ChangePlaceholder.m
//  BTExchange
//
//  Created by Pizza on 2020/3/29.
//  Copyright © 2020 链世网络. All rights reserved.
//

#import "UITextFeild+ChangePlaceholder.h"

@implementation UITextField (Change)

- (void)setPlaceholderFont:(UIFont *)font {

  [self setPlaceholderColor:nil font:font];
}

- (void)setPlaceholderColor:(UIColor *)color {

  [self setPlaceholderColor:color font:nil];
}

- (void)setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font {

  if ([self checkPlaceholderEmpty]) {
      return;
  }
  
  NSMutableAttributedString *placeholderAttriString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
  if (color) {
      [placeholderAttriString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.placeholder.length)];
  }
  if (font) {
      [placeholderAttriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.placeholder.length)];
  }
  [self setAttributedPlaceholder:placeholderAttriString];
}

- (BOOL)checkPlaceholderEmpty {
  return (self.placeholder == nil) || ([[self.placeholder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

@end
