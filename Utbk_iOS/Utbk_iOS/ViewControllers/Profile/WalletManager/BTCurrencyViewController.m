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

@interface BTCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) BTCurrencyModel *currencyModel;//记录当前选中的model

@end

@implementation BTCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"钱包管理");
    [self setupLayout];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTCurrencyCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell configureCellWithModel:self.datasource[indexPath.row]];
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
