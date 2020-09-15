//
//  BTAssetsViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsViewController.h"
#import "BTAssetsCell.h"
#import "BTAssetsRechargeVC.h"
#import "BTSweepAccountVC.h"
#import "BTAssetsWithdrawVC.h"
#import "BTAssetsTransiferVC.h"

//测试用
#import "BTAssetsWithdrawVC.h"

@interface BTAssetsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalAccount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;

@end

@implementation BTAssetsViewController
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"资产";
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTAssetsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTAssetsCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTAssetsCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithAssetsModel:nil];
    cell.cellBtnClickAction = ^(NSInteger index) {
        switch (index) {
            case 0://收款/充币,USDT则为充币，其他币种为收款
            {
                BTAssetsWithdrawVC *withdraw = [[BTAssetsWithdrawVC alloc]init];
                [self.navigationController pushViewController:withdraw animated:YES];return;
                BTAssetsRechargeVC *recharge = [[BTAssetsRechargeVC alloc]init];
                recharge.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:recharge animated:YES];
            }
                break;
            case 1://转账
            {
                BTAssetsTransiferVC *transfer = [[BTAssetsTransiferVC alloc]init];
                transfer.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:transfer animated:YES];
            }
                break;
            case 2://划转
            {
                BTSweepAccountVC *sweep = [[BTSweepAccountVC alloc]init];
                sweep.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sweep animated:YES];
            }
                break;
            default:
                break;
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146.f;
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
