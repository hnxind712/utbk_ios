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
        [[XBRequest sharedInstance]postDataWithUrl:getCoinRelationAPI Parameter:@{@"coin":self.motherCoin} ResponseObject:^(NSDictionary *responseResult) {
            StrongSelf(strongSelf)
            if (NetSuccess) {
                //取字母对
                if ([responseResult[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = responseResult[@"data"];
                    NSMutableArray *array = [NSMutableArray array];
                    BTCurrencyModel *motherModel = [[BTCurrencyModel alloc]init];
                    motherModel.currency = dic[@"parentCoin"];
                    motherModel.isSelected = [dic[@"parentCoin"] isEqualToString:self.curreny];
                    [array addObject:motherModel];
                    if ([dic[@"parentCoin"] isEqualToString:self.curreny]) {
                        strongSelf.currencyModel = motherModel;
                    }
                    BTCurrencyModel *subModel = [[BTCurrencyModel alloc]init];
                    subModel.currency = dic[@"subcoin"];
                    subModel.isSelected = [dic[@"subcoin"] isEqualToString:self.curreny];
                    [array addObject:subModel];
                    if ([dic[@"subcoin"] isEqualToString:self.curreny]) {
                        strongSelf.currencyModel = subModel;
                    }
                    strongSelf.datasource = array;
                    [strongSelf.tableView reloadData];
                }
                
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
                        NSString *value = obj.value;
                        NSArray *valueList = [value componentsSeparatedByString:@","];
                        [valueList enumerateObjectsUsingBlock:^(NSString *currency, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (currency.length) {
                                BTCurrencyModel *model = [[BTCurrencyModel alloc]init];
                                model.currency = currency;
                                if ([self.curreny isEqualToString:currency]) {
                                    model.isSelected = YES;
                                    self.currencyModel = model;
                                }
                                [data addObject:model];
                            }
                        }];
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
    if (self.selectedCurrency) {
        self.selectedCurrency(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
