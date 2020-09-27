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
#import "BTTeamHoldViewController.h"
#import "MineNetManager.h"
#import "HomeNetManager.h"

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
    [self headRefreshWithScrollerView:self.mainScrollView];
    NSLog(@"助记词 = %@",[[NSUserDefaults standardUserDefaults]objectForKey:KMnemonicWords]);
    NSLog(@"私钥 = %@",[YLUserInfo shareUserInfo].ID);
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-下拉刷新数据
- (void)refreshHeaderAction{
    [self getBannerData];
//    [self getData];
//    [self getDefaultSymbol];
}
#pragma mark-获取平台消息
-(void)getNotice{
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
//                [self.platformMessageArr removeAllObjects];
//                NSArray *arr = resPonseObj[@"data"][@"content"];
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
//                [self.bannerArr removeAllObjects];
//                [self.bannerArr addObjectsFromArray:[bannerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]]];
//                if (self.bannerArr.count>0) {
//                    [self configUrlArrayWithModelArray:self.bannerArr];
//                }
//            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
//            }
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:1.5 position:ToastPosition];
        }
    }];
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {

        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
//        symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
        //推荐
//        if (self.contentArr.count>0) {
//            NSMutableArray*recommendArr=(NSMutableArray*)self.contentArr[0];
//            [recommendArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj.symbol isEqualToString:model.symbol]) {
//                    [recommendArr  replaceObjectAtIndex:idx withObject:model];
//                    *stop = YES;
//
//                    [self.tableView reloadData];
//                }
//            }];
//            //涨幅榜
//            if (self.contentArr.count < 1) {
//                return;
//            } NSMutableArray*changeRankArr=(NSMutableArray*)self.contentArr[1];
//            [changeRankArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj.symbol isEqualToString:model.symbol]) {
//                    [changeRankArr  replaceObjectAtIndex:idx withObject:model];
//                    *stop = YES;
//                    [self.tableView reloadData];
//                }
//            }];
//        }
    }else if (cmd==UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(@"取消订阅首页消息");
        
    }else{
        
    }
    //    NSLog(@"首页消息-%@--%d",endStr,cmd);
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
    NSLog(@"点击了转换");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (![YLUserInfo shareUserInfo].isSetPw) {//如果没有设置交易密码，则必须先设置
//        [self.payPasswordPopView show];
//    }
    [self.tableView layoutIfNeeded];
    self.bottomViewHeight.constant = KRiseFallCellHeight * 10 + KBottomTopHeight;
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
