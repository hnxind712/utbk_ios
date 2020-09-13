//
//  BTAssetsCell.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsCell.h"
@interface BTAssetsCell ()
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCoinAccount;//总额
@property (weak, nonatomic) IBOutlet UILabel *convertAccount;//折合

@end
@implementation BTAssetsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configureCellWithAssetsModel:(id)model{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cellBtnActions:(UIButton *)sender {
    if (self.cellBtnClickAction) {
        self.cellBtnClickAction(sender.tag - 100);
    }
}

@end
