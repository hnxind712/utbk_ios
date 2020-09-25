//
//  BTHoldCoinsViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHoldCoinsViewController.h"
#import "BTOrePoolViewController.h"
#import "BTHoldCoinsTableViewCell.h"
#import "BTPoolHoldCoinModel.h"

@interface BTHoldCoinsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;

@end

@implementation BTHoldCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHoldCoinsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHoldCoinsTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMineWalletAPI Parameter:@{@"apiKey":KTempSecretKey} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            strongSelf.datasource = [BTPoolHoldCoinModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            [strongSelf.tableView reloadData];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHoldCoinsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHoldCoinsTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTOrePoolViewController *pool = [[BTOrePoolViewController alloc]init];
    [self.navigationController pushViewController:pool animated:YES];
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
