//
//  BTProfileViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTProfileViewController.h"
#import "BTWalletManagerVC.h"//钱包管理列表
#import "BTTeamHoldViewController.h"//团队业绩
#import <TZImagePickerController/TZImagePickerController.h>
#import "BTSettingViewController.h"//设置
#import "BTShareWalletVC.h"//分享
#import "MineNetManager.h"
#import "BTAssetsModel.h"
#import "BTBackupMnemonicsVC.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface BTProfileViewController ()<TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (strong, nonatomic) UIImageView *navgationBg;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightNavigation];
    [self setupBind];
    self.navigationItem.title = LocalizationKey(@"个人中心");
    // Do any additional setup after loading the view from its nib.
}
- (void)addRightNavigation{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:BTUIIMAGE(@"icon_settings") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)settingAction{
    BTSettingViewController *withdrawRecord = [[BTSettingViewController alloc]init];
    [self.navigationController pushViewController:withdrawRecord animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:BTUIIMAGE(@"icon_profileTopbg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:RGBOF(0xffffff)}];
    [self setupBind];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:AppTextColor}];
    
}
- (IBAction)copyAction:(UIButton *)sender {
}
- (void)setupBind{
    self.walletName.text = [YLUserInfo shareUserInfo].username;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:[YLUserInfo shareUserInfo].avatar] forState:UIControlStateNormal placeholderImage:BTUIIMAGE(@"icon_profileUser")];
//    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:[YLUserInfo shareUserInfo].avatar] forState:UIControlStateNormal];
    if (![YLUserInfo shareUserInfo].address) {
        WeakSelf(weakSelf)
        [MineNetManager getMyWalletInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
            if (NetSuccess) {
                NSArray *dataArr = [BTAssetsModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
                for (BTAssetsModel *walletModel in dataArr) {
                    if ([walletModel.coin.unit isEqualToString:KOriginalCoin]) {//个人中心显示BTCK的地址
                        StrongSelf(strongSelf)
                        YLUserInfo *info = [YLUserInfo shareUserInfo];
                        if (!info.address.length) {
                            info.address = walletModel.address;
                            [YLUserInfo saveUser:info];
                        }
                        strongSelf.address.text = walletModel.address;break;
                    }
                }
            }else{
                ErrorToast
            }
        }];
    }else{
        self.address.text = [YLUserInfo shareUserInfo].address;
    }
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
    NSString *str = @"uc/upload/oss/image";
    NSString *urlString=[HOST stringByAppendingString:str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlString parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = imageData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        if ([responseObject[@"code"] integerValue] == 0) {
            [self headImage:responseObject[@"data"]];
        }else{
            [self.view makeToast:responseObject[MESSAGE] duration:ToastHideDelay position:ToastPosition];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:ToastHideDelay position:ToastPosition];
    }];
}
//MARK:--设置头像
-(void)headImage:(NSString *)urlString{
    [MineNetManager setHeadImageForUrl:urlString CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //设置头像成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:ToastHideDelay position:ToastPosition];
                [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal];
                YLUserInfo *info = [YLUserInfo shareUserInfo];
                info.avatar = urlString;
                [YLUserInfo saveUser:info];
                NSMutableArray *array = [NSMutableArray array];
                //取出
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSData *listData = [userDefaults  objectForKey:KWalletManagerKey];
                NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
                [array addObjectsFromArray:list];
                [array enumerateObjectsUsingBlock:^(YLUserInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.username isEqualToString:info.username]) {
                        obj.avatar = urlString;*stop = YES;
                    }
                }];
                //存
                NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
                [[NSUserDefaults standardUserDefaults]setObject:arrayData forKey:KWalletManagerKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:ToastPosition];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"网络连接失败") duration:1.5 position:ToastPosition];
        }
    }];
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
    [self.navigationController pushViewController:wallet animated:YES];
}
//团队业绩
- (IBAction)teamAchievementAction:(UITapGestureRecognizer *)sender {
    BTTeamHoldViewController *team = [[BTTeamHoldViewController alloc]init];
    [self.navigationController pushViewController:team animated:YES];
}
//社区客服
- (IBAction)communityServiceAction:(UITapGestureRecognizer *)sender {
    [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
}
//开源地址
- (IBAction)openSourceAddressAction:(UITapGestureRecognizer *)sender {
    [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
}
//提币地址
- (IBAction)withdrawAddressAction:(UITapGestureRecognizer *)sender {
    [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
}
//分享APP
- (IBAction)shareAppAction:(UITapGestureRecognizer *)sender {
    BTShareWalletVC *share = [[BTShareWalletVC alloc]init];
    [self.navigationController pushViewController:share animated:YES];
}
//帮助中心
- (IBAction)helpCenterAction:(UITapGestureRecognizer *)sender {
    [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
}
//区块链浏览
- (IBAction)blockChainsAction:(UITapGestureRecognizer *)sender {
    [self.view makeToast:LocalizationKey(@"暂未开放") duration:ToastHideDelay position:ToastPosition];
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
