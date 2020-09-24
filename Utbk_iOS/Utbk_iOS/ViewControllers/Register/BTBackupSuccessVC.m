//
//  BTBackupSuccessVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBackupSuccessVC.h"
#import "YLTabBarController.h"

@interface BTBackupSuccessVC ()

@end

@implementation BTBackupSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction{
    if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
    }else{
        YLTabBarController *tabbar = (YLTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        tabbar.selectedIndex = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
}
- (IBAction)completedAction:(UIButton *)sender {
    if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
         [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
     }else{
         YLTabBarController *tabbar = (YLTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
         tabbar.selectedIndex = 0;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.navigationController popToRootViewControllerAnimated:NO];
         });
     }
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
