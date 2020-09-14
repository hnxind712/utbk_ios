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

@interface BTRegisterViewController ()

@end

@implementation BTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createAccount:(UIButton *)sender {
    BTCreateWalletVC *create = [[BTCreateWalletVC alloc]init];
    [self.navigationController pushViewController:create animated:YES];
}
- (IBAction)inpotAddress:(UIButton *)sender {
    BTImportWalletVC *import = [[BTImportWalletVC alloc]init];
    [self.navigationController pushViewController:import animated:YES];
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
