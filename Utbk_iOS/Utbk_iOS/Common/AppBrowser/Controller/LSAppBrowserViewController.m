//
//  LSAppBrowserViewController.m
//  LSBrightGreen
//
//  Created by LS on 2020/5/8.
//  Copyright © 2020 HY. All rights reserved.
//

#import "LSAppBrowserViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "LoadingImage.h"

// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
@implementation WeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface LSAppBrowserViewController () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, weak) IBOutlet LoadingImage *rorateImage;

@end

@implementation LSAppBrowserViewController

- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + 2, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *)webView{
    if(_webView == nil){
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"LSBrightGreen";
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"getUserToken"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"hiddeNavigationBar"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"gotoLoginController"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"gotoHomeController"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"finishView"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"gotoPayController"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"gotoAuthController"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"gotoScaningController"];//扫描
        config.userContentController = wkUController;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        _webView.scrollView.bouncesZoom = NO;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
        WKBackForwardList * backForwardList = [_webView backForwardList];
        
        //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chinadaily.com.cn"]];
        //        [request addValue:[self readCurrentCookieWithDomain:@"http://www.chinadaily.com.cn"] forHTTPHeaderField:@"Cookie"];
        //        [_webView loadRequest:request];
        
        
        NSString *urlString;
        if ([self.urlString containsString:@"?"]) {
            urlString = [NSString stringWithFormat:@"%@&source=app",self.urlString];
        }else{
            urlString = [NSString stringWithFormat:@"%@?source=app",self.urlString];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rorateImage start];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.progressView];
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
//    WeakSelf(weakSelf)
//    [LSAppInfo getAppInfoSuccess:^(LSAppInfo * _Nonnull info) {
//        StrongSelf(strongSelf)
//        strongSelf.appInfo = info;
//        if ([self.urlString isEqualToString:MallHomeURL] && self.appInfo.showAd) {//意味着是商城
//            [self.splashAdView loadSplashAd];
//        }
//    } failure:^(NSError * _Nonnull error) {
//
//    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.isAd) return;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}
#pragma mark - JS 调 OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    NSDictionary * parameter = message.body;
    //JS调用OC
//    if ([message.name isEqualToString:@"getUserToken"]){
//        NSLog(@"please get user token");
//        [self submitUserToken];
//    } else if([message.name isEqualToString:@"hiddeNavigationBar"]){
//        [self hiddeNavigationBar];
//    } else if ([message.name isEqualToString:@"gotoLoginController"]) {
//        [self gotoLoginController];
//    } else if ([message.name isEqualToString:@"gotoHomeController"]) {
//        [self gotoHomeController];
//    } else if ([message.name isEqualToString:@"finishView"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    } else if ([message.name isEqualToString:@"gotoPayController"]) {
//        if ([parameter[@"type"] boolValue]) {
//            //支付宝
//            [self aliPayWithPayInfo:parameter[@"pay"]];
//        } else {
//            //微信
//            [self weixinWithPayInfo:parameter[@"pay"]];
//        }
//    } else if ([message.name isEqualToString:@"gotoAuthController"]) {
//        [self gotoAuthController];
//    }else if ([message.name isEqualToString:@"gotoScaningController"]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self scan];
//        });
//    }
    
}

#pragma mark -- OC 调 JS
- (void)callBackWithCode:(NSString *)code{
     NSString *jsString = [NSString stringWithFormat:@"getScanReuslt('%@')",code];
    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
}
- (void)submitUserToken {
//    NSString *jsString = [NSString stringWithFormat:@"getToken('%@')",[NSString stringWithFormat:@"%@ %@",@"Bearer",[[NSUserDefaults standardUserDefaults]objectForKey:kAccess_token]]];
//    [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//        NSLog(@"提交token");
//    }];
}

- (void)hiddeNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - wkwebview delegate
    // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%@ webview start load", self.urlString);
}
    // 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.rorateImage stop];
    self.rorateImage.hidden = YES;
    [self.progressView setProgress:0.0f animated:NO];
    NSLog(@"%@ webview start load fail, error = %@", self.urlString, error.localizedDescription);
}
    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.rorateImage stop];
    self.rorateImage.hidden = YES;
    [self.view addSubview:self.webView];
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    NSLog(@"%@ webview start load finish", self.urlString);
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    [self.rorateImage stop];
    self.rorateImage.hidden = YES;
}


#pragma mark - KVO
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
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
