//
//  BTSharePoolVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSharePoolVC.h"
#import "BTSharePoolTableViewCell.h"
#import "BTPoolShareContributionRecordModel.h"//矿池共享记录

@interface BTSharePoolVC ()<UITableViewDelegate,UITableViewDataSource>
//右侧半圆角的view
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UILabel *coin;
@property (weak, nonatomic) IBOutlet UILabel *yesearnings;
@property (weak, nonatomic) IBOutlet UILabel *coinUSDT;//USDT
@property (weak, nonatomic) IBOutlet UILabel *totalOutput;
@property (weak, nonatomic) IBOutlet UILabel *contribution;
@property (weak, nonatomic) IBOutlet UILabel *sectionCount;
@property (weak, nonatomic) IBOutlet UIButton *contributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *earningsBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *selecedBtn;//暂定
@property (weak, nonatomic) IBOutlet UIView *contributionView;
@property (weak, nonatomic) IBOutlet UIView *earningView;
@property (assign, nonatomic) NSInteger currentPage;//当前页码
@property (assign, nonatomic) NSInteger type;//1 转入记录 2收益记录 0 为全部
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSArray *starAarry;//拿到星级的数据
@property (assign, nonatomic) NSInteger groupsQty;//组数,对应的去拿配置的星级进行显示

@end

@implementation BTSharePoolVC
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (id)init{
    if (self = [super init]) {
        self.currentPage = 0;
        self.type = 1;//默认进来为转入记录
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selecedBtn = self.contributionBtn;
    [self setupLayout];
    [self setupBind];
    [self refreshHeaderAction];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTSharePoolTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            NSMutableArray *data = [NSMutableArray array];
            [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.key isEqualToString:@"level_1_contribution"]) {//链类型对应的key
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }else if ([obj.key isEqualToString:@"level_2_contribution"]){
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }else if ([obj.key isEqualToString:@"level_3_contribution"]){
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }
            }];
            strongSelf.starAarry = data;//保存一下，需要计算用
            [data enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                double value = obj.doubleValue;
                if (strongSelf.groupsQty * 100 < value) {
                    [strongSelf.rightBtn setTitle:[NSString stringWithFormat:@"%ld",idx + 1] forState:UIControlStateNormal];*stop = YES;
                }
            }];
        }
    }];
    [[XBRequest sharedInstance]postDataWithUrl:getMineShareAPI Parameter:@{@"apiKey":KTempSecretKey} ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSDictionary *dic = [responseResult[@"data"]firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.yesearnings.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",dic[@"yesterdayProduce"]]];//昨日收益
                strongSelf.totalOutput.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",dic[@"totalProduce"]]];//累计产出
                if (strongSelf.starAarry.count) {//说明先请求到配置数据
                    [strongSelf.starAarry enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        double value = obj.doubleValue;
                        if (strongSelf.groupsQty * 100 < value) {
                            [strongSelf.rightBtn setTitle:[NSString stringWithFormat:@"%ld",idx + 1] forState:UIControlStateNormal];*stop = YES;
                        }
                    }];
                }
                strongSelf.contribution.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",dic[@"contributionValue"]]];//贡献值
                strongSelf.sectionCount.text = [NSString stringWithFormat:@"%@",dic[@"groupsQty"]];//组数
            });
        }
    }];
}
#pragma mark 获取数据
- (void)refreshHeaderAction{
    self.currentPage = 0;
    [self loadData];
}
- (void)refreshFooterAction{
    self.currentPage++;
    [self loadData];
}
- (void)loadData{
    WeakSelf(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiKey"] = KTempSecretKey;
    params[@"pageNo"] = @(self.currentPage);
    params[@"pageSize"] = @(KPageSize);
    params[@"type"] = @(self.type);
    [[XBRequest sharedInstance]postDataWithUrl:getMineShareLogsAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if (strongSelf.currentPage == 0) {
                [strongSelf.datasource removeAllObjects];
            }
            [strongSelf.datasource addObjectsFromArray:[BTPoolShareContributionRecordModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]]];
            [strongSelf.tableView reloadData];
            if (strongSelf.datasource.count == 0) {//添加无数据页面
                
            }
        }else
            ErrorToast
    }];
}
- (IBAction)recordAction:(UIButton *)sender {
    if (self.selecedBtn == sender) return;
    sender.selected = YES;
    self.selecedBtn = sender;
    switch (sender.tag) {
        case 100:
            self.earningsBtn.selected = NO;
            self.earningView.hidden = YES;
            self.contributionView.hidden = NO;
            self.type = 1;
            break;
        case 101:
            self.contributionBtn.selected = NO;
            self.earningView.hidden = NO;
            self.contributionView.hidden = YES;
            self.type = 2;
            break;
        default:
            break;
    }
    self.currentPage = 0;
    [self refreshHeaderAction];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTSharePoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = self.type;
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
