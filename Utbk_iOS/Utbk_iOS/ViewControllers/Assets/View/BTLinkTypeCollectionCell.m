//
//  BTLinkTypeCollectionCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/24.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTLinkTypeCollectionCell.h"

@interface BTLinkTypeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIButton *linkTypeBtn;

@end
@implementation BTLinkTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithModel:(BTLinkTypeModel *)model{
    [self.linkTypeBtn setTitle:model.linkType forState:UIControlStateNormal];
    self.linkTypeBtn.selected = model.selected;
    self.linkTypeBtn.backgroundColor = model.selected ? RGBOF(0xA78659) : RGBOF(0xE8E8E8);
}
@end
