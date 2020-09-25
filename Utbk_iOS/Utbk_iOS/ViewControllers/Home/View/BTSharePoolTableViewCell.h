//
//  BTSharePoolTableViewCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/20.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTSharePoolTableViewCell : UITableViewCell

@property (assign, nonatomic) NSInteger type;//1为贡献，2为收益

- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
