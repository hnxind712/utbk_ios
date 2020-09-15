//
//  BTModifyTradePasswordVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTModifyTradePasswordVC.h"

@interface BTModifyTradePasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;

@end

@implementation BTModifyTradePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    if (self.passwordSecond.text.length && self.passwordNew.text.length && self.passwordOld.text.length) {
        self.completedBtn.userInteractionEnabled = YES;
        self.completedBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.completedBtn.userInteractionEnabled = YES;
        self.completedBtn.backgroundColor = RGBOF(0xcccccc);
    }
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (checkStr.length && _textfield.text.length && self.textView.text.length) {
//        self.createBtn.userInteractionEnabled = YES;
//        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
//    }else{
//        self.createBtn.userInteractionEnabled = YES;
//        self.createBtn.backgroundColor = RGBOF(0xcccccc);
//    }
    return YES;
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
