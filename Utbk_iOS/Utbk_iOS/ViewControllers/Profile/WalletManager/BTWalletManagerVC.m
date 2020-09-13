//
//  BTWalletManagerVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWalletManagerVC.h"
#import "BTWalletManagerCell.h"
#import "BTCreateWalletVC.h"
#import "BTImportWalletVC.h"
#import "BTWalletManageDetailVC.h"
@interface BTWalletManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;

@end

@implementation BTWalletManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"钱包管理");
    [self setupLayout];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTWalletManagerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTWalletManagerCell class])];
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    //self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTWalletManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTWalletManagerCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTWalletManageDetailVC *walletDetail = [[BTWalletManageDetailVC alloc]init];
    [self.navigationController pushViewController:walletDetail animated:YES];
}
#pragma mark actions
- (IBAction)createAccountAction:(UIButton *)sender {
    BTCreateWalletVC *create = [[BTCreateWalletVC alloc]init];
    [self.navigationController pushViewController:create animated:YES];
}
- (IBAction)importAddressAction:(UIButton *)sender {
    BTImportWalletVC *create = [[BTImportWalletVC alloc]init];
    [self.navigationController pushViewController:create animated:YES];
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
