//
//  KLinePeriodView.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "KLinePeriodView.h"
#import "KLineStateManager.h"
#import "ChartStyle.h"
@interface KLinePeriodView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;

@property (weak, nonatomic) IBOutlet UIButton *periodFenButton;
@property (weak, nonatomic) IBOutlet UIButton *period1FenButton;
@property (weak, nonatomic) IBOutlet UIButton *period1HoursButton;
@property (weak, nonatomic) IBOutlet UIButton *period30FenButton;
@property (weak, nonatomic) IBOutlet UIButton *period5FenButton;
@property (weak, nonatomic) IBOutlet UIButton *period1WeekButton;
@property (weak, nonatomic) IBOutlet UIButton *period15FenButton;
@property (weak, nonatomic) IBOutlet UIButton *period4hourButton;
@property (weak, nonatomic) IBOutlet UIButton *period1dayButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *mainPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;

@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic)  UIButton *currentButton;
@end

@implementation KLinePeriodView

+(KLinePeriodView *)linePeriodView {
    KLinePeriodView *view = [[NSBundle mainBundle] loadNibNamed:@"KLinePeriodView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 30);
    view.backgroundColor = ChartColors_bgColor;
    view.layer.shadowColor =  [UIColor  blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 10);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 5;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.currentButton = self.period15FenButton;
    self.centerXConstraint.constant = self.currentButton.center.x - self.periodFenButton.center.x;

}

- (IBAction)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 5) {
        self.moreView.hidden = !self.moreView.hidden;
        if (self.showMore) {
            self.showMore(!self.moreView.hidden);
        }
        return;
    } else if (tag == 6) {
        if (!self.moreView.hidden) {
            self.moreView.hidden = YES;
        }
        if (self.showMain) {
            self.showMain();
        }
        return;
    } else if (tag == 7) {
        return;
    } else {
        self.moreView.hidden = YES;
        if (self.showMore) {
            self.showMore(!self.moreView.hidden);
        }
        if (tag > 7) {
            [UIView animateWithDuration:0.5 animations:^{
                self.centerXConstraint.constant = self.moreButton.center.x - self.periodFenButton.center.x;
            }];
            [self.moreButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            [self.moreButton setTitle:sender.titleLabel.text forState:UIControlStateHighlighted];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.centerXConstraint.constant = sender.center.x - self.periodFenButton.center.x;
            }];
            [self.moreButton setTitle:LocalizationKey(@"更多") forState:UIControlStateNormal];
            [self.moreButton setTitle:LocalizationKey(@"更多") forState:UIControlStateHighlighted];
        }
        self.currentButton = sender;
        NSString *period = @"1min";
        if(sender.tag == 1) {
           period = @"1";
        } else if (sender.tag == 2) {
            period = @"15";
        } else if (sender.tag == 3) {
            period = @"240";
        } else if (sender.tag == 4) {
            period = @"1D";
        } else if (sender.tag == 8) {
            period = @"1";
        } else if (sender.tag == 9) {
            period = @"5";
        } else if (sender.tag == 10) {
            period = @"30";
        } else if (sender.tag == 11) {
            period = @"60";
        } else if (sender.tag == 12) {
            period = @"1W";
        }
        [KLineStateManager manager].period = period;
        if( tag == 1) {
           [KLineStateManager manager].isLine = YES;
        } else {
           [KLineStateManager manager].isLine = NO;
        }
    }
}


@end

