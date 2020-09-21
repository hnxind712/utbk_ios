//
//  BTMnemonisConfirmCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/16.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTMnemonisConfirmCell.h"
#import "BTMnemonisModel.h"

@interface BTMnemonisConfirmCell ()
@property (weak, nonatomic) IBOutlet UIButton *mnemonisBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
@implementation BTMnemonisConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTMnemonisListModel *)model{
    [_mnemonisBtn setTitle:model.mnemonis forState:UIControlStateNormal];
    if (self.isSelected) {
        _deleteBtn.hidden = NO;
        _mnemonisBtn.backgroundColor = [RGBOF(0xA78659)colorWithAlphaComponent:0.2];
        [_mnemonisBtn setTitleColor:RGBOF(0xA78659) forState:UIControlStateNormal];
    }else{
        _deleteBtn.hidden = YES;
        if (model.selected) {
            _mnemonisBtn.selected = YES;
            _mnemonisBtn.backgroundColor = [RGBOF(0xA78659)colorWithAlphaComponent:0.1];
            [_mnemonisBtn setTitleColor:RGBOF(0xffffff) forState:UIControlStateNormal];
        }else{
            _mnemonisBtn.selected = NO;
            _mnemonisBtn.backgroundColor = [RGBOF(0xA78659)colorWithAlphaComponent:0.2];
            [_mnemonisBtn setTitleColor:RGBOF(0xA78659) forState:UIControlStateNormal];
        }
    }
    
}
- (IBAction)deleteSelectedMnemonis:(UIButton *)sender {
    if (self.deleteSelectedMnemonisAction) {
        self.deleteSelectedMnemonisAction();
    }
}

@end
