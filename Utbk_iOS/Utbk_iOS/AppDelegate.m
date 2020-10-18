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
#import "YLTabBarController.h"
#import <UserNotifications/UserNotifications.h>
#import <CoreTelephony/CTCellularData.h>
#import <WebKit/WebKit.h>
#import "BTRegisterViewController.h"
#import "MarketNetManager.h"
#import "BTWalletManagerVC.h"
#import <V5Client/V5ClientAgent.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self getUSDTToCNYRate];
    [self initKeyboardManager];//初始化键盘
    [self configure];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    if (![YLUserInfo isLogIn]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
        NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
        if (list.count) {
            BTWalletManagerVC *registerVC = [[BTWalletManagerVC alloc]init];
            registerVC.isLogin = YES;
            YLNavigationController *nav = [[YLNavigationController alloc]initWithRootViewController:registerVC];
            self.window.rootViewController = nav;
        }else{
            BTRegisterViewController *registerVC = [[BTRegisterViewController alloc]init];
            YLNavigationController *nav = [[YLNavigationController alloc]initWithRootViewController:registerVC];
            self.window.rootViewController = nav;
        }
    }else{
        YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
        self.window.rootViewController = SectionTabbar;
    }
    // 初始化客服SDK
    [V5ClientAgent initWithSiteId:KCustomerServiceSiteID
                            appId:KCustomerServiceAppID
                   exceptionBlock:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createTabbar) name:KfirstLogin object:nil];//第一次创建钱包备份完或者稍后备份的时候需要创建首页
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark createTabbar
- (void)createTabbar{
    YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
    self.window.rootViewController = SectionTabbar;
}
- (void)configure{
    self.CNYRate = [NSDecimalNumber decimalNumberWithString:@"0.00"];
//    [ChangeLanguage setUserlanguage:@"zh-Hans"];//暂时设定为中文
    [ChangeLanguage initUserLanguage];//初始化语言
    BOOL connect = [[SocketManager share] connect];//连接行情socket
    NSLog(@"socket是否连接成功 = %d",connect);
}
-(void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;// 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES;// 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}
#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.CNYRate = [NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
            }
        }
    }];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 退出到后台时，通知SDK用户离线
    [[V5ClientAgent shareClient] onApplicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 移动到前台时，通知SDK用户上线并连接
    [[V5ClientAgent shareClient] onApplicationWillEnterForeground];
}

#pragma mark 注册推送
- (void)registNotification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //    注册远程通知服务
    if (@available(iOS 10.0, *)) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];

        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            //            NSLog(@"========%@",settings);
        }];
    }else {
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication]registerForRemoteNotifications];
}
#pragma mark-注册远程通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //获取deviceToken
    NSString *_deviceToken = [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                    stringByReplacingOccurrencesOfString:@">" withString:@""];
    if (_deviceToken) {
        [[NSUserDefaults standardUserDefaults]setObject:_deviceToken forKey:@"_deviceToken_"];
    }
}
#pragma mark-注册远程通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败--%@",[error description]);
}

#pragma mark-收到远程推送(点击通知栏进入App或者App在前台时触发)
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){//点击通知栏进来
//        YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
//        NSLog(@"远程推送的信息是--%@",userInfo);
//        ChatGroupInfoModel *model=[ChatGroupInfoModel mj_objectWithKeyValues:userInfo[@"addition"]];
//        MyBillChatViewController *chatVC = [[MyBillChatViewController alloc] init];
//        chatVC.hidesBottomBarWhenPushed = YES;
//        chatVC.clickIndex = 1;
//        chatVC.groupModel= model;
//        [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
//        [ChatGroupFMDBTool createTable:model withIndex:0];
    }
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}
- (UIViewController *)topViewController
{
    UINavigationController *nav = [self navigationViewController];
    return nav.topViewController;
}
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *top = [self topViewController];
    
    if (vc.navigationController == nil)
    {
        if ([vc isKindOfClass:NSClassFromString(@"PGDatePickManager")] || [vc isKindOfClass:NSClassFromString(@"ZLGestureLockViewController")]) {
            [top presentViewController:vc animated:animated completion:completion];
        }else{
            YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:vc];
            [top presentViewController:nav animated:animated completion:completion];
        }
    }
    else
    {
        [top presentViewController:vc animated:animated completion:completion];
    }
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (vc.navigationController != [AppDelegate sharedAppDelegate].navigationViewController)
    {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}
@end
