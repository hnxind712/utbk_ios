//
//  AppDelegate.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "YLNavigationController.h"
//#import "HomeViewController.h"
#import "YLTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initKeyboardManager];//初始化键盘
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
    self.window.rootViewController = SectionTabbar;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self PresentGestureLockViewController];
//    });
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;// 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO;// 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}
@end
