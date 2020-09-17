//
//  BTContributionVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTContributionVC.h"

@interface BTContributionVC ()

@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupCount;//组数
@property (weak, nonatomic) IBOutlet UITextField *countInput;
@property (weak, nonatomic) IBOutlet UILabel *equivalentLabel;//折合
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;//倍数
@property (weak, nonatomic) IBOutlet UILabel *avaliableLabel;//可用
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractionBtn;//-
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//+
@property (assign, nonatomic) NSInteger count;//记录组数

@end


@implementation BTContributionVC
- (id)init{
    if (self = [super init]) {
        self.count = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"贡献");
    [self addRightNavigation];
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_transferRecordR") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)transferRecordAction{
    
}
//加
- (IBAction)addAction:(UIButton *)sender {
    _count++;
    if (_count > 1) {//减法的按钮需要处理
        _subtractionBtn.enabled = YES;
        _subtractionBtn.layer.borderColor = RGBOF(0xA78559).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xA78559) forState:UIControlStateNormal];
    }
}
//减
- (IBAction)subtractionAction:(UIButton *)sender {
    _count--;
    if (_count == 1) {
        _subtractionBtn.enabled = NO;
        _subtractionBtn.layer.borderColor = RGBOF(0xE7E7E7).CGColor;
        [_subtractionBtn setTitleColor:RGBOF(0xE7E7E7) forState:UIControlStateNormal];
    }
}
//选择币种
- (IBAction)selectCoinAction:(UIButton *)sender {
}
//确认
- (IBAction)confirmAction:(UIButton *)sender {
}
//加减符号可点击的颜色#A78559 不可点击#E7E7E7
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
