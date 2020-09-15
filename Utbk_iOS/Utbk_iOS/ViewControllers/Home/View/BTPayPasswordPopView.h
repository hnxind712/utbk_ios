//
//  BTPayPasswordPopView.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTPayPasswordPopView : UIView

@property (copy, nonatomic) void(^setPayPasswordAction)(void);

- (void)show;

@end

NS_ASSUME_NONNULL_END
