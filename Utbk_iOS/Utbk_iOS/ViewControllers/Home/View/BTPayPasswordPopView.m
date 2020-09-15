//
//  BTPayPasswordPopView.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTPayPasswordPopView.h"

@implementation BTPayPasswordPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show{
    [BTKeyWindow addSubview:self];
    self.frame = BTKeyWindow.bounds;
}
- (IBAction)comfirmAction:(id)sender {
    [self removeFromSuperview];
    if (self.setPayPasswordAction) {
        self.setPayPasswordAction();
    }
}

@end
