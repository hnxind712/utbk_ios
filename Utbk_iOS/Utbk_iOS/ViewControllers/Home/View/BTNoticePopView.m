//
//  BTNoticePopView.m
//  Utbk_iOS
//
//  Created by heyong on 2020/10/18.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTNoticePopView.h"
#import <WebKit/WebKit.h>
#import "BTNoticeModel.h"

@interface BTNoticePopView ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noticeT;
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *knowT;

@end

@implementation BTNoticePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show:(BTNoticeModel *)model{
    [BTKeyWindow addSubview:self];
    self.frame = BTKeyWindow.bounds;
    self.noticeTitle.text = model.title;
    [self.webView loadHTMLString:[self HTML:model.content] baseURL:nil];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    [self.knowT setTitle:LocalizationKey(@"Gotit") forState:UIControlStateNormal];
    self.noticeT.text = [NSString stringWithFormat:@"BTCK %@",LocalizationKey(@"notice")];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width - 64,[UIScreen mainScreen].bounds.size.width];
    [webView evaluateJavaScript:js completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#CCCCCC'" completionHandler:nil];
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];

}
- (NSString *)HTML:(NSString *)html{
    
    NSScanner *theScaner = [NSScanner scannerWithString:html];

    NSDictionary *dict = @{@"&amp;":@"&", @"&lt;":@"<", @"&gt;":@">", @"&nbsp;":@"", @"&quot;":@"\"", @"width":@"wid"};

    while ([theScaner isAtEnd] == NO) {

        for (int i = 0; i <[dict allKeys].count; i ++) {

            [theScaner scanUpToString:[dict allKeys][i] intoString:NULL];

            html = [html stringByReplacingOccurrencesOfString:[dict allKeys][i] withString:[dict allValues][i]];

        }

    }

    return html;

}
- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
