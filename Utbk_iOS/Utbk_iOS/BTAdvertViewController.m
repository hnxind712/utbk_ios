//
//  BTAdvertViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/10/28.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAdvertViewController.h"

@interface BTAdvertViewController ()
@property (weak, nonatomic) IBOutlet UIButton *skipActionBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger interval;

@end

@implementation BTAdvertViewController
- (id)init{
    if (self = [super init]) {
        self.interval = 5;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)dountDown{
    self.interval--;
    if (self.interval <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        if (self.skipAction) {
            self.skipAction();
        }
    }
    [self.skipActionBtn setTitle:[NSString stringWithFormat:@"%@%d",LocalizationKey(@"skip"),self.interval] forState:UIControlStateNormal];

}
- (IBAction)skip:(UIButton *)sender {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.skipAction) {
        self.skipAction();
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
