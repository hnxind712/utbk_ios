//
//  BTBaseViewController.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBaseViewController : UIViewController

- (void)hiddenLeft;//隐藏左按钮

- (void)backAction;

- (void)setupLayout;

- (void)setupBind;

@end

NS_ASSUME_NONNULL_END
