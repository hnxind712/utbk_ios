//
//  BTContributionVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTContributionVC.h"
#import "BTCurrencyViewController.h"
#import "BTCurrencyModel.h"
#import "TradeNetManager.h"
#import "BTAssetsModel.h"
#import "BTWithdrawRecordVC.h"

@interface BTContributionVC ()

@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupCount;//组数
@property (weak, nonatomic) IBOutlet UITextField *countInput;
@property (weak, nonatomic) IBOutlet UILabel *equivalentLabel;//折合
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;//倍数
@property (weak, nonatomic) IBOutlet UILabel *avaliableLabel;//可用
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractionBtn;//-
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//+
@property (assign, nonatomic) CGFloat convert;//折合的l比例
@property (assign, nonatomic) NSInteger count;//记录组数
@property (strong, nonatomic) NSArray *starAarry;//拿到临界的U点，来处理倍额
@property (strong, nonatomic) NSArray *doubleArray;//拿到倍额

@end

@implementation BTContributionVC
- (id)init{
    if (self = [super init]) {
        self.count = 1;
        self.coinName = KOriginalCoin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"贡献");
//    [self addRightNavigation];
    [self getWallet];
    [self setupBind];
    [self getCoinExchangeUSDTRate];
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
    BTWithdrawRecordVC *record = [[BTWithdrawRecordVC alloc]init];
    record.recordType = KRecordTypeContributionRecord;
    [self.navigationController pushViewController:record animated:YES];
}
- (void)getWallet{
    WeakSelf(weakSelf)
    [TradeNetManager getwallettWithcoin:self.coinName CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            StrongSelf(strongSelf)
            if ([resPonseObj[@"code"] integerValue] == 0) {
                BTAssetsModel *assets = [BTAssetsModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                strongSelf.balance.text = [ToolUtil formartScientificNotationWithString:assets.balance];
                strongSelf.avaliableLabel.text = [NSString stringWithFormat:@"%@%@：",LocalizationKey(@"可用"),self.coinName];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络请求失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            NSMutableArray *data = [NSMutableArray array];
            NSMutableArray *doubleData = [NSMutableArray array];
            [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.key isEqualToString:@"level_1_contribution"]) {//链类型对应的key
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }else if ([obj.key isEqualToString:@"level_2_contribution"]){
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }else if ([obj.key isEqualToString:@"level_3_contribution"]){
                    NSString *str = [obj.value substringFromIndex:[obj.value rangeOfString:@"-"].location + 1];
                    [data addObject:str];
                }else if ([obj.key isEqualToString:@"level_1_bonus"]){
                    [doubleData addObject: obj.value];
                }else if ([obj.key isEqualToString:@"level_2_bonus"]){
                    [doubleData addObject: obj.value];
                }else if ([obj.key isEqualToString:@"level_3_bonus"]){
                    [doubleData addObject: obj.value];
                }
            }];
            strongSelf.starAarry = data;//保存一下，需要计算用
            strongSelf.doubleArray = doubleData;
            NSString *str = strongSelf.doubleArray.firstObject;//默认先取2倍
            strongSelf.multipleLabel.text = [NSString stringWithFormat:@"%.0f",str.doubleValue * KContributionValue];
        }
    }];
}
- (void)getCoinExchangeUSDTRate{
    //默认的地址
    WeakSelf(weakSelf)
    NSString *url = [NSString stringWithFormat:@"%@/USDT/%@",exchangeRateAPI,self.coinName];
    [[XBRequest sharedInstance]postDataWithUrl:url Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            StrongSelf(strongSelf)
            strongSelf.convert = [responseResult[@"data"]doubleValue];
            strongSelf.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%f",[responseResult[@"data"]doubleValue] * 100]],self.coinName];
        }
    }];
}
//加
- (IBAction)addAction:(UIButton *)sender {
    _count++;
    if (_count > 1) {//减法的按钮需要处理
        _subtractionBtn.enabled = YES;
        _subtractionBtn.layer.borderColor = RGBOF(0xA78559).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xA78559) forState:UIControlStateNormal];
    }
    self.groupCount.text = [NSString stringWithFormat:@"%ld",(long)_count];
    self.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * _count];
    self.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%f",self.convert * 100 * _count]],self.coinName];
    [self.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.count * KContributionValue <= critical.integerValue) {
            NSString *doubleS = self.doubleArray[idx];
            self.multipleLabel.text = [NSString stringWithFormat:@"%.0f",doubleS.doubleValue * KContributionValue];*stop = YES;
        }
    }];
}
//减
- (IBAction)subtractionAction:(UIButton *)sender {
    _count--;
    if (_count == 1) {
        _subtractionBtn.enabled = NO;
        _subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    }
    self.groupCount.text = [NSString stringWithFormat:@"%ld",(long)_count];
    self.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * _count];
    self.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%f",self.convert * 100 * _count]],self.coinName];
    [self.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.count * KContributionValue <= critical.integerValue) {
            NSString *doubleS = self.doubleArray[idx];
            self.multipleLabel.text = [NSString stringWithFormat:@"%.0f",doubleS.doubleValue * KContributionValue];*stop = YES;
        }
    }];
}
//选择币种
- (IBAction)selectCoinAction:(UIButton *)sender {
    WeakSelf(weakSelf)
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    currency.index = 0;
    currency.curreny = self.coinName;
    currency.motherCoin = self.motherCoin;
    currency.selectedCurrency = ^(BTCurrencyModel *model) {
        StrongSelf(strongSelf)
        strongSelf.coinName = model.currency;
        [strongSelf getWallet];
        [strongSelf getCoinExchangeUSDTRate];
        strongSelf.count = 1;
        strongSelf.groupCount.text = [NSString stringWithFormat:@"%ld",(long)strongSelf.count];
        strongSelf.subtractionBtn.enabled = NO;
        strongSelf.subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [strongSelf.subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
        [strongSelf.coinBtn setTitle:model.currency forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:currency animated:YES];
}
//确认
- (IBAction)confirmAction:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupQty"] = @(self.count);
    params[@"coinName"] = self.coinName;
    params[@"apiKey"] = [YLUserInfo shareUserInfo].secretKey;
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:addMineShareAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            [strongSelf.view makeToast:responseResult[@"message"] duration:ToastHideDelay position:ToastPosition];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else
            ErrorToast
            }];
}
//加减符号可点击的颜色#A78559 不可点击#E7E7E7
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
