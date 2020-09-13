//
//  BTCreateWalletVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTCreateWalletVC.h"

@interface BTCreateWalletVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordSecond;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceh;
@end

@implementation BTCreateWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.textViewPlaceh.hidden = textView.text.length == 0 ? NO : YES;
    if (textView.text.length && self.passwordSecond.text.length && self.password.text.length) {
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xcccccc);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    UITextField *_textfield = textField == self.password ? self.passwordSecond : self.password;
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (checkStr.length && _textfield.text.length && self.textView.text.length) {
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xDAC49D);
    }else{
        self.createBtn.userInteractionEnabled = YES;
        self.createBtn.backgroundColor = RGBOF(0xcccccc);
    }
    return YES;
}

- (IBAction)showPasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 103:
            self.password.secureTextEntry = sender.selected;
            break;
            case 104:
            self.passwordSecond.secureTextEntry = sender.selected;
            break;
        default:
            break;
    }
}

//确认创建
- (IBAction)createAction:(UIButton *)sender {
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
