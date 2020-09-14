//
//  BTBackupMnemonicsCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/14.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTBackupMnemonicsCell.h"

@implementation BTBackupMnemonicsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithMnemonicsModel:(id)model{
    self.mnemonics.text = model;
}
@end
