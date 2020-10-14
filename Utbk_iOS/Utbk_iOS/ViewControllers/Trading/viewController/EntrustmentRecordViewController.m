//
//  EntrustmentRecordViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/6.
//  Copyright © 2018年 ztuo. All rights reserved.
//

#import "EntrustmentRecordViewController.h"
#import "commissionViewController.h"
#import "HistoryTransactionEntrustViewController.h"
#import "DownTheTabs.h"
#import "HomeNetManager.h"

#define KEViewWidth (SCREEN_WIDTH - 24)
@interface EntrustmentRecordViewController ()<UIScrollViewDelegate>
{
    NSArray *_titles;
    UIView *_indicateView;
    NSInteger _currentIndex;
    DownTheTabs *_tabs;
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *labelView;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *symbols;

@end

@implementation EntrustmentRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar addSubview:self.labelView];
//    [self.navigationController.navigationBar addSubview:self.lineView];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.labelView removeFromSuperview];
//    [self.lineView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[LocalizationKey(@"Current"), LocalizationKey(@"HistoricalCurrent")];
    self.title = LocalizationKey(@"全部");
    [self setupLayout];
    [self setChildController];
    [self RightsetupNavgationItemWithpictureName:@"图层 601"];
}
- (void)setupLayout{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.labelView];
    [self.bgView addSubview:self.scrollView];
    
}
- (void)RighttouchEvent{
    if (self.symbols.count == 0) {
        [self getData];
        return;
    }
    if (_tabs.superview) {
        [_tabs removeFromSuperview];
    }else{
        DownTheTabs *tabs = [[DownTheTabs alloc] initEntrustTabsWithContainerView:self.view Symbols:self.symbols];
        _tabs = tabs;
        tabs.dismissBlock = ^{
            //        self.navigationItem.rightBarButtonItem.enabled = YES;
        };
        tabs.entrustBlock = ^(NSString *symbol, NSString *type, NSString *direction, NSString *startTime, NSString *endTime) {
            if (_currentIndex == 1) {
                NSDictionary *param = @{@"symbol":symbol, @"type":type, @"direction":direction, @"startTime":startTime, @"endTime":endTime, @"pageNo":@"1", @"pageSize":@"10"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"historyEntrust" object:param];
            }else{
                NSDictionary *param = @{@"symbol":symbol, @"type":type, @"direction":direction, @"startTime":startTime, @"endTime":endTime, @"pageNo":@"1", @"pageSize":@"10"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Querythecurrent" object:param];
                
            }
        };
    }
}

- (void)setChildController
{
    //添加子控制器
    commissionViewController *comVC = [[commissionViewController alloc] init];
    comVC.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    comVC.symbol = self.symbol;
    [self addChildViewController:comVC];
    [self.scrollView addSubview:comVC.view];

    HistoryTransactionEntrustViewController *histiroVC = [[HistoryTransactionEntrustViewController alloc] init];
    histiroVC.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    histiroVC.symbol = self.symbol;
    [self addChildViewController:histiroVC];
    [self.scrollView addSubview:histiroVC.view];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
}

- (void)recordAction:(UIButton *)sender{
    UIButton *btn = self.btnsArr[sender.tag];
    for (UIButton *btn in self.btnsArr) {
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    // 1 计算滚动的位置
    CGFloat offsetX = btn.tag * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    // 2.给对应位置添加对应子控制器
    [self showVc:btn.tag];
}

#pragma mark - UIScrollViewDelegate
- (void)showVc:(NSInteger)index {
    _currentIndex = index;
    CGFloat offsetX = index * self.scrollView.bounds.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载

    if (vc.isViewLoaded) return;
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.scrollView.bounds.size.width, self.scrollView.frame.size.height);

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 1.添加子控制器view
    [self recordAction:self.btnsArr[index]];
}
#pragma mark - 获取所有缩略详情
-(void)getData{
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        [self.symbols removeAllObjects];
        NSLog(@"获取所有缩略详情 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)resPonseObj;
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    [self.symbols addObject:dic[@"symbol"]];
                }];
            }else{
                
            }
        }else{

        }
    }];
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, KEViewWidth, self.view.height - 10 - TabbarSafeBottomMargin - NavBarHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
    
}
- (UIView *)labelView{
    if (!_labelView) {
        _labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KEViewWidth, 44)];
        CGFloat width = KEViewWidth/2;
        for (int i = 0; i < _titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * width, 0, width, 43);
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:RGBOF(0xA78659) forState:UIControlStateSelected];
            [btn setTitleColor:AppTextColor_333333 forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            [btn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            if (i == 0) {
                btn.selected = YES;
            }
            [self.btnsArr addObject:btn];
            [_labelView addSubview:btn];
        }
        
        
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH - 24.f, 1)];
        _indicateView.backgroundColor = RGBOF(0xE8E8E8);
        [_labelView addSubview:_indicateView];
    }
    return _labelView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = RGBOF(0xD1A870);

    }
    return _lineView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 44, self.bgView.frame.size.width, self.bgView.frame.size.height - 44.f);
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

- (NSMutableArray *)symbols{
    if (!_symbols) {
        _symbols = [NSMutableArray arrayWithCapacity:0];
    }
    return _symbols;
}

@end
