//
//  UIView+HJTheme.m
//  HJViewStyle_Example
//
//  Created by JohnnyHoo on 2018/12/20.
//  Copyright © 2018 Johnny. All rights reserved.
//

#import "UIView+HJTheme.h"

@implementation UIView (HJTheme)


/*
 因为很多APP都会有主题颜色,为了更方便的设置主题色可以重写下面的方法
 themeGradientEnable = YES 的时候将启用下面配色
 */

- (UIColor *)themeGradientAColor
{
    return [UIColor redColor];
}

- (UIColor *)themeGradientBColor
{
    return [UIColor blueColor];
}

- (NSInteger)themeGradientStyle
{
    return 2;
}
- (void)autoLayoutBottomHide:(BOOL)update {
    
    CGRect rc = self.frame;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.superview);
        make.height.offset(rc.size.height);
        make.top.equalTo(self.superview.mas_bottom);
    }];
    
    if (update) {
        [UIView animateWithDuration:.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
    }
}
- (void)autoLayoutBottomShow:(BOOL)update {
    
    CGRect rc = self.frame;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.superview);
        make.height.offset(rc.size.height);
    }];
    
    if (update) {
        [UIView animateWithDuration:.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
    }
}

@end
