//
//  BTHomeNoticeCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTHomeNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet UILabel *noticeMessage;
@property (weak, nonatomic) IBOutlet UIView *redView;

- (void)configureCellWithNoticeModel:(id)model;

@end

NS_ASSUME_NONNULL_END
