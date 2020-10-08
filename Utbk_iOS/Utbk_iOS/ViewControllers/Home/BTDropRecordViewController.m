//
//  BTDropRecordViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTDropRecordViewController.h"
#import "BTDropRecordTableViewCell.h"
#import "BTPoolRecordModel.h"
#import "LYEmptyView.h"

@interface BTDropRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *coinTopEarning;
@property (weak, nonatomic) IBOutlet UILabel *coinTop;
@property (weak, nonatomic) IBOutlet UILabel *coinBottom;
@property (weak, nonatomic) IBOutlet UILabel *coinBottomEarning;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger pageNo;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) LYEmptyView *emptyView;

@end

@implementation BTDropRecordViewController
- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"暂无数据")];
    }
    return _emptyView;
}
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"空投收益记录");
    [self setupLayout];
    [self setupData];
    [self refreshHeaderAction];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupData{
    self.coinTop.text = [NSString stringWithFormat:@"%@：",self.model.coinName];
    self.coinTopEarning.text = [ToolUtil formartScientificNotationWithString:self.model.profitAmount];
    self.coinBottom.text = [NSString stringWithFormat:@"%@：",self.model.subcoinCoin];
    self.coinBottomEarning.text = [ToolUtil formartScientificNotationWithString:self.model.subcoinProfitAmount];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTDropRecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTDropRecordTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
}
- (void)refreshHeaderAction{
    _pageNo = 0;
    [self setupBind];
}
- (void)refreshFooterAction{
    _pageNo++;
    [self setupBind];
}
- (void)setupBind{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiKey"] = [YLUserInfo shareUserInfo].secretKey;
    params[@"pageNo"] = @(_pageNo);
    params[@"pageSize"] = @(KPageSize);
    params[@"type"] = @(3);//收益
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:getMineLogsAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if (strongSelf.pageNo == 0) {//第一页
                [strongSelf.datasource removeAllObjects];
            }
            [strongSelf.datasource addObjectsFromArray:[BTPoolRecordModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]]];
            strongSelf.tableView.ly_emptyView = strongSelf.emptyView;
            [strongSelf.tableView reloadData];
        }else
            ErrorToast
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTDropRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTDropRecordTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%2) {
        cell.contentV.backgroundColor = [UIColor clearColor];
    }else{
        cell.contentV.backgroundColor = [UIColor whiteColor];
    }
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
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
