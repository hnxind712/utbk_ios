//
//  BTSharePoolCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/26.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTSharePoolCell : UITableViewCell

@property (strong, nonatomic) NSArray *starArray;

- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
