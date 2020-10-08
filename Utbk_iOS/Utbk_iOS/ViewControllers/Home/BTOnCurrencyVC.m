//
//  BTOnCurrencyVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTOnCurrencyVC.h"

@interface BTOnCurrencyVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *chineseName;
@property (weak, nonatomic) IBOutlet UITextField *englishName;
@property (weak, nonatomic) IBOutlet UITextField *circulation;//发行量
@property (weak, nonatomic) IBOutlet UITextField *discharge;//流通量
@property (weak, nonatomic) IBOutlet UITextView *subjectDescription;
@property (weak, nonatomic) IBOutlet UILabel *placeH;
@property (weak, nonatomic) IBOutlet UITextField *userCount;
@property (weak, nonatomic) IBOutlet UITextField *markingBudget;//营销预算

@end

@implementation BTOnCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)textViewDidChange:(UITextView *)textView{
    self.placeH.hidden = textView.text.length;
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//完成
- (IBAction)completedAction:(UIButton *)sender {
    if (!_name.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入联系人姓名") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_phoneNum.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入联系人手机号") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_chineseName.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入中文币种名称") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_englishName.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入英文币种名称") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_circulation.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入发行总量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_discharge.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入市场已流通量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_subjectDescription.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入项目介绍") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_userCount.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入社区用户量") duration:ToastHideDelay position:ToastPosition];return;
    }
    if (!_markingBudget.text.length) {
        [self.view makeToast:LocalizationKey(@"请输入营销预算") duration:ToastHideDelay position:ToastPosition];return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contentName"] = self.name.text;
    params[@"contentPhone"] = self.phoneNum.text;
    params[@"coinCnName"] = self.chineseName.text;
    params[@"coinEnName"] = self.englishName.text;
    params[@"total"] = self.circulation.text;
    params[@"marketFlow"] = self.discharge.text;
    params[@"projectIntroduce"] = self.subjectDescription.text;
    params[@"communityPeople"] = self.userCount.text;
    params[@"markBudget"] = self.markingBudget.text;
    WeakSelf(weakSelf)
    [[XBRequest sharedInstance]postDataWithUrl:saveUpCoinApplyAPI Parameter:params ResponseObject:^(NSDictionary *responseResult) {
        StrongSelf(strongSelf)
        [strongSelf.view makeToast:responseResult[MESSAGE] duration:ToastHideDelay position:ToastPosition];
        if (NetSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastHideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            ErrorToast
        }
    }];
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
