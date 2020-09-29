//
//  BTHomeViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeViewController.h"
#import <MSCycleScrollView.h>
#import "BTPayPasswordPopView.h"
#import "BTPayPasswordVC.h"
#import "BTMarketTableViewCell.h"
#import "BTHomeTransiferCoinVC.h"//转账
#import "BTSweepAccountVC.h"//划转
#import "BTInvitationActivityVC.h"//邀请激活
#import "BTHomeNoticeView.h"
#import "BTHomeNoticeVC.h"//消息列表
#import "BTPoolViewController.h"//矿池
#import "BTOnCurrencyVC.h"//上币
#import "BTWalletManagerVC.h"
#import "BTTeamHoldViewController.h"
#import "MineNetManager.h"
#import "HomeNetManager.h"
#import "symbolModel.h"
#import "BTBannerModel.h"
#import "BTNoticeModel.h"
#import "LSAppBrowserViewController.h"
#import "BTNoticeDetailVC.h"
#import "BTAssetsModel.h"

#define KBottomTopHeight 40.f //主板区标签对应的高度间隔
#define KRiseFallCellHeight 60.f

@interface BTHomeViewController ()<UITableViewDelegate,UITableViewDataSource,MSCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *bannerSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *coinCount;//原始母币
@property (weak, nonatomic) IBOutlet UILabel *convertCount;//折合(USDT)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;//主板区
@property (weak, nonatomic) IBOutlet UIButton *riseFallBtn;//涨幅榜
@property (strong, nonatomic) UIButton *selectedBtn;//记录选中的按钮（主板区或涨幅榜，避免点击多次重复请求）
@property (strong, nonatomic) UIButton *walletBtn;//钱包按钮
@property (strong, nonatomic) NSMutableArray *responceData;//主板区以及涨幅榜存储的数据
@property (strong, nonatomic) NSArray *datasource;//主板区以及涨幅榜对应的数据
@property (strong, nonatomic) NSMutableArray *bannerArr;
@property (strong, nonatomic) MSCycleScrollView *cycleScrollView;
@property (strong, nonatomic) BTPayPasswordPopView *payPasswordPopView;
@property (strong, nonatomic) BTHomeNoticeView *noticeView;
@property (strong, nonatomic) LYEmptyView *emptyView;

@end

