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
#import "BTHomeRiseFallModel.h"
#import "BTHomeRiseFallCell.h"
#import "BTHomeTransiferCoinVC.h"//转账
#import "BTSweepAccountVC.h"//划转
#import "BTInvitationActivityVC.h"//邀请激活
#import "BTHomeNoticeView.h"
#import "BTHomeNoticeVC.h"//消息列表
#import "BTPoolViewController.h"//矿池
#import "BTOnCurrencyVC.h"//上币
#import "BTWalletManagerVC.h"

#define KBottomTopHeight 40.f //主板区标签对应的高度间隔
#define KRiseFallCellHeight 60.f

@interface BTHomeViewController ()<UITableViewDelegate,UITableViewDataSource,MSCycleScrollViewDelegate>

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
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) MSCycleScrollView *cycleScrollView;
@property (strong, nonatomic) BTPayPasswordPopView *payPasswordPopView;
@property (strong, nonatomic) BTHomeNoticeView *noticeView;

@end

@implementation BTHomeViewController
- (BTHomeNoticeView *)noticeView{
    if (!_noticeView) {
        WeakSelf(weakSelf)
        _noticeView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BTHomeNoticeView class]) owner:nil options:nil].firstObject;
        _noticeView.noticeMoreAction = ^{
            StrongSelf(strongSelf)
            BTHomeNoticeVC *payPassword = [[BTHomeNoticeVC alloc]init];
            [strongSelf.navigationController pushViewController:payPassword animated:YES];
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
    [self setupLayout];
    [self addRightNavigation];
    [self addLeftNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupLayout{
    self.selectedBtn = self.mainBtn;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHomeRiseFallCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTHomeRiseFallCell class])];
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"当前钱包：Jaylovely" forState:UIControlStateNormal];
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
    NSLog(@"点击了转换");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView layoutIfNeeded];
    self.bottomViewHeight.constant = KRiseFallCellHeight * 10 + KBottomTopHeight;
}

#pragma mark buttonAction
- (IBAction)buttonClickAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            
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
            case 105://夺宝
            case 106://商城
        {
            [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
        }
            break;
            case 107://邀请激活
        {
            BTInvitationActivityVC *invitation = [[BTInvitationActivityVC alloc]init];
            [self.navigationController pushViewController:invitation animated:YES];
        }
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
            break;
       case 109:
            [self.mainBtn setTitleColor:RGBOF(0x323232) forState:UIControlStateNormal];
            self.mainBtn.selected = NO;
            break;
        default:
            break;
    }
}
#pragma mark tableDelegate  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHomeRiseFallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTHomeRiseFallCell class])];
    [cell configureCellWithRiseFallModel:self.datasource[indexPath.row]];
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
