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
@property (weak, nonatomic) IBOutlet UILabel *earningsYes;//子币种
@property (weak, nonatomic) IBOutlet UILabel *houdCount;//持有
@property (weak, nonatomic) IBOutlet UILabel *extendCount;//推广
@property (weak, nonatomic) IBOutlet UILabel *myHoud;//我的持有
@property (weak, nonatomic) IBOutlet UILabel *areaTotal;//小区小计
@property (weak, nonatomic) IBOutlet UILabel *bestHoud;//最佳持有
@property (weak, nonatomic) IBOutlet UILabel *minHoud;//最小持有
@property (weak, nonatomic) IBOutlet UILabel *earningsDescription;//收益描述
@property (weak, nonatomic) IBOutlet UITableView *tableView;//排行榜
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (strong, nonatomic) NSArray *datasource;//排名信息

@end

@implementation BTOrePoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRightNavigation];
    [self setupLayout];
    [self addRightNavigation];
    self.title = [NSString stringWithFormat:@"%@%@",self.model.coinName,LocalizationKey(@"矿池")];
    [self setupBind];
    [self setupData];
    [self setupConfirgure];
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
- (void)setupConfirgure{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"打印一下 = %@",obj.remarks);
                if ([obj.key isEqualToString:@"mine_num"]) {//最低持币数
                    strongSelf.minHoud.text = [ToolUtil formartScientificNotationWithString:obj.value];
                }else if ([obj.key isEqualToString:@"optimum_num"]){
                    strongSelf.bestHoud.text = [ToolUtil formartScientificNotationWithString:obj.value];
                }
            }];
        }
    }];
}
- (void)setupData{
    self.currency.text = [NSString stringWithFormat:@"%@ %@",self.model.coinName,[ToolUtil stringFromNumber:self.model.profitAmount.doubleValue withlimit:KLimitAssetInputDigits]];
    self.earningsYes.text = [NSString stringWithFormat:@"%@ %@",self.model.subcoinCoin,[ToolUtil stringFromNumber:self.model.subcoinProfitAmount.doubleValue withlimit:KLimitAssetInputDigits]];
    self.houdCount.text = [ToolUtil stringFromNumber:self.model.big_airdrop_profit.doubleValue withlimit:KLimitAssetInputDigits];
    self.extendCount.text = @"0.0010";
    self.areaTotal.text = [ToolUtil stringFromNumber:self.model.smallTotalBanance.doubleValue withlimit:KLimitAssetInputDigits];
    self.myHoud.text = [ToolUtil stringFromNumber:self.model.balance.doubleValue withlimit:KLimitAssetInputDigits];
}
- (void)transferRecordAction{
    BTDropRecordViewController *drop = [[BTDropRecordViewController alloc]init];
    drop.model = self.model;
    [self.navigationController pushViewController:drop animated:YES];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:getAirdropTopAPI Parameter:@{@"size":@(10)} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            strongSelf.datasource = [BTHistoryRecordModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView layoutIfNeeded];
            strongSelf.tableHeight.constant = strongSelf.tableView.contentSize.height;
        }
    }];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHistoryRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    self.tableView.tableFooterView = [UIView new];
    [self headRefreshWithScrollerView:self.tableView];
}
#pragma mark 获取数据
- (void)refreshHeaderAction{
    [self setupBind];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:self.datasource[indexPath.row]];
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
