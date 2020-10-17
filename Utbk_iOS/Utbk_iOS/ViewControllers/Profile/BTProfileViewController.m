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
#import "LSAppBrowserViewController.h"
#import <V5Client/V5ClientAgent.h>
#import "IQKeyboardManager.h"

#define KBlockScanURL @"https://tronscan.io/"

@interface BTProfileViewController ()<TZImagePickerControllerDelegate,V5ChatViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (strong, nonatomic) UIImageView *navgationBg;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
@property (weak, nonatomic) IBOutlet UILabel *address;
//从上到下Label1-Label7,命名只是为了处理多语言
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;
@property (weak, nonatomic) IBOutlet UILabel *Label4;
@property (weak, nonatomic) IBOutlet UILabel *Label5;
@property (weak, nonatomic) IBOutlet UILabel *Label6;
@property (weak, nonatomic) IBOutlet UILabel *Label7;

@end

@implementation BTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightNavigation];
    [self setupBind];
    self.navigationItem.title = LocalizationKey(@"个人中心");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetLocalization) name:LanguageChange object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)resetLocalization{
    self.Label1.text = LocalizationKey(@"钱包管理");
    self.Label2.text = LocalizationKey(@"团队业绩");
    self.Label3.text = LocalizationKey(@"社区客服");
    self.Label4.text = LocalizationKey(@"开源地址");
    self.Label5.text = LocalizationKey(@"分享APP");
    self.Label6.text = LocalizationKey(@"帮助中心");
    self.Label7.text = LocalizationKey(@"区块链浏览");
    self.navigationItem.title = LocalizationKey(@"个人中心");
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:RGBOF(0xffffff)}];
    [self setupBind];
    [self resetLocalization];
    if ([V5ClientAgent shareClient].isConnected) {
        [[V5ClientAgent shareClient] stopClient];
    }
}
/**
 *  即将打开会话视图
 */
- (void)clientViewWillAppear {
    //取消输入键盘插件
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

/**
 *  会话视图打开后
 */
- (void)clientViewDidAppear {
}

/**
 *  即将关闭会话视图
 */
- (void)clientViewWillDisappear {
    //开启输入键盘插件
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)onClientViewConnect{
    [[V5ClientAgent shareClient] updateSiteInfo];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.f],NSForegroundColorAttributeName:AppTextColor}];
    
}
- (IBAction)copyAction:(UIButton *)sender {
    if (!self.address.text.length) {
        [BTKeyWindow makeToast:LocalizationKey(@"地址为空") duration:ToastHideDelay position:ToastPosition];return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.address.text;
    [self.view makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];
}
- (void)setupBind{
    self.walletName.text = [YLUserInfo shareUserInfo].username;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:[YLUserInfo shareUserInfo].avatar] forState:UIControlStateNormal placeholderImage:BTUIIMAGE(@"icon_profileUser")];
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
    [[XBRequest sharedInstance]postDataWithUrl:getMemberStatusAPI Parameter:@{@"memberId":_BTS([YLUserInfo shareUserInfo].ID)} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            YLUserInfo *info = [YLUserInfo shareUserInfo];
            info.activeStatus = [responseResult[@"data"][@"status"] isKindOfClass:[NSNull class]] ? 0 : [responseResult[@"data"][@"status"] integerValue];
            [YLUserInfo saveUser:info];
            self.activeBtn.backgroundColor = (info.activeStatus == 1 || info.activeStatus == 2)  ? RGBOF(0xDAC49D) : RGBOF(0xcccccc);
            [self.activeBtn setTitle:(info.activeStatus == 1 || info.activeStatus == 2) ? LocalizationKey(@"已激活") : LocalizationKey(@"未激活") forState:UIControlStateNormal];
            [self.activeBtn setTitleColor:(info.activeStatus == 1 || info.activeStatus == 2) ? RGBOF(0x786236) : RGBOF(0x333333) forState:UIControlStateNormal];
        }
    }];
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
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:LocalizationKey(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    //LocalizationKey(@"拍照")
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:LocalizationKey(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        StrongSelf(strongSelf)
        [strongSelf pushTZImagePickerController];
    }];
    //
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:LocalizationKey(@"从相册中选择") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
    
    //创建成功之后，部署个人信息要客服
    V5Config *config = [V5ClientAgent shareClient].config;
    [config shouldUpdateUserInfo];
    config.nickname = [YLUserInfo shareUserInfo].username;
    config.gender = 0; //性别:0-未知 1-男 2-女
    config.openId = [YLUserInfo shareUserInfo].ID;
    config.avatar = _BTS([YLUserInfo shareUserInfo].avatar);
    config.deviceToken = _BTS([[NSUserDefaults standardUserDefaults]objectForKey:@"_deviceToken_"]);
    
    V5ChatViewController *chatViewController = [V5ClientAgent createChatViewController];
    // 不显示底部栏（有底部栏的需加此配置）
    chatViewController.hidesBottomBarWhenPushed = YES;
    // 会话界面的代理
    chatViewController.delegate = self;
    //chatViewController.deviceToken = @"设备的deviceToken"; // 也可在config设置deviceToken
    // 允许并设置消息铃声SystemSoundID
    chatViewController.allowSound = YES;
    chatViewController.soundID = 1007;
    // 允许发送语音(默认YES)
    chatViewController.enableVoiceRecord = YES;
    // 允许显示头像(默认YES)
    chatViewController.showAvatar = YES;
    // 头像圆角
    chatViewController.avatarRadius = 6;
    
    // 每次下拉获取历史消息最大数量，默认10
    //chatViewController.numOfMessagesOnRefresh = 10;
    // 开场显示历史消息数量，默认10（显示历史消息>0则无开场白）
    chatViewController.numOfMessagesOnOpen = 10;
    
    // 设置会话界面标题
    chatViewController.title = LocalizationKey(@"社区客服"); // 设置标题
    [self.navigationController pushViewController:chatViewController animated:YES];
    

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
    LSAppBrowserViewController *browser = [[LSAppBrowserViewController alloc]init];
    browser.urlString = KBlockScanURL;
    [self.navigationController pushViewController:browser animated:YES];
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
