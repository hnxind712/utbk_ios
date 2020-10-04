//
//  BTRegisterViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTRegisterViewController.h"
#import "BTCreateWalletVC.h"
#import "BTImportWalletVC.h"
#import "MineNetManager.h"
#import "LSAppBrowserViewController.h"

@interface BTRegisterViewController ()

@property (copy, nonatomic) NSString *contentstr;

@end

@implementation BTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    [MineNetManager Userprotocol:@{@"id":@"17"} CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.contentstr = resPonseObj[@"data"][@"content"];
            }
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (IBAction)createAccount:(UIButton *)sender {
    BTCreateWalletVC *create = [[BTCreateWalletVC alloc]init];
    [self.navigationController pushViewController:create animated:YES];
}
- (IBAction)inpotAddress:(UIButton *)sender {
    BTImportWalletVC *import = [[BTImportWalletVC alloc]init];
    [self.navigationController pushViewController:import animated:YES];
}
- (IBAction)checkUserProtocol:(UIButton *)sender {
    LSAppBrowserViewController *browser = [[LSAppBrowserViewController alloc]init];
    browser.urlString = self.contentstr;
    [self.navigationController pushViewController:browser animated:YES];
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
