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
#import "TransactionViewController.h"
#import "BTAssetsViewController.h"
#import "BTProfileViewController.h"

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
    BTHomeViewController   *Section1VC = [[BTHomeViewController alloc] init];
    TransactionViewController *Section2VC = [[TransactionViewController alloc] init];
    BTAssetsViewController  *Section3VC = [[BTAssetsViewController alloc] init];
    BTProfileViewController *Section4VC = [[BTProfileViewController alloc] init];
    Section1VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"首页") image:[[UIImage imageNamed:@"icon_tabHomePage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabHomePageSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section2VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"交易") image:[[UIImage imageNamed:@"icon_tabTrading"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabTradingSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section3VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"资产") image:[[UIImage imageNamed:@"icon_tabAssets"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabAssetsSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Section4VC.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizationKey(@"我的") image:[[UIImage imageNamed:@"icon_tabProfile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"icon_tabProfileSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    YLNavigationController *Section1Navi = [[YLNavigationController alloc] initWithRootViewController:Section1VC];
    YLNavigationController *Section2Navi = [[YLNavigationController alloc] initWithRootViewController:Section2VC];
    YLNavigationController *Section3Navi = [[YLNavigationController alloc] initWithRootViewController:Section3VC];
    YLNavigationController *Section4Navi = [[YLNavigationController alloc] initWithRootViewController:Section4VC];
    self.viewControllers = @[Section1Navi,Section2Navi,Section3Navi,Section4Navi];
    
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
//    LoginViewController*loginVC=[[LoginViewController alloc]init];
//    YLNavigationController *nav = [[YLNavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:nil];
}
//重置tabar标题
-(void)resettabarItemsTitle{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    item1.title = LocalizationKey(@"首页");
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    item2.title=LocalizationKey(@"交易");
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    item3.title=LocalizationKey(@"资产");
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    item4.title=LocalizationKey(@"我的");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
