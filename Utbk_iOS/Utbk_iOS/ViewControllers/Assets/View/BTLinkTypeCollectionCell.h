//
//  BTLinkTypeCollectionCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/24.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLinkTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTLinkTypeCollectionCell : UICollectionViewCell

- (void)configureCellWithModel:(BTLinkTypeModel *)model;

@end

NS_ASSUME_NONNULL_END
