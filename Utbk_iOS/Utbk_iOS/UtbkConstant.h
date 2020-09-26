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

#define USERINFO @"USERINFO"
//自定义block
typedef void(^ResultBlock)(id resultObject,int isSuccessed);
//网络成功
#define NetSuccess [responseResult[@"code"]integerValue] == 0
#define ErrorToast if ([responseResult.allKeys containsObject:@"resError"]) {\
    NSError *error = responseResult[@"resError"];\
    [BTKeyWindow makeToast:error.localizedDescription duration:ToastHideDelay position:ToastPosition];\
}else{[BTKeyWindow makeToast:responseResult[@"message"] duration:ToastHideDelay position:ToastPosition];\
}

#define MESSAGE @"message"
#define LocalLanguageKey         @"LocalLanguageKey" //选择语言（0代表简体中文，1代表繁体中文，2代表英文）
#define LanguageChange           @"LanguageChange" //切换语言
#define LocalizationKey(key)     [[ChangeLanguage bundle] localizedStringForKey:key value:nil table:@"Localizable"]
//[NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
#define INT2STRING(intValue) [NSString stringWithFormat:@"%d", intValue]
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
//#define mainColor    RGBOF(0xF0F0F0)
#define mainColor  RGBOF(0x1F2833)
#define baseColor  NavColor
#define ViewBackgroundColor  kRGBColor(18,22,28)
#define AppTextColor  RGBOF(0x333333)
#define AppTextColor_999999  RGBOF(0x999999)
#define AppTextColor_666666  RGBOF(0x666666)
#define AppTextColor_E6E6E6  RGBOF(0xE6E6E6)
#define RedColor   RGBOF(0xF15057)   //红跌
#define GreenColor RGBOF(0x00B275)  //绿涨
//通过RGB设置颜色
#define kRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(1.f)]
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
#define kWindowHOne    [UIScreen mainScreen].bounds.size.height / 667 //应用程序的屏幕单位高度
#define kWindowWHOne    [UIScreen mainScreen].bounds.size.width / 375 //应用程序的屏幕单位宽度

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\
// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

#define ToastHideDelay 1.f
#define ToastPosition @"center"

#define KPageSize 20
#define SOCKETTERMINAL           @"1002";  //安卓:1001,苹果:1002,WEB:1003,PC:1004
#define SHOWCNY                  @"isShowCNY"//显示为人民币
#define CURRENTSELECTED_SYMBOL  @"CURRENTSELECTED_SYMBOL"//当前选择的交易对

#define SUBSCRIBE_SYMBOL  @"SUBSCRIBE_SYMBOL_THUMB"
#define SUBSCRIBE_KLINE  @"SUBSCRIBE_SYMBOL_KLINE"
#define SUBSCRIBE_EXCHANGE  @"SUBSCRIBE_EXCHANGE_TRADE"
#define HIDEMONEY   @"HIDEMONEY" //是否隐藏总金额
#define BIGGER   @"BIGGER" //放大K线视图(全屏)
#define SMALL   @"SMALL" //缩小K线视图(非全屏)

#define KMnemonicWords  @"__KMnemonicWords__"
#define KfirstLogin @"__firstLogin__"
#define KTempSecretKey @"asdfawsdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf"//临时作为调试用的秘钥，调试矿池用

//对应的贡献值很多地方用到100去处理因此定义出来方便以后扩展
#define KContributionValue 100

static  int    COMMANDS_VERSION = 1;
static  short  SUBSCRIBE_SYMBOL_THUMB = 20001; //订阅缩略行情
static  short  UNSUBSCRIBE_SYMBOL_THUMB = 20002;//取消订阅
static  short  PUSH_SYMBOL_THUMB = 20003;
// static  short  SUBSCRIBE_SYMBOL_KLINE = 20011; //订阅K线
// static  short  UNSUBSCRIBE_SYMBOL_KLINE = 20012;
// static  short  PUSH_SYMBOL_KLINE = 20013;
static  short  SUBSCRIBE_EXCHANGE_TRADE = 20021; //订阅盘口信息
static  short  UNSUBSCRIBE_EXCHANGE_TRADE = 20022;
static  short  PUSH_EXCHANGE_TRADE = 20023;//成交记录
static  short  PUSH_EXCHANGE_PLATE = 20024;
static  short  PUSH_EXCHANGE_KLINE = 20025;//k线
static  short  PUSH_EXCHANGE_ORDER_COMPLETED = 20026;//当前委托完成
static  short  PUSH_EXCHANGE_ORDER_CANCELED = 20027;//当前委托取消
static  short  PUSH_EXCHANGE_ORDER_TRADE = 20028;//当前委托变化
static  short  SUBSCRIBE_CHAT = 20031;//订阅聊天
static  short  UNSUBSCRIBE_CHAT = 20032;
static  short  PUSH_CHAT = 20033;
static  short  SEND_CHAT = 20034;//发送聊天
static  short  SUBSCRIBE_GROUP_CHAT = 20035; //订阅组聊天
static  short  UNSUBSCRIBE_GROUP_CHAT = 20036; //取消订阅组聊天
static  short  SUBSCRIBE_APNS = 20037; //订阅APNS
static  short  UNSUBSCRIBE_APNS = 20038;
static  short  PUSH_GROUP_CHAT = 20039;
static  short  PUSH_EXCHANGE_DEPTH = 20029;//深度图
static  short  HEARTBEAT = 11004; //心跳包指令
static  int    SOCKETREQUEST_LENGTH = 26;//消息头固定字节长度
static  int    SOCKETRESPONSE_LENGTH = 22;//响应头固定字节长度
