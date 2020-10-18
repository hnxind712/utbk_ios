//
//  BTWalletPopView.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,KWalletType){
    KWalletTypeModifyWalletName = 0,
    KWalletTypeBackUpMnemonicWord,//备份助记词
    KWalletTypeExportPrivateKey,//导出秘钥
    KWalletTypeCopyPrivateKey//复制秘钥
};
@interface BTWalletPopView : UIView

@property (strong, nonatomic) YLUserInfo *userInfo;

@property (copy, nonatomic) void(^comfirmAction)(KWalletType wallteType, NSString *string);

- (void)show:(KWalletType)walletType;

@end

NS_ASSUME_NONNULL_END
