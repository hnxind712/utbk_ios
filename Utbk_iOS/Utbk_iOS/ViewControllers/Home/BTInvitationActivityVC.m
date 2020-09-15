//
//  BTInvitationActivityVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTInvitationActivityVC.h"

@interface BTInvitationActivityVC ()

@property (weak, nonatomic) IBOutlet UITextField *coinAddress;
@property (weak, nonatomic) IBOutlet UILabel *feeTipsLabel;

@end

@implementation BTInvitationActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"邀请激活");
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecord") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)transferRecordAction{
    
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
}
//确认
- (IBAction)comfirmAction:(UIButton *)sender {
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
