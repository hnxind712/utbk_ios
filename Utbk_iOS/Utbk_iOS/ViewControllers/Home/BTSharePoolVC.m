//
//  BTSharePoolVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSharePoolVC.h"
#import "BTSharePoolCell.h"
#import "BTSharePoolModel.h"//矿池共享记录
#import "LYEmptyView.h"
#import "BTContributionRecordVC.h"

@interface BTSharePoolVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) NSArray *starAarry;//拿到星级的数据
@property (strong, nonatomic) LYEmptyView *emptyView;

@end

@implementation BTSharePoolVC
- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"暂无数据")];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self setupBind];
    [self refreshHeaderAction];
   
    // Do any additional setup after loading the view from its nib.
}


- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTSharePoolCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTSharePoolCell class])];
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
        }
    }];
    
}
#pragma mark 获取数据
- (void)refreshHeaderAction{
    [self loadData];
}

- (void)loadData{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:getMineShareAPI Parameter:@{@"apiKey":_BTS([YLUserInfo shareUserInfo].secretKey)} ResponseObject:^(NSDictionary *responseResult) {
            StrongSelf(strongSelf)
            if (NetSuccess) {
                self.datasource = [BTSharePoolModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.tableView.ly_emptyView = strongSelf.emptyView;
                    [strongSelf.tableView reloadData];

                });
            }
        }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTSharePoolCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTSharePoolCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTContributionRecordVC *contribution = [[BTContributionRecordVC alloc]init];
    contribution.model = self.datasource[indexPath.row];
    [self.navigationController pushViewController:contribution animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.f;
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
