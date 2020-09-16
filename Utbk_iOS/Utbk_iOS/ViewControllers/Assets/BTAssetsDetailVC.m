//
//  BTAssetsDetailVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsDetailVC.h"

@interface BTAssetsDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *totalAccout;//总额
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UILabel *recharge;//提币中
@property (weak, nonatomic) IBOutlet UILabel *trading;//交易中

@end

@implementation BTAssetsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"资产");
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:LocalizationKey(@"充提明细") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    [btn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)detailAction{
    
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
