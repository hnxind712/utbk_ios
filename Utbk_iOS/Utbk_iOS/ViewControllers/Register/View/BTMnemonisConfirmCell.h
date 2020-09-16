//
//  BTMnemonisConfirmCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTMnemonisConfirmCell : UICollectionViewCell

@property (assign, nonatomic) BOOL isSelected;//是否为已标记的
@property (copy, nonatomic) void(^deleteSelectedMnemonisAction)(void);

- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
