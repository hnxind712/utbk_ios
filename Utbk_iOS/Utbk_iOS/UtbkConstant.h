//
//  UtbkConstant.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#ifndef UtbkConstant_h
#define UtbkConstant_h


#endif /* UtbkConstant_h */

//自定义block
typedef void(^ResultBlock)(id resultObject,int isSuccessed);

#define LocalLanguageKey         @"LocalLanguageKey" //选择语言（0代表简体中文，1代表繁体中文，2代表英文）
#define LocalizationKey(key)     [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
//[[ChangeLanguage bundle] localizedStringForKey:key value:nil table:@"English"]
//图片
#define BTUIIMAGE(name) [UIImage imageNamed:name]
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(strongSelf) __strong __typeof(&*self)strongSelf = weakSelf;
//主色调
#define MainBackColor [UIColor whiteColor]
#define BackColor  RGBOF(0xEEEEEE)
#define BlackTextColor  RGBOF(0x333333)
#define GrayTextColor  RGBOF(0x999999)
#define NavColor    RGBOF(0xF0F0F0)
#define AppTextColor_333333   RGBOF(0x333333)
//#define mainColor  RGBOF(0x3399FF)
#define mainColor  RGBOF(0x1F2833)
#define baseColor  NavColor
#define ViewBackgroundColor  kRGBColor(18,22,28)
#define AppTextColor  RGBOF(0x333333)
#define AppTextColor_999999  RGBOF(0x999999)
#define AppTextColor_666666  RGBOF(0x666666)
#define AppTextColor_E6E6E6  RGBOF(0xE6E6E6)
//通过RGB设置颜色
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
/** 色值 RGB **/
#define HEXCOLOR(color)     [UIColor colorWithHexColorString:color]

#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)
#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define  IS_iPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

// 状态栏高度
#define StatusBarHeight (IS_iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NavBarHeight (44.f+StatusBarHeight)
// 导航栏高度 + 状态栏高度
#define LSNavBar_StatuBarHeight  (StatusBarHeight + NavBarHeight)
// 底部标签栏高度
#define TabBarHeight (IS_iPhoneX ? (49.f+34.f) : 49.f)
// 安全区域高度
#define TabbarSafeBottomMargin     (IS_iPhoneX ? 34.f : 0.f)

//keyWindow
#define BTKeyWindow [AppDelegate sharedAppDelegate].window
// 屏幕rect
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/375.0

#define ToastHideDelay 1.f
#define ToastPosition @"center"
