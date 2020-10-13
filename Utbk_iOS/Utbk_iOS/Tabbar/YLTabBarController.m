//
//  YLTabBarController.m
//  BaseProject
//
//  Created by YLCai on 16/11/23.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#import "YLTabBarController.h"
#import "YLNavigationController.h"
#import "BTHomeViewController.h"
#import "BTMarketViewController.h"
#import "TransactionViewController.h"//目前只需要币币交易
#import "TradeViewController.h"//币币交易
#import "BTAssetsViewController.h"
#import "BTProfileViewController.h"
#import "BTWalletManagerVC.h"
#import "LSCustomNavigationController.h"

@interface YLTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation YLTabBarController

+(YLTabBarController *)defaultTabBarContrller{
    static YLTabBarController *tabBar = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[YLTabBarController alloc] init];
    });
    return tabBar;
}

+(void)initialize{
    if (self == [YLTabBarController class]) {
        UITabBar *tabBar = [UITabBar appearance];
        tabBar.barTintColor = [UIColor whiteColor];
        tabBar.translucent = NO;
        tabBar.barStyle = UIBarStyleBlack;
        UITabBarItem *barItem = [UITabBarItem appearance];
        //设置item中文字的普通样式
        NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
        normalAttributes[NSForegroundColorAttributeName] = RGBOF(0x9A9A9A);
        normalAttributes[NSFontAttributeName] = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        //设置item中文字被选中的样式
        NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
        selectedAttributes[NSForegroundColorAttributeName] = RGBOF(0xA8865A);//RGBOF(0xF0A70A);
        selectedAttributes[NSFontAttributeName] = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    [self dropShadowWithOffset:CGSizeMake(0, 0)
                        radius:5
                         color:[UIColor blackColor]
                       opacity:0.14];
    //添加子控制器
    [self initTabbar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginViewController) name:KLogoutKey object:nil];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    self.tabBar.clipsToBounds = NO;
}

-(void)initTabbar{
    BTHomeViewController   *section1VC = [[BTHomeViewController alloc] init];
    BTMarketViewController *section2VC = [[BTMarketViewController alloc]init];
    TradeViewController *section3VC = [[TradeViewController alloc] init];
    BTAssetsViewController  *section4VC = [[BTAssetsViewController alloc] init];
    BTProfileViewController *section5VC = [[BTProfileViewController alloc] init];
    section1VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar1") image:[[UIImage imageNamed:@"icon_tabHomePage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabHomePageSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    section2VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar2") image:[[UIImage imageNamed:@"icon_tabbarMarket"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabbarMarketSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    section3VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar3") image:[[UIImage imageNamed:@"icon_tabTrading"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabTradingSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    section4VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar4") image:[[UIImage imageNamed:@"icon_tabAssets"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabAssetsSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    section5VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"tabbar5") image:[[UIImage imageNamed:@"icon_tabProfile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabProfileSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    YLNavigationController *section1Navi = [[YLNavigationController alloc] initWithRootViewController:section1VC];
    YLNavigationController *section2Navi = [[YLNavigationController alloc]initWithRootViewController:section2VC];
    YLNavigationController *section3Navi = [[YLNavigationController alloc] initWithRootViewController:section3VC];
    YLNavigationController *section4Navi = [[YLNavigationController alloc] initWithRootViewController:section4VC];
    YLNavigationController *section5Navi = [[YLNavigationController alloc] initWithRootViewController:section5VC];
    self.viewControllers = @[section1Navi,section2Navi,section3Navi,section4Navi,section5Navi];
    
}


#pragma mark Tabbar的代理
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.viewControllers[3]) {
//        if (![YLUserInfo isLogIn]) {//未登录
//            [self showLoginViewController];
//            return NO;
//        }
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
        
}

-(void)showLoginViewController{
    if ([[[AppDelegate sharedAppDelegate]topViewController]isKindOfClass:[BTWalletManagerVC class]]) return;
    BTWalletManagerVC *loginVC = [[BTWalletManagerVC alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
//重置tabar标题
-(void)resettabarItemsTitle{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    item1.title = LocalizationKey(@"tabbar1");
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    item2.title = LocalizationKey(@"tabbar2");
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    item3.title = LocalizationKey(@"tabbar3");
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    item4.title = LocalizationKey(@"tabbar4");
    UITabBarItem *item5 = [tabBar.items objectAtIndex:4];
    item5.title = LocalizationKey(@"tabbar5");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
