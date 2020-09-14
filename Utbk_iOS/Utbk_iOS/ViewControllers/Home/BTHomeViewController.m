//
//  BTHomeViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeViewController.h"

@interface BTHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bannerSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *coinCount;//原始母币
@property (weak, nonatomic) IBOutlet UILabel *convertCount;//折合(USDT)
@property (strong, nonatomic) NSArray *datasource;

@end

@implementation BTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = RGBOF(0xE8E8E8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
}
#pragma mark buttonAction
- (IBAction)buttonClickAction:(UIButton *)sender {
}
#pragma mark 主板区/涨幅榜点击事件
- (IBAction)typeButtonClickAction:(UIButton *)sender {
}
#pragma mark tableDelegate  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"ccc"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
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
