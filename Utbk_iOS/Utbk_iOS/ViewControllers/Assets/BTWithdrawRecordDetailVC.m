//
//  BTWithdrawRecordDetailVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTWithdrawRecordDetailVC.h"

@interface BTWithdrawRecordDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *withdrawCount;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation BTWithdrawRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"历史记录");
    // Do any additional setup after loading the view from its nib.
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
