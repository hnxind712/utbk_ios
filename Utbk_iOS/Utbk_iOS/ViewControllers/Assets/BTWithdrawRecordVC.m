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

@interface BTWithdrawRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation BTWithdrawRecordVC
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"历史记录");
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTWithdrawRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTWithdrawRecordCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (void)loadData{
    _currentPage = 1;
    [self setupBind];
}
- (void)loadMoreData{
    _currentPage++;
    [self setupBind];
}
- (void)setupBind{
    
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTWithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTWithdrawRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    BTWithdrawRecordModel *model;
//    [cell configureCellWithRecordModel:model];
    WeakSelf(weakSelf)
    cell.recordDetailAction = ^{
        StrongSelf(strongSelf)
        BTWithdrawRecordDetailVC *detail = [[BTWithdrawRecordDetailVC alloc]init];
//        detail.recordModel = model;
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
