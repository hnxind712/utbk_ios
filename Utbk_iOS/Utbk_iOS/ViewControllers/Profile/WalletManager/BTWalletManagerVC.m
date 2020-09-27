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
#import "BTCurrencyViewController.h"
#import "BTCurrencyModel.h"

@interface BTWalletManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) YLUserInfo *currentInfo;

@end

@implementation BTWalletManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"钱包管理");
    [self setupLayout];
    [self addRightNavigation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupBind];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTWalletManagerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTWalletManagerCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_switch") forState:UIControlStateNormal];
    [btn setTitle:@"切换" forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setupBind{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
    self.datasource = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    [self.tableView reloadData];
}
- (void)transferAction{
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    currency.selectedCurrency = ^(BTCurrencyModel *model) {
        
    };
    [self.navigationController pushViewController:currency animated:YES];
}
#pragma mark tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTWalletManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTWalletManagerCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithModel:self.datasource[indexPath.row]];
    WeakSelf(weakSelf)
    cell.walletDetailAction = ^{
        BTWalletManageDetailVC *walletDetail = [[BTWalletManageDetailVC alloc]init];
        [weakSelf.navigationController pushViewController:walletDetail animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLUserInfo *model = self.datasource[indexPath.row];
    if (model == self.currentInfo) return;
    self.currentInfo = model;
    [YLUserInfo saveUser:self.currentInfo];
    [tableView reloadData];
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
