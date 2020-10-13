//
//  LSCustomNavigationController.m
//  LSBrightGreen
//
//  Created by heyong on 2020/4/9.
//  Copyright © 2020 HY. All rights reserved.
//

#import "LSCustomNavigationController.h"

@interface LSCustomNavigationController ()

@end

@implementation LSCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)initialize
{
    // 设置导航栏的主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:NavColor];
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:C_WIDTH(17.f)],NSForegroundColorAttributeName:RGBOF(0x000000)}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
