//
//  BTCommonUtils.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCommonUtils : NSObject

//生成带logo的二维码
+ (UIImage *)logoQrCode:(UIImage *)image code:(NSString *)code;

+ (UIImage *)createQRCodeWithUrl:(NSString *)url image:(UIImage *)logo size:(CGFloat)size;

//截屏
+ (UIImage *)screenShot:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
