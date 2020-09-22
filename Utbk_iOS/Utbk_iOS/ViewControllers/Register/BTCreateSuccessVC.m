//
//  BTCreateSuccessVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCreateSuccessVC.h"
#import "BTBackupMnemonicsVC.h"
#import "YLTabBarController.h"

@interface BTCreateSuccessVC ()

@end

@implementation BTCreateSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction{
    if ([[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
    }
}
//马上备份
- (IBAction)copyImmediately:(UIButton *)sender {
    BTBackupMnemonicsVC *backup = [[BTBackupMnemonicsVC alloc]init];
    [self.navigationController pushViewController:backup animated:YES];
}
//稍后备份
- (IBAction)copyLater:(UIButton *)sender {
    if ([[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
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
