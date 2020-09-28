//
//  BTHomeNoticeView.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeNoticeView.h"
#import "BTNoticeModel.h"

@interface BTHomeNoticeView ()

@property (weak, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) BTNoticeModel *noticeModel;

@end

@implementation BTHomeNoticeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureNoticeViewWithModel:(BTNoticeModel *)model{
    _noticeModel = model;
    self.message.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"公告"),model.title];
}
- (IBAction)moreAction:(UIButton *)sender {
    if (self.noticeMoreAction) {
        self.noticeMoreAction();
    }
}
- (IBAction)detailAction:(UITapGestureRecognizer *)sender {
    if (self.noticeDetailAction) {
        self.noticeDetailAction(self.noticeModel);
    }
}
@end
