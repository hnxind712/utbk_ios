//
//  BTAssetsWithdrawVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsWithdrawVC.h"
#import "BTWithdrawRecordVC.h"
#import "STQRCodeController.h"
#import "MineNetManager.h"
#import "BTLinkTypeModel.h"
#import "BTLinkTypeCollectionCell.h"
#import "BTConfigureModel.h"
#import "MentionCoinInfoModel.h"
#import "TradeNetManager.h"
#import "BTAssetsModel.h"

@interface BTAssetsWithdrawVC ()<STQRCodeControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *linkTypeCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkHeight;
@property (weak, nonatomic) IBOutlet UITextField *addressInput;
@property (weak, nonatomic) IBOutlet UITextField *coinCountInput;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordInput;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) BTLinkTypeModel *selectedModel;//选中的model
@property (strong, nonatomic) MentionCoinInfoModel *model;
@property (strong, nonatomic) NSArray *mentionDatasource;
@property (strong, nonatomic) BTAssetsModel *assets;
@property (weak, nonatomic) IBOutlet UILabel *actualAccount;
@property (weak, nonatomic) IBOutlet UILabel *tips;

@end

@implementation BTAssetsWithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"提币");
    [self addRightNavigation];
    [self setupLayout];
    [self setupBind];
//    [self.coinCountInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
- (void)setupLayout{
    self.coinCountInput.keyboardType = UIKeyboardTypeDecimalPad;
    self.layout.itemSize = CGSizeMake(70.f, 25.f);
    self.layout.minimumLineSpacing = 20.f;
    self.layout.minimumInteritemSpacing = 20.f;
    self.layout.sectionInset = UIEdgeInsetsMake(14, 8, 14, 8);
    [self.linkTypeCollection registerNib:[UINib nibWithNibName:NSStringFromClass([BTLinkTypeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BTLinkTypeCollectionCell class])];
    //
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:LocalizationKey(@"温馨提示：仅支持erc20钱包地址，地址出错将无法找回请认真核对")];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    //调整行间距
    [attribute addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [attribute.string length])];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:RGBOF(0xA78659)} range:NSMakeRange(0, [attribute.string length])];
    self.tips.attributedText = attribute;
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
    if (self.model) {
        if (futureString.doubleValue > self.model.maxTxFee.doubleValue) {
            self.actualAccount.text = [NSString stringWithFormat:@"%.4f USDT",futureString.doubleValue - self.model.maxTxFee.doubleValue];
        }else{
            self.actualAccount.text = @"0.0000 USDT";
        }
        
    }
    
    return YES;
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [TradeNetManager getwallettWithcoin:self.unit CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            StrongSelf(strongSelf)
            if ([resPonseObj[@"code"] integerValue] == 0) {
                strongSelf.assets = [BTAssetsModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                strongSelf.balance.text = [NSString stringWithFormat:@"%@ USDT",[ToolUtil stringFromNumber:self.assets.balance.doubleValue withlimit:KLimitAssetInputDigits]];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:ToastHideDelay position:ToastPosition];
        }
    }];
    [[XBRequest sharedInstance]getDataWithUrl:getMinConfigsAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        NSLog(@"数据 = %@",responseResult);
        StrongSelf(strongSelf)
        if (NetSuccess) {
            NSArray *dataArray = [BTConfigureModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            __block BTConfigureModel *linkModel;
            [dataArray enumerateObjectsUsingBlock:^(BTConfigureModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.key isEqualToString:@"usdt-link-type"]) {//链类型对应的key
                    linkModel = obj;*stop = YES;
                }
            }];
            if (linkModel.value.length) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *data = [linkModel.value componentsSeparatedByString:@","];
                [data enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BTLinkTypeModel *model = [[BTLinkTypeModel alloc]init];
                    model.linkType = obj;
                    if (idx == 0) {//默认选中
                        model.selected = YES;
                        strongSelf.selectedModel = model;
                    }
                    [list addObject:model];
                }];
                strongSelf.datasource = list;
                [strongSelf.linkTypeCollection reloadData];
            }

        }
    }];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
        NSLog(@"获取提币信息 ---- %@",responseResult);
        StrongSelf(strongSelf)
        if (code) {
            if ([responseResult[@"code"] integerValue] == 0) {
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                self.mentionDatasource = dataArr;
                [dataArr enumerateObjectsUsingBlock:^(MentionCoinInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.unit isEqualToString:self.unit]) {
                        strongSelf.model = obj;*stop = YES;
                    }
                }];
                strongSelf.fee.text = [NSString stringWithFormat:@"%@",strongSelf.model.maxTxFee];
            }else{
                [strongSelf.view makeToast:responseResult[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [strongSelf.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
- (void)withDrawRecordAction{
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    withdrawRecord.recordType = KRecordTypeWithdraw;
    withdrawRecord.unit = [self.selectedModel.linkType isEqualToString:@"TRC20"] ? @"USDTTRC20" : self.unit;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BTLinkTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BTLinkTypeCollectionCell class]) forIndexPath:indexPath];
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTLinkTypeModel *model = self.datasource[indexPath.row];
    if (model == self.selectedModel) return;
    model.selected = YES;
    self.selectedModel.selected = NO;
    self.selectedModel = model;
    [collectionView reloadData];
    self.addressInput.text = @"";
    if ([model.linkType isEqualToString:@"ERC20"]) {
        for (MentionCoinInfoModel *mentionModel in self.mentionDatasource) {
            if ([mentionModel.unit isEqualToString:@"USDT"]) {
                self.model = mentionModel;
                self.unit = mentionModel.unit;
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:LocalizationKey(@"温馨提示：仅支持erc20钱包地址，地址出错将无法找回请认真核对")];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:10];
                //调整行间距
                [attribute addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, [attribute.string length])];
                [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:RGBOF(0xA78659)} range:NSMakeRange(0, [attribute.string length])];
                self.tips.attributedText = attribute;
                break;
            }
        }
    }else if ([model.linkType isEqualToString:@"TRC20"]){
        for (MentionCoinInfoModel *mentionModel in self.mentionDatasource) {
            if ([mentionModel.unit containsString:@"TRC20"]) {
                self.model = mentionModel;
                self.unit = mentionModel.unit;
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:LocalizationKey(@"温馨提示：仅支持trc20钱包地址，地址出错将无法找回请认真核对")];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:10];
                //调整行间距
                [attribute addAttribute:NSParagraphStyleAttributeName
                                         value:paragraphStyle
                                         range:NSMakeRange(0, [attribute.string length])];
                [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:RGBOF(0xA78659)} range:NSMakeRange(0, [attribute.string length])];
                self.tips.attributedText = attribute;
                break;;
            }
        }
    }
    self.fee.text = [NSString stringWithFormat:@"%@",self.model.maxTxFee];
}
//扫描
- (IBAction)scanCoinAddrssAction:(UIButton *)sender {
    STQRCodeController *qrcode = [[STQRCodeController alloc]init];
    qrcode.delegate = self;
    [self.navigationController pushViewController:qrcode animated:YES];
}
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType{
    if (resultType == STQRCodeResultTypeSuccess) {
        _addressInput.text = readerScanResult;
    }else if (resultType == STQRCodeResultTypeNoInfo){
        [self.view makeToast:LocalizationKey(@"没有扫描到任何结果") duration:ToastHideDelay position:ToastPosition];
    }
}
//全部输入
- (IBAction)inputAllCoinAccountAction:(UIButton *)sender {
    if (self.assets.balance.doubleValue > 0) {
        self.coinCountInput.text = [ToolUtil stringFromNumber:self.assets.balance.doubleValue withlimit:KLimitAssetInputDigits];
        if (self.assets.balance.doubleValue > 10.f) {
            self.actualAccount.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:self.assets.balance.doubleValue - self.model.maxTxFee.doubleValue withlimit:KLimitAssetInputDigits]];
        }else{
            self.actualAccount.text = @"0.0000 USDT";
        }
    }
}
//显示密码
- (IBAction)showTradePasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _tradePasswordInput.secureTextEntry = !sender.selected;
}
- (IBAction)confirmAction:(UIButton *)sender {
    if (![self.addressInput.text length]) {
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
         if ([self.addressInput.text isEqualToString:address.address]) {
             remark = address.remark;
         }
     }
    WeakSelf(weakSelf)
    [MineNetManager mentionCoinApplyForUnit:self.unit withAddress:self.addressInput.text withAmount:self.coinCountInput.text withFee:self.model.maxTxFee withRemark:remark withJyPassword:self.tradePasswordInput.text mobilecode:nil googleCode:nil CompleteHandle:^(id resPonseObj, int code) {
        StrongSelf(strongSelf)
       if (code) {
              if ([resPonseObj[@"code"] integerValue] == 0) {
                  [strongSelf.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [strongSelf.navigationController popViewControllerAnimated:YES];
                  });
              }else{
                  [strongSelf.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
              }
          }else{
              [strongSelf.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
          }
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
