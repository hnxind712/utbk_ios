//
//  KLinePeriodView.h
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowMore)(BOOL);
typedef void(^ShowMain)(void);
typedef void(^ShowScreen)(BOOL);

@interface KLinePeriodView : UIView
@property (nonatomic, copy) ShowMore showMore;
@property (nonatomic, copy) ShowMain showMain;
@property (nonatomic, copy) ShowScreen showScreen;
+(KLinePeriodView *)linePeriodView;
@end



NS_ASSUME_NONNULL_END
