//
//  BTHomeNoticeVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeNoticeVC.h"
#import "BTNoticeModel.h"
#import "BTHomeNoticeCell.h"
#import "BTNoticeDetailVC.h"

@interface BTHomeNoticeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;

@end

@implementation BTHomeNoticeVC
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"通知公告");
    [self setupLayout];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHomeNoticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHomeNoticeCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = RGBOF(0xe8e8e8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (void)loadData{
    
}
- (void)loadMoreData{
    
}
#pragma mark tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHomeNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHomeNoticeCell class])];
//    [cell configureCellWithNoticeModel:self.datasource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTNoticeDetailVC *detail = [[BTNoticeDetailVC alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
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
