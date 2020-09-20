//
//  BTSharePoolVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSharePoolVC.h"
#import "BTSharePoolTableViewCell.h"

@interface BTSharePoolVC ()<UITableViewDelegate,UITableViewDataSource>
//右侧半圆角的view
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UILabel *coin;
@property (weak, nonatomic) IBOutlet UILabel *yesearnings;
@property (weak, nonatomic) IBOutlet UILabel *coinUSDT;//USDT
@property (weak, nonatomic) IBOutlet UILabel *totalOutput;
@property (weak, nonatomic) IBOutlet UILabel *contribution;
@property (weak, nonatomic) IBOutlet UILabel *sectionCount;
@property (weak, nonatomic) IBOutlet UIButton *contributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *earningsBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *selecedBtn;//暂定
@property (weak, nonatomic) IBOutlet UIView *contributionView;
@property (weak, nonatomic) IBOutlet UIView *earningView;

@end

@implementation BTSharePoolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selecedBtn = self.contributionBtn;
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTSharePoolTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (IBAction)recordAction:(UIButton *)sender {
    if (self.selecedBtn == sender) return;
    sender.selected = YES;
    self.selecedBtn = sender;
    switch (sender.tag) {
        case 100:
            self.earningsBtn.selected = NO;
            self.earningView.hidden = YES;
            self.contributionView.hidden = NO;
            break;
        case 101:
            self.contributionBtn.selected = NO;
            self.earningView.hidden = NO;
            self.contributionView.hidden = YES;
            break;
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTSharePoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
//    [cell configureCellWithModel:nil];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
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
