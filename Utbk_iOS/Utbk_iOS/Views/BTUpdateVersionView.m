//
//  BTUpdateVersionView.m
//  Utbk_iOS
//
//  Created by heyong on 2020/10/3.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTUpdateVersionView.h"
@interface BTUpdateVersionView ()

@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *versionContent;

@end
@implementation BTUpdateVersionView
+ (instancetype)show{
    BTUpdateVersionView *view = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    [BTKeyWindow addSubview:view];
    view.frame = BTKeyWindow.bounds;
    return view;
}
- (void)configureViewWithVersion:(NSString *)version content:(NSString *)content{
    NSString *newVersion = [NSString stringWithFormat:@"V%@",version];
    self.version.text = newVersion;
    self.versionContent.text = content;
}
- (IBAction)updateAction:(UIButton *)sender {
    if (self.updateAction) {
        self.updateAction();
    }
}
- (IBAction)cancleAction:(UIButton *)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
