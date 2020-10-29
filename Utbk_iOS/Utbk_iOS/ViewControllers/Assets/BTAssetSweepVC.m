//
//  BTAssetSweepVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/29.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetSweepVC.h"
#import "TradeNetManager.h"
#import "BTPoolHoldCoinModel.h"
#import "BTWithdrawRecordVC.h"

@interface BTAssetSweepVC ()

@property (weak, nonatomic) IBOutlet UILabel *coinsCoins;//币币
@property (weak, nonatomic) IBOutlet UILabel *orePool;//矿池
@property (weak, nonatomic) IBOutlet UILabel *unit;//划转的币种名
@property (weak, nonatomic) IBOutlet UITextField *transferCount;//划转数量
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (strong, nonatomic) NSMutableArray *datasource;//矿池的数据

@end

@implementation BTAssetSweepVC
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"划转");
//    [self setupBind];
    [self getOreAssets];
    [self getSingleCoinWallet];
    [self addRightNavigation];
    self.switchBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);//旋转
    self.transferCount.keyboardType = UIKeyboardTypeDecimalPad;
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
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    withdrawRecord.recordType = self.assetIndex == 2 ? KRecordTypeTransterOut : KRecordTypeTransterIn;
    withdrawRecord.unit = self.assets.coin.unit;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (void)getOreAssets{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMineWalletAPI Parameter:@{@"apiKey":_BTS([YLUserInfo shareUserInfo].secretKey)} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            [strongSelf.datasource removeAllObjects];
            NSArray *list = [BTPoolHoldCoinModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            //转换为BTAssetModel,只需要两个参数，一个balance,一个unit
            for (BTPoolHoldCoinModel *model in list) {
                BTAssetsModel *assetModel = [[BTAssetsModel alloc]init];
                assetModel.coin = [[WalletManageCoinInfoModel alloc]init];
                assetModel.balance = model.balance;
                assetModel.coin.unit = model.coinName;
                [strongSelf.datasource addObject:assetModel];
            }
        }
    }];
}
- (void)setupBind{
    if (self.assetIndex == 1) {//需要显示币币资产
        self.balance.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:self.assets.balance.doubleValue withlimit:4],self.assets.coin.unit];
        self.unit.text = self.assets.coin.unit;
    }else{
        [self.datasource enumerateObjectsUsingBlock:^(BTAssetsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.coin.unit isEqualToString:self.assets.coin.unit]) {
                self.balance.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:obj.balance.doubleValue withlimit:4],obj.coin.unit];
                self.unit.text = obj.coin.unit;
            }
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_assetIndex == 1) {
        self.coinsCoins.text = LocalizationKey(@"币币");
        self.orePool.text = LocalizationKey(@"矿池");
    }else{
        self.coinsCoins.text = LocalizationKey(@"矿池");
        self.orePool.text = LocalizationKey(@"币币");
        self.switchBtn.selected = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupBind];
}
- (void)getSingleCoinWallet{
    [TradeNetManager getwallettWithcoin:self.assets.coin.unit CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.assets = [BTAssetsModel mj_objectWithKeyValues:resPonseObj[@"data"]];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = KLimitAssetInputDigits;//小数点后需要限制的个数
    for (int i = (int)(futureString.length - 1); i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}
- (IBAction)allAction:(UIButton *)sender {
    if (self.assets.balance.doubleValue > 0) {
        self.transferCount.text = [ToolUtil formartScientificNotationWithString:self.assets.balance];
    }
}
- (IBAction)exchangeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.assetIndex = 2;
        self.coinsCoins.text = LocalizationKey(@"矿池");
        self.orePool.text = LocalizationKey(@"币币");
    }else{
        self.assetIndex = 1;
        self.coinsCoins.text = LocalizationKey(@"币币");
        self.orePool.text = LocalizationKey(@"矿池");
    }
    [self setupBind];
}
- (IBAction)comfirmAction:(UIButton *)sender {
    if (!self.transferCount.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入划转数量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (self.transferCount.text.doubleValue > self.assets.balance.doubleValue) {
        [self.view makeToast:LocalizationKey(@"划转数量不能大于余额") duration:ToastHideDelay position:ToastPosition];return;
    }
    sender.userInteractionEnabled = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(self.assetIndex);
    params[@"apiKey"] = [YLUserInfo shareUserInfo].secretKey;
    params[@"amount"] = self.transferCount.text;
    params[@"coinName"] = self.assets.coin.unit;
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:transferWalletAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        sender.userInteractionEnabled = YES;
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
