//
//  BTShareSecondVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTShareSecondVC.h"
#import <Photos/Photos.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>

@interface BTShareSecondVC ()
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UIView *shareView;//需要截屏的视图

@end

@implementation BTShareSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBind];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
// 返回你所需要的状态栏样式
    return UIStatusBarStyleLightContent;
}
- (void)setupBind{
    self.qrcodeImageView.image = [BTCommonUtils createQRCodeWithUrl:self.url image:nil size:self.qrcodeImageView.bounds.size.width];
    //[BTCommonUtils logoQrCode:BTUIIMAGE(@"icon_registerLogo") code:self.url];
}
- (IBAction)shareAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100://微信
        case 101:
        {
            UIImage *image = [BTCommonUtils screenShot:self.shareView];
             UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[image]
                                                    
                                                                                    applicationActivities:nil];
            
            //不出现在活动项目
            activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                                 
                                                 UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
            
            [self presentViewController:activityVC animated:TRUE completion:nil];
        }
            break;
        case 102://复制链接
        {
            if (!_url.length) {
                [BTKeyWindow makeToast:LocalizationKey(@"地址为空") duration:ToastHideDelay position:ToastPosition];return;
            }
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.url;
            [self.view makeToast:LocalizationKey(@"复制成功") duration:ToastHideDelay position:ToastPosition];
        }
            break;
        case 103://保存本地
        {
            UIImage *image = [BTCommonUtils screenShot:self.shareView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    //写入图片到相册
                    [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    NSString *msg;
                    if (success) {
                        msg = LocalizationKey(@"保存成功");
                    }else
                        msg = LocalizationKey(@"保存失败");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:msg duration:ToastHideDelay position:ToastPosition];
                    });
                }];
            });
        }
            break;
        default:
            break;
    }
}
/**
 //分享相关的代码
 //截屏
 UIImage *image = [LSCommonUtil screenShot:self.currentShowView];
 [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),
 @(UMSocialPlatformType_WechatTimeLine)]];
 [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
       UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
         //创建图片内容对象
         UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
         //如果有缩略图，则设置缩略图本地
         shareObject.thumbImage = image;
         [shareObject setShareImage:image];
         //分享消息对象设置分享内容对象
         messageObject.shareObject = shareObject;
         //调用分享接口
         [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
             if (error) {
                 UMSocialLogInfo(@"************Share fail with error %@*********",error);
             }else{
                 if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                     UMSocialShareResponse *resp = data;
                     //分享结果消息
                     UMSocialLogInfo(@"response message is %@",resp.message);
                     //第三方原始返回的数据
                     UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                     
                 }else{
                     UMSocialLogInfo(@"response data is %@",data);
                 }
             }
         }];
 }];
 
 */
- (IBAction)cancleAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
