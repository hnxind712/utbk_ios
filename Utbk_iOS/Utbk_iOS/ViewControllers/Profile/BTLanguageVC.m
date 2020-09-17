//
//  BTLanguageVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTLanguageVC.h"

@interface BTLanguageVC ()
@property (weak, nonatomic) IBOutlet UIButton *simplifiedChineseBtn;
@property (weak, nonatomic) IBOutlet UIButton *traditionalChineseBtn;
@property (weak, nonatomic) IBOutlet UIButton *englishBtn;
@property (strong, nonatomic) UIButton *selectedBtn;

@end

@implementation BTLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"设置");
    self.selectedBtn = self.simplifiedChineseBtn;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changeLanguageAction:(UIButton *)sender {
    if (self.selectedBtn == sender) return;
    sender.selected = YES;
    self.selectedBtn = sender;
    switch (sender.tag) {
        case 100:
            self.traditionalChineseBtn.selected = NO;
            self.englishBtn.selected = NO;
            [ChangeLanguage setUserlanguage:@"zh-Hans"];
            break;
        case 101:
            self.simplifiedChineseBtn.selected = NO;
            self.traditionalChineseBtn.selected = NO;
            [ChangeLanguage setUserlanguage:@"en"];
            break;
        default:
            break;
    }
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