@implementation BTHomeViewController
- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
- (LYEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"暂无数据")];
    }
    return _emptyView;
}
- (NSMutableArray *)responceData{
    if (!_responceData) {
        _responceData = [NSMutableArray array];
    }
    return _responceData;
}
- (BTHomeNoticeView *)noticeView{
    if (!_noticeView) {
        WeakSelf(weakSelf)
        _noticeView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BTHomeNoticeView class]) owner:nil options:nil].firstObject;
        _noticeView.noticeMoreAction = ^{
            StrongSelf(strongSelf)
            BTHomeNoticeVC *notice = [[BTHomeNoticeVC alloc]init];
            [strongSelf.navigationController pushViewController:notice animated:YES];
        };
        _noticeView.noticeDetailAction = ^(BTNoticeModel * _Nonnull model) {
            StrongSelf(strongSelf)
            BTNoticeDetailVC *detail = [[BTNoticeDetailVC alloc]init];
            detail.noticeModel = model;
            [strongSelf.navigationController pushViewController:detail animated:YES];
        };
    }
    return _noticeView;
}
- (BTPayPasswordPopView *)payPasswordPopView{
    if (!_payPasswordPopView) {
        WeakSelf(weakSelf)
        _payPasswordPopView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BTPayPasswordPopView class]) owner:nil options:nil].firstObject;
        _payPasswordPopView.setPayPasswordAction = ^{
            StrongSelf(strongSelf)
            BTPayPasswordVC *payPassword = [[BTPayPasswordVC alloc]init];
            [strongSelf.navigationController pushViewController:payPassword animated:YES];
        };
    }
    return _payPasswordPopView;
}
- (MSCycleScrollView *)cycleScrollView  {
    if (!_cycleScrollView) {
        _cycleScrollView = [[MSCycleScrollView alloc] init];
        _cycleScrollView.delegate = self;
        _cycleScrollView.dotsIsSquare = YES;
        _cycleScrollView.hidesForSinglePage = YES;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.layer.cornerRadius = 4.0f;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.pageDotColor = RGBOF(0xffffff);
        _cycleScrollView.currentPageDotColor = RGBOF(0x4F66FF);
        _cycleScrollView.pageControlDotSize = CGSizeMake(25, 5);
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
    }
    return _cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedBtn = self.mainBtn;
    [self setupLayout];
    [self addRightNavigation];
    [self addLeftNavigation];
    [self headRefreshWithScrollerView:self.mainScrollView];
    [self refreshHeaderAction];//直接拉取数据
    NSLog(@"私钥 = %@",[YLUserInfo shareUserInfo].ID);
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-下拉刷新数据
- (void)refreshHeaderAction{
    [self getBannerData];
    [self getNotice];
    [self getData];
    [self setupBind];
//    [self getDefaultSymbol];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]getDataWithUrl:getMotherCoinWalletAPI Parameter:nil ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if ([responseResult[@"data"]isKindOfClass:[NSNull class]]) {
                strongSelf.coinCount.text = @"0";
            }else
                strongSelf.coinCount.text = [ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%@",responseResult[@"data"][@"balance"]]];
        }
    }];
    [MineNetManager getMyWalletInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
        if (NetSuccess) {
            NSArray *dataArr = [BTAssetsModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
            for (BTAssetsModel *walletModel in dataArr) {
                //计算总资产
                if ([walletModel.coin.unit isEqualToString:KOriginalCoin]) {
                    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                    NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:walletModel.balance];
                    NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.usdRate];
                    
                    ass1 = [balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle];break;
                }
            }
            self.convertCount.text = [ass1 stringValue];
        }
    }];
}
#pragma mark-获取首页推荐信息
-(void)getData{
    WeakSelf(weakSelf)
    [HomeNetManager HomeDataCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取首页推荐信息 --- %@",resPonseObj);
        StrongSelf(strongSelf)
        [strongSelf.responceData removeAllObjects];
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *recommendArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"recommend"]];
            NSArray *changeRankArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"changeRank"]];
            if (changeRankArr&&recommendArr) {
                [strongSelf.responceData addObject:recommendArr];//推荐
                [strongSelf.responceData addObject:changeRankArr];//涨幅榜
                strongSelf.datasource = recommendArr;//默认给推荐的
                strongSelf.tableView.ly_emptyView = self.emptyView;
                [strongSelf.tableView reloadData];
                [strongSelf.tableView layoutIfNeeded];
                strongSelf.bottomViewHeight.constant = KRiseFallCellHeight * recommendArr.count + KBottomTopHeight;
            }
        }
    }];
}
#pragma mark-获取平台消息
-(void)getNotice{
    WeakSelf(weakSelf)
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                StrongSelf(strongSelf)
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSArray *dataArr = [BTNoticeModel mj_objectArrayWithKeyValuesArray:arr];
                if (dataArr) {
                    BTNoticeModel *model = dataArr.firstObject;//暂时取第一条
                    [strongSelf.noticeView configureNoticeViewWithModel:model];
                }
//                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
//                for (NSDictionary *dic in arr) {
//                    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
//                        if (![self hasChinese:dic[@"title"]]) {
//                            [muArr addObject:dic];
//                        }
//                    }else{
//                        if ([self hasChinese:dic[@"title"]]) {
//                            [muArr addObject:dic];
//                        }
//                    }
//                }
//                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
//                [self.platformMessageArr addObjectsFromArray:dataArr];
//                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
    
}
#pragma mark 获取banner
- (void)getBannerData{
    [HomeNetManager advertiseBannerCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"首页轮播图 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.bannerArr removeAllObjects];
                [self.bannerArr addObjectsFromArray:[BTBannerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]]];
                if (self.bannerArr.count>0) {
                    [self configUrlArrayWithModelArray:self.bannerArr];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}
-(void)configUrlArrayWithModelArray:(NSMutableArray*)array{
    NSMutableArray *urlArray=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        BTBannerModel *model = array[i];
        [urlArray addObject:model.url];
    }
    self.cycleScrollView.imageUrls = urlArray;
}
#pragma mark 轮播回调
- (void)cycleScrollView:(MSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BTBannerModel *model = self.bannerArr[index];
    LSAppBrowserViewController *browser = [[LSAppBrowserViewController alloc]init];
    browser.urlString = model.linkUrl;
    [self.navigationController pushViewController:browser animated:YES];
}
- (void)setupLayout{
    self.selectedBtn = self.mainBtn;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTMarketTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTMarketTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = RGBOF(0xE8E8E8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    //添加轮播图
    [self.bannerSuperView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0.f);
    }];
    [self.bannerSuperView addSubview:self.noticeView];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.right.bottom.offset(0.f);
        make.height.offset(27.f);
    }];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_switch") forState:UIControlStateNormal];
    [btn setTitle:@"切换" forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)addLeftNavigation{
    NSString *walletName = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"当前钱包："),[YLUserInfo shareUserInfo].username];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:walletName forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(walletAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    _walletBtn = btn;
}
#pragma mark 导航事件 钱包 转换
- (void)walletAction{
    BTWalletManagerVC *wallet = [[BTWalletManagerVC alloc]init];
    [self.navigationController pushViewController:wallet animated:YES];
}
- (void)transferAction{
    BTWalletManagerVC *wallet = [[BTWalletManagerVC alloc]init];
    [self.navigationController pushViewController:wallet animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![YLUserInfo shareUserInfo].isSetPw) {//如果没有设置交易密码，则必须先设置
        [self.payPasswordPopView show];
    }
}

