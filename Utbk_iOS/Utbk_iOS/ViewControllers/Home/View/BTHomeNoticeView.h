//
//  BTHomeNoticeView.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BTNoticeModel;

@interface BTHomeNoticeView : UIView

@property (copy, nonatomic) void(^noticeMoreAction)(void);

@property (copy, nonatomic) void(^noticeDetailAction)(BTNoticeModel *model);

- (void)configureNoticeViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
