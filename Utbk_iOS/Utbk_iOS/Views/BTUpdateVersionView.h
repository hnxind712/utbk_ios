//
//  BTUpdateVersionView.h
//  Utbk_iOS
//
//  Created by heyong on 2020/10/3.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTUpdateVersionView : UIView

@property (copy, nonatomic) void(^updateAction)(void);

+ (instancetype)show;

- (void)configureViewWithVersion:(NSString *)version content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
