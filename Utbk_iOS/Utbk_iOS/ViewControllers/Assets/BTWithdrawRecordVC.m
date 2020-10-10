//
//  BTWithdrawRecordVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWithdrawRecordVC.h"
#import "BTWithdrawRecordCell.h"
#import "BTWithdrawRecordModel.h"
#import "BTMotherCoinModel.h"
#import "BTWithdrawRecordDetailVC.h"
#import "MineNetManager.h"
#import "LYEmptyView.h"
#import "BTPoolShareContributionRecordModel.h"
#import "BTAssetRecordModel.h"

@interface BTWithdrawRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) LYEmptyView *emptyView;

@end

@implementation BTWithdrawRecordVC
- (id)init{
    if (self = [super init]) {
        self.currentPage = 1;
    }
    return self;
}
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"暂无数据")];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"历史记录");
    [self setupLayout];
    [self refreshHeaderAction];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTWithdrawRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTWithdrawRecordCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)refreshHeaderAction{
    _currentPage = 1;
    if (self.recordType == KRecordTypeMotherCoinTransfer || self.recordType == KRecordTypeContributionRecord || self.recordType == KRecordTypeInvitationRecord || self.recordType == KRecordTypeMotherCoinSweep || self.recordType == KRecordTypeMotherCoinRecharge) {
        _currentPage = 0;
    }
    [self setupBind];
}
- (void)refreshFooterAction{
    _currentPage++;
    [self setupBind];
}
- (void)setupBind{
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_currentPage];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:self.unit forKey:@"symbol"];
    if (self.recordType == KRecordTypeWithdraw) {//提币
        [bodydic setValue:pageNoStr forKey:@"page"];
        [bodydic removeObjectForKey:@"pageNo"];
        [bodydic removeObjectForKey:@"symbol"];
        [self withdrawData:bodydic];
    }else{
        NSString *type;
        if (self.recordType == KRecordTypeRecharge || self.recordType < 5) {//充币、转账、资产转矿池、矿池转资产
            switch (self.recordType) {
                case KRecordTypeRecharge:
                    type = @"0";
                    break;
                case KRecordTypeTransfer://转账
                    type = @"2";
                    break;
                case KRecordTypeTransterIn://资产转矿池
                    type = @"17";
                    break;
                case KRecordTypeTransterOut://资产转矿池
                    type = @"18";
                    break;
                default:
                    break;
            }
            [bodydic setValue:type forKey:@"type"];
            [self rechargeData:bodydic];
        }else if (self.recordType >= 5 && self.recordType <= 8){
            switch (self.recordType) {
                case KRecordTypeMotherCoinRecharge://母币充值
                    type = @"1";
                    break;
                case KRecordTypeMotherCoinTransfer://母币转账
                    type = @"0";
                    break;
                case KRecordTypeMotherCoinSweep://母币划转
                    type = @"2";
                    break;
                case KRecordTypeInvitationRecord://邀请激活
                    type = @"3";
                    break;
                default:
                    break;
            }
            [bodydic setValue:type forKey:@"type"];
            [self getMotherTransferRecord:bodydic];
        }
    }
}
- (void)withdrawData:(NSDictionary *)params{
    WeakSelf(weakSelf)
    [MineNetManager withdrawrecordParam:params CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (weakSelf.currentPage == 1) {
                    [weakSelf.datasource removeAllObjects];
                }
                
                NSArray *dataArr = [BTWithdrawRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                [weakSelf.datasource addObjectsFromArray:dataArr];
                weakSelf.tableView.ly_emptyView = self.emptyView;
                [weakSelf.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [weakSelf.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [weakSelf.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
        
    }];
}
- (void)rechargeData:(NSDictionary *)params{
    WeakSelf(weakSelf)
    [MineNetManager assettransactionParam:params CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (weakSelf.currentPage == 1) {
                    [weakSelf.datasource removeAllObjects];
                }
                
                NSArray *dataArr = [BTAssetRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                [weakSelf.datasource addObjectsFromArray:dataArr];
                weakSelf.tableView.ly_emptyView = self.emptyView;
                [weakSelf.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [weakSelf.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [weakSelf.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
- (void)getMotherTransferRecord:(NSDictionary *)params{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:pageMotherCoinLogsAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            if (weakSelf.currentPage == 0) {
                [weakSelf.datasource removeAllObjects];
            }
            NSArray *dataArr = [BTMotherCoinModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"][@"content"]];
            [weakSelf.datasource addObjectsFromArray:dataArr];
            weakSelf.tableView.ly_emptyView = self.emptyView;
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)getContributionRecord:(NSDictionary *)params{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:getMineShareLogsAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if (strongSelf.currentPage == 0) {
                [strongSelf.datasource removeAllObjects];
            }
            [strongSelf.datasource addObjectsFromArray:[BTPoolShareContributionRecordModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]]];
            strongSelf.tableView.ly_emptyView = self.emptyView;
            [strongSelf.tableView reloadData];
        }else
            ErrorToast
            }];
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTWithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTWithdrawRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = self.recordType;
    if (self.recordType == KRecordTypeWithdraw) {//USDT提币记录
        BTWithdrawRecordModel *model = self.datasource[indexPath.row];
        [cell configureCellWithRecordModel:model];
        WeakSelf(weakSelf)
        cell.recordDetailAction = ^{
            StrongSelf(strongSelf)
            BTWithdrawRecordDetailVC *detail = [[BTWithdrawRecordDetailVC alloc]init];
            detail.recordModel = model;
            [strongSelf.navigationController pushViewController:detail animated:YES];
        };
    }else if (self.recordType == KRecordTypeRecharge || self.recordType == KRecordTypeTransfer || self.recordType == KRecordTypeTransterIn || self.recordType == KRecordTypeTransterOut){//资产流水相关
        BTAssetRecordModel *model = self.datasource[indexPath.row];
        [cell configureCellWithStreamRecordModel:model];
        if (self.recordType == KRecordTypeRecharge || self.recordType == KRecordTypeTransfer) {//充值以及转账可以有详情
            WeakSelf(weakSelf)
            cell.recordDetailAction = ^{
                StrongSelf(strongSelf)
                BTWithdrawRecordDetailVC *detail = [[BTWithdrawRecordDetailVC alloc]init];
                detail.assetModel = model;
                [strongSelf.navigationController pushViewController:detail animated:YES];
            };
        }
    }else if (self.recordType == KRecordTypeMotherCoinTransfer || self.recordType == KRecordTypeMotherCoinSweep || self.recordType == KRecordTypeMotherCoinRecharge || self.recordType == KRecordTypeInvitationRecord){//原始母币相关记录
        BTMotherCoinModel *model = self.datasource[indexPath.row];
        [cell configureCellWithMotherTransferRecordModel:model];
        WeakSelf(weakSelf)
        if (self.recordType != KRecordTypeMotherCoinSweep) {
            cell.recordDetailAction = ^{
                StrongSelf(strongSelf)
                BTWithdrawRecordDetailVC *detail = [[BTWithdrawRecordDetailVC alloc]init];
                detail.index = self.recordType;
                detail.model = model;
                [strongSelf.navigationController pushViewController:detail animated:YES];
            };
        }
    }else if (self.recordType == KRecordTypeContributionRecord){//弃用
        BTPoolShareContributionRecordModel *model = self.datasource[indexPath.row];
        [cell configureCellWithContributionRecordModel:model];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104.f;
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
