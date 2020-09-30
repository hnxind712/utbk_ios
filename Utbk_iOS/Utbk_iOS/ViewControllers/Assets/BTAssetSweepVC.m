//
//  BTAssetSweepVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/29.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetSweepVC.h"
#import "TradeNetManager.h"

@interface BTAssetSweepVC ()

@property (weak, nonatomic) IBOutlet UILabel *coinsCoins;//币币
@property (weak, nonatomic) IBOutlet UILabel *orePool;//矿池
@property (weak, nonatomic) IBOutlet UILabel *unit;//划转的币种名
@property (weak, nonatomic) IBOutlet UITextField *transferCount;//划转数量
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@end

@implementation BTAssetSweepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"划转");
    [self setupBind];
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecordR") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)transferRecordAction{

}
- (void)setupBind{
    self.balance.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:self.assets.balance],self.assets.coin.unit];
    self.unit.text = self.assets.coin.unit;
    self.switchBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);//旋转
}
- (void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 1) {
        self.coinsCoins.text = LocalizationKey(@"币币");
        self.orePool.text = LocalizationKey(@"矿池");
        [self getSingleCoinWallet];
    }else{
        self.coinsCoins.text = LocalizationKey(@"矿池");
        self.orePool.text = LocalizationKey(@"币币");
    }
}
- (void)getSingleCoinWallet{
    [TradeNetManager getwallettWithcoin:self.assets.coin.unit CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary*dict=resPonseObj[@"data"];
//                self.Useable.text=[NSString stringWithFormat:@"%@%@ %@",LocalizationKey(@"usabelSell"),[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_baseCoinScale],coin];
//                self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"balance"] doubleValue] withlimit:_coinScale],coin];
            }
            else if ([resPonseObj[@"code"] integerValue] ==4000){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
- (IBAction)allAction:(UIButton *)sender {
    if (self.assets.balance.doubleValue > 0) {
        self.transferCount.text = [ToolUtil formartScientificNotationWithString:self.assets.balance];
    }
}
- (IBAction)exchangeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.index = 2;
    }else{
        self.index = 1;
    }
}
- (IBAction)comfirmAction:(UIButton *)sender {
    if (!self.transferCount.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入划转数量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (self.transferCount.text.doubleValue > self.assets.balance.doubleValue) {
        [self.view makeToast:LocalizationKey(@"划转数量不能大于余额") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(self.index);
    params[@"apiKey"] = [YLUserInfo shareUserInfo].secretKey;
    params[@"amount"] = self.transferCount.text;
    params[@"coinName"] = self.assets.coin.unit;
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:transferWalletAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            [strongSelf.view makeToast:responseResult[@"message"] duration:ToastHideDelay position:ToastPosition];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else
            ErrorToast
    }];
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
