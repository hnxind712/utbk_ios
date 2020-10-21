//
//  BTShareWalletVC.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTShareWalletVC.h"
#import "BTShareSecondVC.h"
#import "MineNetManager.h"
#import "VersionUpdateModel.h"

@interface BTShareWalletVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (strong, nonatomic) VersionUpdateModel *model;

@end

@implementation BTShareWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self versionUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
}
//MARK:--版本更新接口请求
-(void)versionUpdate{
    WeakSelf(weakSelf)
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                VersionUpdateModel *versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                weakSelf.model = versionModel;
                [weakSelf setupBind];
            }
        }
    }];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
// 返回你所需要的状态栏样式
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //黑色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //黑色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (void)viewDidDisappear:(BOOL)animated{
    
}
- (void)setupBind{
    self.codeImageView.image = [BTCommonUtils createQRCodeWithUrl:self.model.downloadUrl image:nil size:self.codeImageView.bounds.size.width];
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(UIButton *)sender {
    BTShareSecondVC *share = [[BTShareSecondVC alloc]init];
    share.url = self.model.downloadUrl;
    share.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:share animated:YES completion:nil];
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
