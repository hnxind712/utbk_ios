//
//  AppDelegate.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommonVoidBlock)(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//交易类目中需要
@property(nonatomic,strong)NSDecimalNumber* CNYRate;
@property (nonatomic, assign) BOOL isEable;

+ (instancetype)sharedAppDelegate;
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;
@end

