//
//  BTHomeNoticeView.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTHomeNoticeView : UIView

@property (copy, nonatomic) void(^noticeMoreAction)(void);

- (void)configureNoticeViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
