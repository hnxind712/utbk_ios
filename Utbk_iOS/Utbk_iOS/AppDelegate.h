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

+ (instancetype)sharedAppDelegate;

@end

