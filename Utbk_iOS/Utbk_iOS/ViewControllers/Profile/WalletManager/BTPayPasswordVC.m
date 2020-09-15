//
//  BTPayPasswordVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTPayPasswordVC.h"

@interface BTPayPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@end

@implementation BTPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"支付密码");
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)setInputSecrity:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 103:
            self.passwordNew.secureTextEntry = sender.selected;
            break;
         case 104:
            self.passwordSecond.secureTextEntry = sender.selected;
            break;
        default:
            break;
    }
}
- (IBAction)completedAction:(UIButton *)sender {
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
