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
@property (assign, nonatomic) NSInteger count;//记录组数
@property (copy, nonatomic) NSString *coinName;//默认是BTCK

@end

@implementation BTContributionVC
- (id)init{
    if (self = [super init]) {
        self.count = 1;
        self.coinName = @"BTCK";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"贡献");
    [self addRightNavigation];
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
    
}
- (void)setupBind{
    WeakSelf(weakSelf)
    //KContributionValue
    [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            NSMutableArray *data = [NSMutableArray array];
            [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            }];
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
}
//选择币种
- (IBAction)selectCoinAction:(UIButton *)sender {
    WeakSelf(weakSelf)
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    currency.selectedCurrency = ^(BTCurrencyModel *model) {
        StrongSelf(strongSelf)
        strongSelf.coinName = model.currency;
        [strongSelf getCoinExchangeUSDTRate];
        strongSelf.count = 1;
        strongSelf.groupCount.text = [NSString stringWithFormat:@"%ld",(long)strongSelf.count];
        strongSelf.subtractionBtn.enabled = NO;
        strongSelf.subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [strongSelf.subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:currency animated:YES];
}
//确认
- (IBAction)confirmAction:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupQty"] = @(self.count);
    params[@"coinName"] = self.coinName;
    params[@"apiKey"] = KTempSecretKey;
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
