//
//  BTPoolViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTPoolViewController.h"
#import "BTHoldCoinsViewController.h"
#import "BTSharePoolVC.h"
#import "SPMultipleSwitch.h"
#import "BTContributionVC.h"

@interface BTPoolViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) SPMultipleSwitch *multipleSwitch;

@end

@implementation BTPoolViewController
- (SPMultipleSwitch *)multipleSwitch{
    if (!_multipleSwitch) {
        SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[LocalizationKey(@"共享挖矿"),LocalizationKey(@"持币空投")]];
        switch1.frame = CGRectMake(0, 0, 193, 30);
        [switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] ;
        
        switch1.selectedTitleColor = RGBOF(0xffffff);
        switch1.titleColor = RGBOF(0xA78659);
        switch1.trackerColor = RGBOF(0xDAC49D);
        switch1.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = switch1;
        self.multipleSwitch = switch1;
        switch1.setNeedsCornerRadius = YES;
        switch1.layer.borderWidth = 0.5;
        switch1.layer.borderColor = RGBOF(0xD1A870).CGColor;
        switch1.layer.cornerRadius = 15.f;
        switch1.setForbidenScroll = YES;
        _multipleSwitch = switch1;
    }
    return _multipleSwitch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController];
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:LocalizationKey(@"贡献") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(contributionAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)contributionAction{
    BTContributionVC *contribution = [[BTContributionVC alloc]init];
    [self.navigationController pushViewController:contribution animated:YES];
}
- (void)addChildViewController{
    BTSharePoolVC *sharePool = [[BTSharePoolVC alloc]init];
    [self addChildViewController:sharePool];
    [self.scrollView addSubview:sharePool.view];
    sharePool.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
    BTHoldCoinsViewController *ore = [[BTHoldCoinsViewController alloc]init];
    [self addChildViewController:ore];
    [self.scrollView addSubview:ore.view];
    ore.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, self.scrollView.bounds.size.height);
}
- (void)switchAction:(SPMultipleSwitch *)multipleSwitch{
    switch (multipleSwitch.selectedSegmentIndex) {
         case 0:
             [self addRightNavigation];
             break;
         case 1:
             self.navigationItem.rightBarButtonItem = nil;
             break;
         default:
             break;
     }
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * multipleSwitch.selectedSegmentIndex, 0)animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addSegment];
}
- (void)addSegment{
    //方法1
    [self.navigationItem setTitleView:self.multipleSwitch];
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
