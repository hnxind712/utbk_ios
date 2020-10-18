//
//  BTNoticePopView.h
//  Utbk_iOS
//
//  Created by heyong on 2020/10/18.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTNoticeModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTNoticePopView : UIView

- (void)show:(BTNoticeModel *)model;

@end

NS_ASSUME_NONNULL_END
