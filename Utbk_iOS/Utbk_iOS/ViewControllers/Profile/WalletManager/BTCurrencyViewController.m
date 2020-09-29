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
    [[XBRequest sharedInstance]postDataWithUrl:getCoinRelationAPI Parameter:@{@"coin":self.curreny} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            NSLog(@"打印币种 = %@",responseResult);
        }
    }];
//    [C2CNetManager selectCoinTypeForCompleteHandle:^(id resPonseObj, int code) {
//        NSLog(@"获取全部货币种类 --- %@",resPonseObj);
//        if (code){
//            if ([resPonseObj[@"code"] integerValue]==0) {
//                //获取数据成功
//                NSLog(@"--%@",resPonseObj);
//                self.datasource = [BTCurrencyModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
////                [self switchViewUI];
//            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
//            }
//        }else{
//            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
//        }
//    }];
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
