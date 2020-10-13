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
#import "MineNetManager.h"
#import "VersionUpdateModel.h"
#import "BTUpdateVersionView.h"

@interface BTSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *language;
@property (weak, nonatomic) IBOutlet UILabel *caches;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (strong, nonatomic) BTUpdateVersionView *versionView;//版本更新
@property (weak, nonatomic) IBOutlet UILabel *aboutUs;
@property (weak, nonatomic) IBOutlet UILabel *clearCache;
@property (weak, nonatomic) IBOutlet UILabel *languagesL;
@property (strong, nonatomic) VersionUpdateModel *versionModel;

@end

@implementation BTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBind];
    [self resetLocalization];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetLocalization) name:LanguageChange object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)resetLocalization{
    self.title = LocalizationKey(@"setting");
    self.languagesL.text = LocalizationKey(@"多语言");
    self.clearCache.text = LocalizationKey(@"清除缓存");
    self.aboutUs.text = LocalizationKey(@"关于我们");
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
    [self versionUpdate];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_caches.text = @"0.00KB";
        });
    });
}
//关于我们
- (IBAction)aboutUsAction:(UITapGestureRecognizer *)sender {
    // app当前版本
    if (self.versionModel) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"app_Version ---- %@",app_Version);
        if ([app_Version compare:self.versionModel.version] == NSOrderedAscending ){
            self.versionView  = [BTUpdateVersionView show];
            [self.versionView configureViewWithVersion:self.versionModel.version content:self.versionModel.remark];
            self.versionView.updateAction = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.versionModel.downloadUrl]];
                });
            };
        }
    }
}
//MARK:--版本更新接口请求
-(void)versionUpdate{
    WeakSelf(weakSelf)
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                VersionUpdateModel *versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                weakSelf.versionModel = versionModel;
                weakSelf.version.text = [NSString stringWithFormat:@"V%@",versionModel.version];
            }
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
