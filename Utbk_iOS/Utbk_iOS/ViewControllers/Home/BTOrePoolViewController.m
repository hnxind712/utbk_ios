//
//  BTOrePoolViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTOrePoolViewController.h"
#import "BTHistoryRecordCell.h"
#import "BTHistoryRecordModel.h"//排行榜
#import "BTDropRecordViewController.h"

@interface BTOrePoolViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *currency;//币种
@property (weak, nonatomic) IBOutlet UILabel *earningsYes;//昨日收益
@property (weak, nonatomic) IBOutlet UILabel *earningYesConvert;//昨日收益折合
@property (weak, nonatomic) IBOutlet UILabel *earningTotal;//累计收益
@property (weak, nonatomic) IBOutlet UILabel *earningTotalConvert;//累计收益h折合
@property (weak, nonatomic) IBOutlet UILabel *houdCount;//持有
@property (weak, nonatomic) IBOutlet UILabel *houdCountConvert;//持有折合
@property (weak, nonatomic) IBOutlet UILabel *extendCount;//推广
@property (weak, nonatomic) IBOutlet UILabel *extendCountConvert;//推广折合
@property (weak, nonatomic) IBOutlet UILabel *myHoud;//我的持有
@property (weak, nonatomic) IBOutlet UILabel *areaTotal;//小区小计
@property (weak, nonatomic) IBOutlet UILabel *bestHoud;//最佳持有
@property (weak, nonatomic) IBOutlet UILabel *minHoud;//最小持有
@property (weak, nonatomic) IBOutlet UILabel *earningsDescription;//收益描述
@property (weak, nonatomic) IBOutlet UITableView *tableView;//排行榜

@end

@implementation BTOrePoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRightNavigation];
    [self setupLayout];
    [self addRightNavigation];
    self.title = LocalizationKey(@"BTKu矿池");
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecordR") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)transferRecordAction{
    BTDropRecordViewController *drop = [[BTDropRecordViewController alloc]init];
    [self.navigationController pushViewController:drop animated:YES];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHistoryRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
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
