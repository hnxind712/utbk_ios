//
//  BTSettingViewController.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTSettingViewController.h"
#import "BTLanguageVC.h"
#import <SDWebImage/SDImageCache.h>

@interface BTSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *language;
@property (weak, nonatomic) IBOutlet UILabel *caches;

@end

@implementation BTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"设置");
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] totalDiskSize];

    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float MBCache = bytesCache/1000.00/1000.00;
    if (MBCache < 1) {//说明是kb
        _caches.text = [NSString stringWithFormat:@"%.2fKB",MBCache * 1000];
    }else{
        _caches.text = [NSString stringWithFormat:@"%.2fMB",MBCache];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    NSString *language = [ChangeLanguage userLanguage];
    if ([language isEqualToString:@"en"]) {
        _language.text = LocalizationKey(@"Englishi");
    }else if ([language isEqualToString:@"zh-Hans"]){
        _language.text = LocalizationKey(@"简体中文");
    }
}
//设置语言
- (IBAction)setLanguageAction:(id)sender {
    BTLanguageVC *language = [[BTLanguageVC alloc]init];
    [self.navigationController pushViewController:language animated:YES];
}
//清除缓存
- (IBAction)cleanCacheAction:(UITapGestureRecognizer *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        self->_caches.text = @"0.00KB";
    });
}
//关于我们
- (IBAction)aboutUsAction:(UITapGestureRecognizer *)sender {
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
