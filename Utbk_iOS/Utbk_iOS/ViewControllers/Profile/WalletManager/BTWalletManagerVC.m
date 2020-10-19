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
#import "YLTabBarController.h"

@interface BTWalletManagerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) YLUserInfo *currentInfo;

@end

@implementation BTWalletManagerVC

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"钱包管理");
    [self setupLayout];
//    [self addRightNavigation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupBind];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isLogin) {
//        [self backBtnNoNavBar:NO normalBack:NO];
        [self leftNavigation];//添加一个不需要的左导航
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
- (void)leftNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction1) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, StatusBarHeight, 40, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)backAction1{
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isLogin) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTWalletManagerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTWalletManagerCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_switch") forState:UIControlStateNormal];
    [btn setTitle:LocalizationKey(@"切换") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setupBind{
    [self.datasource removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    [self.datasource addObjectsFromArray:arr];
    __block NSInteger index = 0;
    for (YLUserInfo *info in self.datasource) {
        if ([info.username isEqualToString:[YLUserInfo shareUserInfo].username]) {
            self.currentInfo = info;
        }
        [[XBRequest sharedInstance]postDataWithUrl:getMemberStatusAPI Parameter:@{@"memberId":_BTS(info.ID)} ResponseObject:^(NSDictionary *responseResult) {
            index++;
            if (NetSuccess) {
                info.activeStatus = [responseResult[@"data"][@"status"] isKindOfClass:[NSNull class]] ? 0 : [responseResult[@"data"][@"status"] integerValue];
            }
            if (index == self.datasource.count) {
                    //存
                NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:self.datasource];
                [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                [self.tableView reloadData];
            }
        }];
    }
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
    YLUserInfo *model = self.datasource[indexPath.row];
    [cell configureWithModel:self.datasource[indexPath.row]];
    WeakSelf(weakSelf)
    cell.walletDetailAction = ^{
        BTWalletManageDetailVC *walletDetail = [[BTWalletManageDetailVC alloc]init];
        walletDetail.userInfo = model;
        [weakSelf.navigationController pushViewController:walletDetail animated:YES];
    };
    cell.switchAccountAction = ^{
        if (model == self.currentInfo) return;
        if (model.secretKey.length) {
            [EasyShowLodingView showLodingText:LocalizationKey(@"正在切换钱包")];
//            @"password":_BTS(model.password)
            [[XBRequest sharedInstance]postDataWithUrl:importMnemonicAPI Parameter:@{@"primaryKey":model.secretKey,@"password":@"Aa123123",@"remberWords":@""} ResponseObject:^(NSDictionary *responseResult) {
                [EasyShowLodingView hidenLoding];
                StrongSelf(strongSelf)
                if (NetSuccess) {
                    YLUserInfo *info = [YLUserInfo getuserInfoWithDic:responseResult[@"data"]];
                    info.secretKey = model.secretKey;
                    info.address = model.address;
                    [strongSelf.datasource replaceObjectAtIndex:indexPath.row withObject:info];//已经进行了替换
                    strongSelf.currentInfo = info;
                    [YLUserInfo saveUser:self.currentInfo];
                    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:strongSelf.datasource];
                    [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (![[AppDelegate sharedAppDelegate].window.rootViewController isKindOfClass:[YLTabBarController class]]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:KfirstLogin object:nil];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            YLTabBarController *tabbar = (YLTabBarController *)[AppDelegate sharedAppDelegate].window.rootViewController;
                            tabbar.selectedIndex = 0;
                            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                        });
                    }
                }else
                    ErrorToast
                    }];
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLUserInfo *model = self.datasource[indexPath.row];
    BTWalletManageDetailVC *walletDetail = [[BTWalletManageDetailVC alloc]init];
    walletDetail.userInfo = model;
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
