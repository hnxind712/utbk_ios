//
//  BTContributionRecordVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/26.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTContributionRecordVC.h"
#import "BTSharePoolTableViewCell.h"
#import "BTPoolShareContributionRecordModel.h"

@interface BTContributionRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *coinName;//币种名
@property (weak, nonatomic) IBOutlet UILabel *totalEarning;
@property (weak, nonatomic) IBOutlet UILabel *destroyValue;//销毁量
@property (weak, nonatomic) IBOutlet UIButton *contributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *earningsBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *selecedBtn;//暂定
@property (weak, nonatomic) IBOutlet UIView *contributionView;
@property (weak, nonatomic) IBOutlet UIView *earningView;
@property (assign, nonatomic) NSInteger currentPage;//当前页码
@property (assign, nonatomic) NSInteger type;//1 转入记录 2收益记录 0 为全部
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSArray *starAarry;//拿到星级的数据

@end

@implementation BTContributionRecordVC
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (id)init{
    if (self = [super init]) {
        self.currentPage = 0;
        self.type = 1;//默认进来为转入记录
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"贡献收益记录");
    self.selecedBtn = self.contributionBtn;
    [self setupLayout];
    [self refreshHeaderAction];
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    //先给死的币种值
    self.model.coin = @"BTCK";
    self.coinName.text = [NSString stringWithFormat:@"%@：",self.model.coin];
    self.totalEarning.text = [ToolUtil formartScientificNotationWithString:self.model.totalProduce];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",[ToolUtil formartScientificNotationWithString:[NSString stringWithFormat:@"%.f",self.model.destroyValue]],self.model.coin]];//销毁总量
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f weight:UIFontWeightBold],NSForegroundColorAttributeName:RGBOF(0xA78659)} range:NSMakeRange(0, attribute.string.length)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f],NSForegroundColorAttributeName:RGBOF(0xA78659)} range:[attribute.string rangeOfString:self.model.coin]];
    self.destroyValue.attributedText = attribute;
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTSharePoolTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
}
#pragma mark 获取数据
- (void)refreshHeaderAction{
    self.currentPage = 0;
    [self loadData];
}
- (void)refreshFooterAction{
    self.currentPage++;
    [self loadData];
}
- (void)loadData{
    WeakSelf(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiKey"] = KTempSecretKey;
    params[@"pageNo"] = @(self.currentPage);
    params[@"pageSize"] = @(KPageSize);
    params[@"type"] = @(self.type);
    [[XBRequest sharedInstance]postDataWithUrl:getMineShareLogsAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        if (NetSuccess) {
            if (strongSelf.currentPage == 0) {
                [strongSelf.datasource removeAllObjects];
            }
            [strongSelf.datasource addObjectsFromArray:[BTPoolShareContributionRecordModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]]];
            [strongSelf.tableView reloadData];
            if (strongSelf.datasource.count == 0) {//添加无数据页面
                
            }
        }else
            ErrorToast
    }];
}
- (IBAction)recordAction:(UIButton *)sender {
    if (self.selecedBtn == sender) return;
    sender.selected = YES;
    self.selecedBtn = sender;
    switch (sender.tag) {
        case 100:
            self.earningsBtn.selected = NO;
            self.earningView.hidden = YES;
            self.contributionView.hidden = NO;
            self.type = 1;
            break;
        case 101:
            self.contributionBtn.selected = NO;
            self.earningView.hidden = NO;
            self.contributionView.hidden = YES;
            self.type = 2;
            break;
        default:
            break;
    }
    self.currentPage = 0;
    [self refreshHeaderAction];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTSharePoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTSharePoolTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = self.type;
    [cell configureCellWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
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
