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
#import "BTWithdrawRecordDetailVC.h"
#import "MineNetManager.h"
#import "LYEmptyView.h"

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
    [self setupBind];
}
- (void)refreshFooterAction{
    _currentPage++;
    [self setupBind];
}
- (void)setupBind{
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_currentPage];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"page"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    if (self.recordType == KRecordTypeRecharge) {
        [bodydic setValue:@"0" forKey:@"type"];
        [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
        [self rechargeData:bodydic];
    }else{
        [self withdrawData:bodydic];
    }

}
- (void)withdrawData:(NSDictionary *)params{
    WeakSelf(weakSelf)
    [MineNetManager withdrawrecordParam:params CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (weakSelf.currentPage == 0) {
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
                if (weakSelf.currentPage == 0) {
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
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTWithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTWithdrawRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BTWithdrawRecordModel *model = self.datasource[indexPath.row];
    [cell configureCellWithRecordModel:model];
    WeakSelf(weakSelf)
    cell.recordDetailAction = ^{
        StrongSelf(strongSelf)
        BTWithdrawRecordDetailVC *detail = [[BTWithdrawRecordDetailVC alloc]init];
        detail.recordModel = model;
        [strongSelf.navigationController pushViewController:detail animated:YES];
    };
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
