//
//  BTNoticeDetailVC.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTNoticeDetailVC.h"
#import <WebKit/WebKit.h>

@interface BTNoticeDetailVC ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet UILabel *noticeTime;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation BTNoticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"公告");
    [self setupBind];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupBind{
    self.noticeTitle.text = self.noticeModel.title;
    self.noticeTime.text = self.noticeModel.createTime;
    [self.webView loadHTMLString:[self HTML:self.noticeModel.content] baseURL:nil];
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
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'" completionHandler:nil];

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
