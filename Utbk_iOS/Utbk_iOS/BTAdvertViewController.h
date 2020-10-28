//
//  BTAdvertViewController.h
//  Utbk_iOS
//
//  Created by heyong on 2020/10/28.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAdvertViewController : BTBaseViewController

@property (copy, nonatomic) void(^skipAction)(void);

@end

NS_ASSUME_NONNULL_END
