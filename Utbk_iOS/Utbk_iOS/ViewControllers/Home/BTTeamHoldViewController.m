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
@property (strong, nonatomic) UITableView *datasource;

@end

@implementation BTTeamHoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"团队持仓");
    [self addRightNavigation];
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTTeamHoldTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTTeamHoldTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
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
- (void)teamHoldAction{
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    [self.navigationController pushViewController:currency animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTTeamHoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTTeamHoldTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
