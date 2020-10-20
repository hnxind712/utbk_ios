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

@interface BTContributionVC ()<UITextFieldDelegate>
{
    BOOL isNotice;//最大只能输入50组
}
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UITextField *groupCount;//组数
@property (weak, nonatomic) IBOutlet UITextField *countInput;
@property (weak, nonatomic) IBOutlet UILabel *equivalentLabel;//折合
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;//倍数
@property (weak, nonatomic) IBOutlet UILabel *avaliableLabel;//可用
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractionBtn;//-
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//+
@property (weak, nonatomic) IBOutlet UILabel *contributionValue;
@property (weak, nonatomic) IBOutlet UILabel *contributionT;
@property (assign, nonatomic) CGFloat convert;//折合的l比例
@property (assign, nonatomic) NSInteger count;//记录组数
@property (strong, nonatomic) NSArray *starAarry;//拿到临界的U点，来处理倍额
@property (strong, nonatomic) NSArray *doubleArray;//拿到倍额
@property (assign, nonatomic) BOOL isRemind;//是否提醒了

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
    [self.groupCount addTarget:self action:@selector(textFieldDidchange:) forControlEvents:UIControlEventEditingChanged];
    self.contributionT.text = LocalizationKey(@"贡献值");
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
- (void)textFieldDidchange:(UITextField *)textfield{
    if (textfield.text.doubleValue > 1) {
        _subtractionBtn.enabled = YES;
        _subtractionBtn.layer.borderColor = RGBOF(0xA78559).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xA78559) forState:UIControlStateNormal];
    }else{
        _subtractionBtn.enabled = NO;
        _subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    if (!textField.text.length && [string isEqualToString:@"0"]) {
        return NO;//第一个字符不能为数字0
    }
    if (_groupCount == textField && [self validateNumber:string]) {
        
        //返回的是改变过后的新str，即textfield的新的文本内容
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (checkStr.doubleValue > 50 && !self.isRemind) {
            [self.view makeToast:LocalizationKey(@"最多贡献50组") duration:ToastHideDelay position:ToastPosition];
            self.isRemind = YES;
        }
        return checkStr.doubleValue <= 50;
        
    }else if (_countInput == textField){//可不用，已取消
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag = 0;
        const NSInteger limited = KLimitAssetInputDigits;//小数点后需要限制的个数4
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
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_groupCount == textField) {
        if (!textField.text.length) {
            
            textField.text = @"1";
        }
        _count = textField.text.intValue;
        self.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * _count];
        self.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",100/self.convert * _count]],self.coinName];
        [self.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.count * KContributionValue <= critical.integerValue) {
                NSString *doubleS = self.doubleArray[idx];
                self.multipleLabel.text = [NSString stringWithFormat:@"%.0f USDT",doubleS.doubleValue * KContributionValue * _count];*stop = YES;
            }
        }];
        self.contributionValue.text = [NSString stringWithFormat:@"%dV",10 * _count];
    }
}
- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    int i = 0;
    
    while (i < number.length) {
        
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        
        if (range.length == 0) {
            
            res = NO;
            
            break;
            
        }
        
        i++;
        
    }
    
    return res;
    
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
                strongSelf.balance.text = [ToolUtil stringFromNumber:assets.balance.doubleValue withlimit:2];
                strongSelf.avaliableLabel.text = [NSString stringWithFormat:@"%@%@：",LocalizationKey(@"可用"),self.coinName];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
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
            strongSelf.multipleLabel.text = [NSString stringWithFormat:@"%.0f USDT",str.doubleValue * KContributionValue];
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
            strongSelf.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",100/[responseResult[@"data"]doubleValue]]],self.coinName];
        }
    }];
}
//加
- (IBAction)addAction:(UIButton *)sender {
    if ([self.countInput isFirstResponder]) {
        [self.view endEditing:YES];
    }
    _count++;
    if (_count > 1) {//减法的按钮需要处理
        _subtractionBtn.enabled = YES;
        _subtractionBtn.layer.borderColor = RGBOF(0xA78559).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xA78559) forState:UIControlStateNormal];
    }
    if (_count == 50) {
        sender.enabled = NO;
        sender.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [sender setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    }
    self.groupCount.text = [NSString stringWithFormat:@"%ld",(long)_count];
    self.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * _count];
    self.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",100/self.convert * _count]],self.coinName];
    [self.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.count * KContributionValue <= critical.integerValue) {
            NSString *doubleS = self.doubleArray[idx];
            self.multipleLabel.text = [NSString stringWithFormat:@"%.0f USDT",doubleS.doubleValue * KContributionValue * _count];*stop = YES;
        }
    }];
    self.contributionValue.text = [NSString stringWithFormat:@"%dV",10 * _count];
}
//减
- (IBAction)subtractionAction:(UIButton *)sender {
    if ([self.countInput isFirstResponder]) {
        [self.view endEditing:YES];
    }
    _count--;
    if (_count == 1) {
        _subtractionBtn.enabled = NO;
        _subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    }
    self.addBtn.enabled = YES;
    self.addBtn.layer.borderColor = RGBOF(0xA78559).CGColor;
    [self.addBtn setTitleColor:RGBOF(0xA78559) forState:UIControlStateNormal];
    self.groupCount.text = [NSString stringWithFormat:@"%ld",(long)_count];
    self.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * _count];
    self.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",100/self.convert * _count]],self.coinName];
    [self.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.count * KContributionValue <= critical.integerValue) {
            NSString *doubleS = self.doubleArray[idx];
            self.multipleLabel.text = [NSString stringWithFormat:@"%.0f USDT",doubleS.doubleValue * KContributionValue * _count];*stop = YES;
        }
    }];
    self.contributionValue.text = [NSString stringWithFormat:@"%dV",10 * _count];
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
        strongSelf.contributionValue.text = @"10V";
        strongSelf.subtractionBtn.enabled = NO;
        strongSelf.subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [strongSelf.subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
        [strongSelf.coinBtn setTitle:model.currency forState:UIControlStateNormal];
        strongSelf.equivalentLabel.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.2f",100/self.convert * self->_count]],self.coinName];
        [strongSelf.starAarry enumerateObjectsUsingBlock:^(NSString *critical, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.count * KContributionValue <= critical.integerValue) {
                NSString *doubleS = self.doubleArray[idx];
                self.multipleLabel.text = [NSString stringWithFormat:@"%.0f USDT",doubleS.doubleValue * KContributionValue * self->_count];*stop = YES;
            }
        }];
        strongSelf.countInput.text = [NSString stringWithFormat:@"%ld",KContributionValue * self->_count];
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
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshContribution" object:nil];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:NSClassFromString(@"BTPoolViewController")]) {
                        [self.navigationController popToViewController:vc animated:YES];break;
                    }
                }
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
