//
//  BTTeamHoldViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTTeamHoldViewController.h"
#import "BTTeamHoldTableViewCell.h"
#import "BTTeamHoldModel.h"
#import "BTCurrencyViewController.h"

@interface BTTeamHoldViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *myHold;
@property (weak, nonatomic) IBOutlet UILabel *totalAddressCount;
@property (weak, nonatomic) IBOutlet UILabel *totalDeviceCount;
@property (weak, nonatomic) IBOutlet UILabel *teamHold;
@property (weak, nonatomic) IBOutlet UILabel *regionHold;//大区总持
@property (weak, nonatomic) IBOutlet UILabel *communityHold;//小区总持
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) LYEmptyView *emptyView;
@property (copy, nonatomic) NSString *memberId;//区分列表大小区

@end

@implementation BTTeamHoldViewController
- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noDada")];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"团队持仓");
    [self addRightNavigation];
    [self setupLayout];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTTeamHoldTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTTeamHoldTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    [self headRefreshWithScrollerView:self.tableView];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_down") forState:UIControlStateNormal];
    [btn setTitle:@"BTCK" forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(teamHoldAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
#pragma mark 获取数据
- (void)refreshHeaderAction{
    [self setupBind];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:getTeamInfoAllAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            strongSelf.myHold.text = [NSString stringWithFormat:@"%.4f",[responseResult[@"data"][@"myBTCK"]doubleValue]];
            strongSelf.totalAddressCount.text = [NSString stringWithFormat:@"%@",responseResult[@"data"][@"allAddress"] ? responseResult[@"data"][@"allAddress"] : @"0"];
            strongSelf.totalDeviceCount.text = [NSString stringWithFormat:@"%@",responseResult[@"data"][@"allDevices"] ? responseResult[@"data"][@"allDevices"] : @"0"];
            strongSelf.teamHold.text = [NSString stringWithFormat:@"%.4f",responseResult[@"data"][@"allChicang"] ? [responseResult[@"data"][@"allChicang"] doubleValue] : 0];
            strongSelf.regionHold.text = [NSString stringWithFormat:@"%.4f",responseResult[@"data"][@"daChicang"] ?[responseResult[@"data"][@"daChicang"]doubleValue] : 0];
            strongSelf.communityHold.text = [NSString stringWithFormat:@"%.4f",responseResult[@"data"][@"xiaoquChicang"] ? [responseResult[@"data"][@"xiaoquChicang"]doubleValue] : 0];
            strongSelf.memberId = responseResult[@"data"][@"daMemberId"];
        }
    }];
    [[XBRequest sharedInstance]postDataWithUrl:getTeamMembersAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            NSArray *datasource = [BTTeamHoldModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            strongSelf.tableView.ly_emptyView = strongSelf.emptyView;
            NSMutableArray *data = [NSMutableArray arrayWithArray:datasource];
            [datasource enumerateObjectsUsingBlock:^(BTTeamHoldModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[NSString stringWithFormat:@"%d",obj.memberId] isEqualToString:[NSString stringWithFormat:@"%@",self.memberId]]) {
                    [data removeObject:obj];
                    [data insertObject:obj atIndex:0];
                }
            }];
            strongSelf.datasource = data;
            [strongSelf.tableView reloadData];
        }else
            ErrorToast
    }];
}
- (void)teamHoldAction{
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    currency.index = 1;
    [self.navigationController pushViewController:currency animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTTeamHoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTTeamHoldTableViewCell class])];
    BTTeamHoldModel *model = self.datasource[indexPath.row];
    if ([[NSString stringWithFormat:@"%d",model.memberId] isEqualToString:[NSString stringWithFormat:@"%@",self.memberId]]) {
        cell.addressTitle.text = LocalizationKey(@"地址(大区)");
    }else{
        cell.addressTitle.text = LocalizationKey(@"地址(小区)");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145.f;
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
