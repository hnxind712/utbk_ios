//
//  BTOrePoolViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTOrePoolViewController.h"

@interface BTOrePoolViewController ()

@end

@implementation BTOrePoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addSegment];
}
- (void)addSegment{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"共享挖矿",@"持币空投",nil];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];

    segmentedControl.frame = CGRectMake(0, 0, 200, 32);

    segmentedControl.selectedSegmentIndex = 0;

    segmentedControl.tintColor = RGBOF(0xD1A870);
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.layer.cornerRadius = 16.f;
    segmentedControl.layer.borderWidth = 0.5;
    segmentedControl.layer.borderColor = RGBOF(0xD1A870).CGColor;

//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

    [segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)

    forControlEvents:UIControlEventValueChanged];

    //方法1
    [self.navigationItem setTitleView:segmentedControl];
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecord") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)transferRecordAction{
    
}
#pragma mark 分段控件事件
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segment{
    
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
