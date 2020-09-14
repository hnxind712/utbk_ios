//
//  BTBackupMnemonicsCell.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBackupMnemonicsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mnemonics;

- (void)configureCellWithMnemonicsModel:(id)model;

@end

NS_ASSUME_NONNULL_END
