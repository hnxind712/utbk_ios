//
//  BTAssetsRechargeVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsRechargeVC.h"
#import "BTWithdrawRecordVC.h"
#import "BTLinkTypeModel.h"
#import "BTLinkTypeCollectionCell.h"

@interface BTAssetsRechargeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *addressCode;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *linkTypeCollection;
@property (weak, nonatomic) IBOutlet UILabel *coinTitle;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) BTLinkTypeModel *selectedModel;//选中的model

@end

@implementation BTAssetsRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBOF(0xa78659);
    self.title = self.isRechage ? LocalizationKey(@"充币") : LocalizationKey(@"收款");
    [self addRightNavigation];
    [self setupLayout];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    self.coinTitle.hidden = !self.isMotherCoin;
    self.address.text = self.model.address;
    self.addressCode.image = [BTCommonUtils logoQrCode:nil code:self.model.address];
    if ([self.model.coin.unit containsString:@"USDT"] && self.model.usdtAddress.count >= 2) {//只有USDT并且链地址大于1的时候self.model.usdtAddress.count >= 2 &&
        self.linkView.hidden = NO;
        NSMutableArray *datasource = [NSMutableArray array];
        for (NSString *key in self.model.usdtAddress.allKeys) {
            if ([key isEqualToString:@"USDTERC20"]) {
                BTLinkTypeModel *linkModel = [[BTLinkTypeModel alloc]init];
                linkModel.selected = YES;
                linkModel.linkType = [key substringFromIndex:4];
                [datasource addObject:linkModel];
            }else if ([key isEqualToString:@"USDTTRC20"]){
                BTLinkTypeModel *linkModel = [[BTLinkTypeModel alloc]init];
                linkModel.linkType = [key substringFromIndex:4];
                [datasource addObject:linkModel];
            }
        }
        self.datasource = datasource;
        [self.linkTypeCollection reloadData];
    }
}
- (void)setupLayout{
    self.layout.itemSize = CGSizeMake(70.f, 25.f);
    self.layout.minimumLineSpacing = 20.f;
    self.layout.minimumInteritemSpacing = 20.f;
    self.layout.sectionInset = UIEdgeInsetsMake(14, 8, 14, 8);
    [self.linkTypeCollection registerNib:[UINib nibWithNibName:NSStringFromClass([BTLinkTypeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BTLinkTypeCollectionCell class])];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGBOF(0xa78659);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:RGBOF(0xffffff)}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:AppTextColor}];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecord") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rechargeRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)rechargeRecordAction{
    BTWithdrawRecordVC *withdrawRecord = [[BTWithdrawRecordVC alloc]init];
    if (self.isMotherCoin) {
        withdrawRecord.recordType = KRecordTypeMotherCoinRecharge;
    }else
        withdrawRecord.recordType = KRecordTypeRecharge;
    withdrawRecord.unit = self.model.coin.unit;
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (void)addLeftNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_cardBack") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, StatusBarHeight, 40, 40);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    for (NSString *key in self.model.usdtAddress.allKeys) {
        if ([key containsString:model.linkType]) {
            self.address.text = self.model.usdtAddress[key];break;
        }
    }
}
- (IBAction)copyAction:(UIButton *)sender {
    if (!self.model.address.length) {
        [BTKeyWindow makeToast:LocalizationKey(@"地址为空") duration:ToastHideDelay position:ToastPosition];return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.address;
    [self.view makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];
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
