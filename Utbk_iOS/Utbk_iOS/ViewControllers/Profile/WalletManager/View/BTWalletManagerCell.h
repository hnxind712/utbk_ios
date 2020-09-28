//
//  BTWalletManagerCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTWalletManagerCell : UITableViewCell

@property (copy, nonatomic) void(^walletDetailAction)(void);
@property (copy, nonatomic) void(^switchAccountAction)(void);

- (void)configureWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
