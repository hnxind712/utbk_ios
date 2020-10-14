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
#import "MineNetManager.h"

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
    [self setupBind];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHomeNoticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHomeNoticeCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = RGBOF(0xe8e8e8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    [self footRefreshWithScrollerView:self.tableView];
}
- (void)refreshHeaderAction{
    [self setupBind];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noDada")];
            self.tableView.ly_emptyView = emptyView;
            if ([resPonseObj[@"code"] integerValue] == 0) {
                StrongSelf(strongSelf)
                [strongSelf.datasource removeAllObjects];
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSArray *dataArr = [BTNoticeModel mj_objectArrayWithKeyValuesArray:arr];
                [strongSelf.datasource addObjectsFromArray:dataArr];
                //                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
                //                for (NSDictionary *dic in arr) {
                //                    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                //                        if (![self hasChinese:dic[@"title"]]) {
                //                            [muArr addObject:dic];
                //                        }
                //                    }else{
                //                        if ([self hasChinese:dic[@"title"]]) {
                //                            [muArr addObject:dic];
                //                        }
                //                    }
                //                }
                //                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
                //                [self.platformMessageArr addObjectsFromArray:dataArr];
                [strongSelf.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
#pragma mark tableViewDelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHomeNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHomeNoticeCell class])];
    [cell configureCellWithNoticeModel:self.datasource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTNoticeDetailVC *detail = [[BTNoticeDetailVC alloc]init];
    detail.noticeModel = self.datasource[indexPath.row];
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
