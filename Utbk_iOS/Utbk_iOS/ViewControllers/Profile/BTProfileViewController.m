//
//  BTProfileViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTProfileViewController.h"
#import "BTWalletManagerVC.h"//钱包管理列表
#import "BTTeamAchievementVC.h"//团队业绩
#import <TZImagePickerController/TZImagePickerController.h>


#import "BTBackupMnemonicsVC.h"
@interface BTProfileViewController ()<TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *navgationBg;

@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:BTUIIMAGE(@"icon_profileTopbg") forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];;
}
- (void)selectImageWithTZImagePickerController{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowTakePicture = NO;
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowTakeVideo = NO;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)pushTZImagePickerController {
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowTakePicture = YES;
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowTakeVideo = NO;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    WeakSelf(weakSelf)
    UIImage *image = photos.firstObject;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
//    [LSAppInfo uploadFile:imageData size:0 qnUploadType:QiniuUploadFileTypeImage progress:^(CGFloat percent) {
//
//    }  success:^(NSString *uid,NSDictionary *resp) {
//        if (uid) {
//            [[AFAppDotNetAPIClient sharedClient]POST:ProfileEditAvatarAPI parameters:@{@"avatarUid":_LSS(uid)} success:^(id  _Nullable responseObject) {
//                if (NetSuccess) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        StrongSelf(strongSelf)
//                        [strongSelf.portriatButton setImage:image forState:UIControlStateNormal];
//                        [MBProgressHUD bwm_showTitle:@"上传成功" toView:LSKeyWindow hideAfter:2.f];
//                    });
//                }else{
//                    [MBProgressHUD bwm_showTitle:@"上传失败" toView:LSKeyWindow hideAfter:2.f];
//                }
//            } failure:^(NSError * _Nonnull error) {
//                [MBProgressHUD bwm_showTitle:@"网络请求失败" toView:LSKeyWindow hideAfter:2.f];
//            }];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [MBProgressHUD bwm_showTitle:error.localizedDescription toView:LSKeyWindow hideAfter:2.f];
//    }];
}
#pragma mark actions
//头像点击事件
- (IBAction)userHeadClickAction:(UIButton *)sender {
    WeakSelf(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //LocalizationKey(@"取消")
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    //LocalizationKey(@"拍照")
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        StrongSelf(strongSelf)
        [strongSelf pushTZImagePickerController];
    }];
    //LocalizationKey(@"从相册中选择")
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        StrongSelf(strongSelf)
        [strongSelf selectImageWithTZImagePickerController];
    }];
    [alert addAction:cancleAction];
    [alert addAction:shootAction];
    [alert addAction:selectAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//钱包管理
- (IBAction)walletManagerAction:(UITapGestureRecognizer *)sender {
    BTWalletManagerVC *wallet = [[BTWalletManagerVC alloc]init];
    wallet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wallet animated:YES];
}
//团队业绩
- (IBAction)teamAchievementAction:(UITapGestureRecognizer *)sender {
    BTTeamAchievementVC *team = [[BTTeamAchievementVC alloc]init];
    team.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:team animated:YES];
}
//社区客服
- (IBAction)communityServiceAction:(UITapGestureRecognizer *)sender {
    BTBackupMnemonicsVC *mnemonics = [[BTBackupMnemonicsVC alloc]init];
    mnemonics.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mnemonics animated:YES];
}
//开源地址
- (IBAction)openSourceAddressAction:(UITapGestureRecognizer *)sender {
}
//提币地址
- (IBAction)withdrawAddressAction:(UITapGestureRecognizer *)sender {
}
//分享APP
- (IBAction)shareAppAction:(UITapGestureRecognizer *)sender {
}
//帮助中心
- (IBAction)helpCenterAction:(UITapGestureRecognizer *)sender {
}
//区块链浏览
- (IBAction)blockChainsAction:(UITapGestureRecognizer *)sender {
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
