//
//  BTProfileViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTProfileViewController.h"
#import "BTWalletManagerVC.h"//钱包管理列表
#import "BTTeamAchievementVC.h"//团队业绩

//测试
#import "BTBackupMnemonicsVC.h"

@interface BTProfileViewController ()

@property (strong, nonatomic) UIImageView *navgationBg;

@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:BTUIIMAGE(@"icon_profileTopbg") forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];;
}
#pragma mark actions
//头像点击事件
- (IBAction)userHeadClickAction:(UIButton *)sender {
}
//钱包管理
- (IBAction)walletManagerAction:(UITapGestureRecognizer *)sender {
    BTWalletManagerVC *wallet = [[BTWalletManagerVC alloc]init];
    wallet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wallet animated:YES];
}
//团队业绩
- (IBAction)teamAchievementAction:(UITapGestureRecognizer *)sender {
    BTTeamAchievementVC *team = [[BTTeamAchievementVC alloc]init];
    team.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:team animated:YES];
}
//社区客服
- (IBAction)communityServiceAction:(UITapGestureRecognizer *)sender {
    BTBackupMnemonicsVC *mnemonics = [[BTBackupMnemonicsVC alloc]init];
    mnemonics.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mnemonics animated:YES];
}
//开源地址
- (IBAction)openSourceAddressAction:(UITapGestureRecognizer *)sender {
}
//提币地址
- (IBAction)withdrawAddressAction:(UITapGestureRecognizer *)sender {
}
//分享APP
- (IBAction)shareAppAction:(UITapGestureRecognizer *)sender {
}
//帮助中心
- (IBAction)helpCenterAction:(UITapGestureRecognizer *)sender {
}
//区块链浏览
- (IBAction)blockChainsAction:(UITapGestureRecognizer *)sender {
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
