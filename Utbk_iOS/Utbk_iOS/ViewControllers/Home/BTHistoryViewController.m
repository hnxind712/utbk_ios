//
//  BTHistoryViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHistoryViewController.h"
#import "BTHistoryRecordCell.h"
#import "BTHistoryRecordModel.h"

@interface BTHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *myrecordBtn;
@property (weak, nonatomic) IBOutlet UIView *myRecordView;
@property (weak, nonatomic) IBOutlet UIButton *outputRecordsBtn;
@property (weak, nonatomic) IBOutlet UIView *outputRecordView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) UIButton *selectedBtn;

@end

@implementation BTHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"历史记录");
    [self setupLayout];
    self.selectedBtn = self.myrecordBtn;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)showRecordAction:(UIButton *)sender {
    if (sender == self.selectedBtn) return;
    sender.selected = YES;
    [sender setTitleColor:RGBOF(0xA8865A) forState:UIControlStateNormal];
    switch (sender.tag) {
        case 100:
            [self.outputRecordsBtn setTitleColor:RGBOF(0x343434) forState:UIControlStateNormal];
            self.outputRecordsBtn.selected = NO;
            self.outputRecordView.hidden = YES;
            self.myRecordView.hidden = NO;
            break;
        case 101:
            [self.myrecordBtn setTitleColor:RGBOF(0x343434) forState:UIControlStateNormal];
            self.myrecordBtn.selected = NO;
            self.myrecordBtn.hidden = YES;
            self.outputRecordView.hidden = NO;
            break;
        default:
            break;
    }
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHistoryRecordCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    self.tableView.tableFooterView = [UIView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHistoryRecordCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell configureCellWithModel:self.datasource[indexPath.row]];
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
