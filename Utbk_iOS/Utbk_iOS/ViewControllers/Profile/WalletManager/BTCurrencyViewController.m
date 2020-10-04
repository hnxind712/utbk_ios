//
//  BTCurrencyViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCurrencyViewController.h"
#import "BTCurrencyCell.h"
#import "BTCurrencyModel.h"
#import "C2CNetManager.h"

@interface BTCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) BTCurrencyModel *currencyModel;//记录当前选中的model

@end

@implementation BTCurrencyViewController
- (id)init{
    if (self = [super init]) {
        self.curreny = KOriginalCoin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"选择币种");
    [self setupLayout];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)backAction{
    if (self.selectedCurrency) {
        self.selectedCurrency(self.currencyModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTCurrencyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTCurrencyCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    if (self.index == 0) {//贡献值
        [[XBRequest sharedInstance]postDataWithUrl:getCoinRelationAPI Parameter:@{@"coin":self.curreny} ResponseObject:^(NSDictionary *responseResult) {
            StrongSelf(strongSelf)
            if (NetSuccess) {
                strongSelf.datasource = [BTCurrencyModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                [strongSelf.datasource enumerateObjectsUsingBlock:^(BTCurrencyModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([self.curreny isEqualToString:obj.currency]) {
                        obj.isSelected = YES;
                        self.currencyModel = obj;
                    }
                }];
                [strongSelf.tableView reloadData];
            }
        }];
    }else if(self.index == 1){//团队持仓
        [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
            StrongSelf(strongSelf)
            if (NetSuccess) {
                NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                NSMutableArray *data = [NSMutableArray array];
                [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.key isEqualToString:@"mine_coin"]) {//链类型对应的key
                        BTCurrencyModel *model = [[BTCurrencyModel alloc]init];
                        model.currency = obj.value;
                        if ([self.curreny isEqualToString:obj.value]) {
                            model.isSelected = YES;
                            self.currencyModel = model;
                        }
                        [data addObject:model];
                    }
                }];
                strongSelf.datasource = data;
                [strongSelf.tableView reloadData];
            }
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTCurrencyCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTCurrencyModel *model = self.datasource[indexPath.row];
    if (model == self.currencyModel) return;
    self.currencyModel.isSelected = NO;
    model.isSelected = YES;
    self.currencyModel = model;
    [tableView reloadData];
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
