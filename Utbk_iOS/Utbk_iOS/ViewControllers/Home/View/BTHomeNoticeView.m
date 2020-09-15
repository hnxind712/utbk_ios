//
//  BTHomeNoticeView.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeNoticeView.h"

@implementation BTHomeNoticeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureNoticeViewWithModel:(id)model{
    
}
- (IBAction)moreAction:(UIButton *)sender {
    if (self.noticeMoreAction) {
        self.noticeMoreAction();
    }
}
@end
