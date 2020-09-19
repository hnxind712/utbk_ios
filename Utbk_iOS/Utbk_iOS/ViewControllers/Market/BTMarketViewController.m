//
//  BTMarketViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTMarketViewController.h"
#import "BTMarketTableViewCell.h"

#define KTableViewTop 46.f

@interface BTMarketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BTMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"行情");
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTMarketTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTMarketTableViewCell class])];
    self.tableView.tableFooterView = [UITableView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTMarketTableViewCell class])];
    [cell configureCellWithModel:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
