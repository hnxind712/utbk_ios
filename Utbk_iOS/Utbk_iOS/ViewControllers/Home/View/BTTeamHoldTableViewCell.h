//
//  BTTeamHoldTableViewCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/19.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTeamHoldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
- (void)configureCellWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
