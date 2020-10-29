//
//  BTAssetsTransiferVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsTransiferVC.h"
#import "BTCurrencyViewController.h"
#import "STQRCodeController.h"
#import "MineNetManager.h"
#import "MentionCoinInfoModel.h"
#import "BTAssetsModel.h"
#import "TradeNetManager.h"
#import "BTWithdrawRecordVC.h"

@interface BTAssetsTransiferVC ()<STQRCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *selectCoinTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *coinAddress;
@property (weak, nonatomic) IBOutlet UITextField *coinCountInput;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordInput;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (strong, nonatomic) NSArray *datasource;//所有币种的配置信息
@property (strong, nonatomic) MentionCoinInfoModel *model;
@property (strong, nonatomic) BTAssetsModel *assets;


@end

@implementation BTAssetsTransiferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"转币");
    [self setupBind];
    [self getSingleCoinWallet];
    [self addRightNavigation];
    self.coinCountInput.keyboardType = UIKeyboardTypeDecimalPad;
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecordR") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(withDrawRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)withDrawRecordAction{
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    withdrawRecord.recordType = KRecordTypeTransfer;
    withdrawRecord.unit = self.unit;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (void)getSingleCoinWallet{
    WeakSelf(weakSelf)
    [TradeNetManager getwallettWithcoin:self.unit CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
             StrongSelf(strongSelf)
            if ([resPonseObj[@"code"] integerValue] == 0) {
                strongSelf.assets = [BTAssetsModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                strongSelf.balance.text = [ToolUtil stringFromNumber:self.assets.balance.doubleValue withlimit:KLimitAssetInputDigits];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
- (void)setupBind{
    WeakSelf(weakSelf)
    [self.selectCoinTypeBtn setTitle:self.unit forState:UIControlStateNormal];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
        NSLog(@"获取提币信息 ---- %@",responseResult);
        StrongSelf(strongSelf)
        if (code) {
            if ([responseResult[@"code"] integerValue] == 0) {
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                self.datasource = dataArr;
                [dataArr enumerateObjectsUsingBlock:^(MentionCoinInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.unit isEqualToString:self.unit]) {
                        strongSelf.model = obj;*stop = YES;
                    }
                }];
                strongSelf.fee.text = strongSelf.model.maxTxFee;
            }else if ([responseResult[@"code"] integerValue] == 3000 ||[responseResult[@"code"] integerValue] == 4000 ){
                // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [strongSelf.view makeToast:responseResult[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [strongSelf.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
//选择币种
- (IBAction)selectCoinAction:(UIButton *)sender {
    WeakSelf(weakSelf)
    BTCurrencyViewController *currency = [[BTCurrencyViewController alloc]init];
    currency.selectedCurrency = ^(id  _Nonnull model) {
        StrongSelf(strongSelf)
      //拿到对应的币种之后，需要处理对应的手续费以及将对应的unit处理一下
        [self.selectCoinTypeBtn setTitle:self.unit forState:UIControlStateNormal];
        [self.datasource enumerateObjectsUsingBlock:^(MentionCoinInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.unit isEqualToString:self.unit]) {
                strongSelf.model = obj;*stop = YES;
            }
        }];
        strongSelf.fee.text = strongSelf.model.maxTxFee;
    };
    [self.navigationController pushViewController:currency animated:YES];
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
    STQRCodeController *qrcode = [[STQRCodeController alloc]init];
    qrcode.delegate = self;
    [self.navigationController pushViewController:qrcode animated:YES];
}
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType{
    if (resultType == STQRCodeResultTypeSuccess) {
        self.coinAddress.text = readerScanResult;
    }else if (resultType == STQRCodeResultTypeError){
        [self.view makeToast:LocalizationKey(@"没有扫描到任何结果") duration:ToastHideDelay position:ToastPosition];
    }
}
//全部输入
- (IBAction)inputAllCoinAccountAction:(UIButton *)sender {
    if (self.assets.balance.doubleValue > 0) {
        self.balance.text = [ToolUtil stringFromNumber:self.assets.balance.doubleValue withlimit:KLimitAssetInputDigits];
    }
}
//显示密码
- (IBAction)showTradePasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _tradePasswordInput.secureTextEntry = !sender.selected;
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (![self.coinAddress.text length]) {
        [self.view makeToast:LocalizationKey(@"请输入地址") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (![self.coinCountInput.text length]) {
        [self.view makeToast:LocalizationKey(@"请输入数量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (![self.tradePasswordInput.text length]) {
        [self.view makeToast:LocalizationKey(@"请输入交易密码") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSString *remark = @"";
    for (AddressInfo *address in self.model.addresses) {
        if ([self.coinAddress.text isEqualToString:address.address]) {
            remark = address.remark;
        }
    }
    sender.userInteractionEnabled = NO;
    NSString *inputAddress = [self.coinAddress.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    WeakSelf(weakSelf)
        NSMutableDictionary *dic = [NSMutableDictionary new];
           dic[@"unit"] = self.unit;
           dic[@"address"] = inputAddress;
           dic[@"amount"] = self.coinCountInput.text;
           dic[@"fee"] = self.model.maxTxFee;
           dic[@"jyPassword"] = self.tradePasswordInput.text;
           [[XBRequest sharedInstance]postDataWithUrl:AssetsTransferAPI Parameter:dic ResponseObject:^(NSDictionary *responseResult) {
               sender.userInteractionEnabled = YES;
               StrongSelf(strongSelf)
               if (NetSuccess) {
                   [strongSelf.view makeToast:responseResult[MESSAGE] duration:ToastHideDelay position:ToastPosition];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [strongSelf.navigationController popViewControllerAnimated:YES];
                   });
               }else
                   ErrorToast;
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
