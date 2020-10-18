//
//  BTBaseViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"

@interface BTBaseViewController ()

@end

@implementation BTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NavColor;
    if (self.navigationController.viewControllers.count > 1) {
        [self addLeftNavigation];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self preferredStatusBarStyle];
    
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
// 返回你所需要的状态栏样式
    return UIStatusBarStyleDefault;
}
- (void)hiddenLeft{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;

}
- (void)addLeftNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_navLeft") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, StatusBarHeight, 40, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupLayout{
    
}

- (void)setupBind{
    
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
