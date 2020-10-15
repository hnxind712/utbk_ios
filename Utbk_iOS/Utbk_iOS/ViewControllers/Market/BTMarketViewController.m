//
//  BTMarketViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTMarketViewController.h"
#import "BTMarketTableViewCell.h"
#import "KchatViewController.h"
#import "MineNetManager.h"
#import "symbolModel.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"

#define KTableViewTop 46.f

@interface BTMarketViewController ()<UITableViewDelegate,UITableViewDataSource,SocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *latestPrice;
@property (weak, nonatomic) IBOutlet UILabel *riseFall;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;
@property (strong, nonatomic) NSMutableArray *datasource;

@end

@implementation BTMarketViewController
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self resetLocalization];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetLocalization) name:LanguageChange object:nil];
    [self getUSDTToCNYRate];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate=[NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:ToastHideDelay position:ToastPosition];
        }
    }];
}

- (void)resetLocalization{
    self.title = LocalizationKey(@"tabbar2");
    self.riseFall.text = LocalizationKey(@"24H涨跌");
    self.latestPrice.text = LocalizationKey(@"最新价格");
    self.coinName.text = LocalizationKey(@"币种");
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:NavColor] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    [self setupBind];
    [SocketManager share].delegate=self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
}
- (void)setupBind{
    WeakSelf(weakSelf)
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"数据 = %@",resPonseObj);
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                StrongSelf(strongSelf)
                [strongSelf.datasource removeAllObjects];
                strongSelf.datasource = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj];
                [strongSelf.tableView reloadData];
                [strongSelf.tableView layoutIfNeeded];
                if (strongSelf.tableView.contentSize.height > SCREEN_HEIGHT - NavBarHeight - 120 - TabbarSafeBottomMargin) {
                    strongSelf.heightContraint.constant = SCREEN_HEIGHT - NavBarHeight - 120 - TabbarSafeBottomMargin;
                }else{
                    strongSelf.heightContraint.constant = strongSelf.tableView.contentSize.height;
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"networkAbnormal") duration:1.5 position:ToastPosition];
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
        if (endStr) {
//           NSDictionary *dic = [NSDictionary dictionaryWithObject:endStr forKey:@"param"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:SUBSCRIBE_SYMBOL object:nil userInfo:dic];
            NSDictionary *dic1 = [SocketUtils dictionaryWithJsonString:endStr];
            symbolModel *model = [symbolModel mj_objectWithKeyValues:dic1];
            NSMutableArray *recommendArr = (NSMutableArray *)self.datasource;
            [recommendArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [recommendArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                   
                    [self.tableView reloadData];
                }
            }];
        }
    }
    NSLog(@"行情消息-%@--%d",endStr,cmd);
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTMarketTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTMarketTableViewCell class])];
    self.tableView.tableFooterView = [UITableView new];
    [self headRefreshWithScrollerView:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.tableView.separatorColor = RGBOF(0xe8e8e8);
}
- (void)refreshHeaderAction{
    [self setupBind];
}
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
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KchatViewController*klineVC = [[KchatViewController alloc]init];
    symbolModel *model = self.datasource[indexPath.row];
    klineVC.symbol = model.symbol;
    klineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:klineVC withBackTitle:model.symbol animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
