//
//  BTDropRecordViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTDropRecordViewController.h"
#import "BTDropRecordTableViewCell.h"

@interface BTDropRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *coinTopEarning;
@property (weak, nonatomic) IBOutlet UILabel *coinTop;
@property (weak, nonatomic) IBOutlet UILabel *coinBottom;
@property (weak, nonatomic) IBOutlet UILabel *coinBottomEarning;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BTDropRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"空投收益记录");
    [self setupLayout];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTDropRecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTDropRecordTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTDropRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTDropRecordTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%2) {
        cell.contentV.backgroundColor = [UIColor clearColor];
    }else{
        cell.contentV.backgroundColor = [UIColor whiteColor];
    }
    return cell;
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
