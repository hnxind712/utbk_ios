//
//  BTAssetsTransiferVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsTransiferVC.h"

@interface BTAssetsTransiferVC ()
@property (weak, nonatomic) IBOutlet UIButton *selectCoinTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *coinAddress;
@property (weak, nonatomic) IBOutlet UITextField *coinCountInput;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordInput;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@end

@implementation BTAssetsTransiferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"转币");
    // Do any additional setup after loading the view from its nib.
}
//选择币种
- (IBAction)selectCoinAction:(UIButton *)sender {
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
}
//全部输入
- (IBAction)inputAllCoinAccountAction:(UIButton *)sender {
}
//显示密码
- (IBAction)showTradePasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _tradePasswordInput.secureTextEntry = sender.selected;
}
- (IBAction)confirmAction:(UIButton *)sender {
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