#pragma mark buttonAction
- (IBAction)buttonClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100://收币
            
            break;
        case 101://转账
        {
            BTHomeTransiferCoinVC *transifer = [[BTHomeTransiferCoinVC alloc]init];
            [self.navigationController pushViewController:transifer animated:YES];
        }
            break;
        case 102://划转
        {
            BTSweepAccountVC *transifer = [[BTSweepAccountVC alloc]init];
            [self.navigationController pushViewController:transifer animated:YES];
        }
            break;
        case 103://上币
        {
            BTOnCurrencyVC *onCurrency = [[BTOnCurrencyVC alloc]init];
            [self.navigationController pushViewController:onCurrency animated:YES];
        }
            break;
        case 104://矿池
        {
            BTPoolViewController *pool = [[BTPoolViewController alloc]init];
            [self.navigationController pushViewController:pool animated:YES];
        }
            break;
        case 105://团队
        {
            BTTeamHoldViewController *team = [[BTTeamHoldViewController alloc]init];
            [self.navigationController pushViewController:team animated:YES];
        }
            break;
        case 106://社区
        {
            
        }
            break;
        case 107://邀请激活
        {
            BTInvitationActivityVC *invitation = [[BTInvitationActivityVC alloc]init];
            [self.navigationController pushViewController:invitation animated:YES];
        }
            break;
        case 108://夺宝
        case 109://商城
        {
            [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
        }
            break;
        case 110://游戏
        {
            
        }
            break;
        case 111://DeFi专区
        {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark 主板区/涨幅榜点击事件
- (IBAction)typeButtonClickAction:(UIButton *)sender {
    if (sender == self.selectedBtn) return;
    sender.selected = YES;
    [sender setTitleColor:RGBOF(0xD1A870) forState:UIControlStateNormal];
    self.selectedBtn = sender;
    switch (sender.tag) {
        case 108://主板区
            [self.riseFallBtn setTitleColor:RGBOF(0x323232) forState:UIControlStateNormal];
            self.riseFallBtn.selected = NO;
            self.datasource = self.responceData.firstObject;
            break;
       case 109:
            [self.mainBtn setTitleColor:RGBOF(0x323232) forState:UIControlStateNormal];
            self.mainBtn.selected = NO;
            self.datasource = self.responceData.lastObject;
            break;
        default:
            break;
    }
    self.tableView.ly_emptyView = self.emptyView;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.bottomViewHeight.constant = KRiseFallCellHeight * self.datasource.count + KBottomTopHeight;
    
}
#pragma mark tableDelegate  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTMarketTableViewCell class])];
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KRiseFallCellHeight;
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
