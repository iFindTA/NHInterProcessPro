//
//  NHWapBrowser.m
//  NHInterProcessPro
//
//  Created by hu jiaju on 16/5/26.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHWapBrowser.h"

#define USE_WK  0

@interface NHWapBrowser ()<UIWebViewDelegate,WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIWebView *wapBrowser;
@property (nonatomic, strong) WKWebView *webBrowser;

@end

@implementation NHWapBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect bounds = self.view.bounds;
#if !USE_WK
    self.wapBrowser = [[UIWebView alloc] initWithFrame:bounds];
    self.wapBrowser.delegate = self;
    [self.view addSubview:self.wapBrowser];
#else
    
//    NSString *source = @"document.getElementsByClassName('download')[0].remove();";
//    WKUserScript * usrScript = [[WKUserScript alloc] initWithSource: source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:false];
//    WKUserContentController* userContentController = WKUserContentController.new;
//    [userContentController addUserScript:usrScript];
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.userContentController = userContentController;
    self.webBrowser = [[WKWebView alloc] initWithFrame:bounds];
    self.webBrowser.UIDelegate = self;
    self.webBrowser.navigationDelegate = self;
    [self.view addSubview:self.webBrowser];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadRequest];
}

- (void)loadRequest {
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"html"];
//    NSURL *fileURL = [NSURL fileURLWithPath:url];
    NSString *url = @"https://caijing.gongshidai.com/active/tlist";
    url = @"https://caijing.gongshidai.com/active/share?id=7409&page=article.detail&port=cms&t=0";
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
#if !USE_WK
    [self.wapBrowser loadRequest:request];
#else
    [self.webBrowser loadRequest:request];
#endif
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *host = [request URL].absoluteString;
    NSLog(@"***host:%@",host);
    
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *host = [webView.request URL].absoluteString;
    NSLog(@"---host:%@",host);
    [self runJS];
}

- (void)runJS {
    
    NSString *js = @"setTimeout(function () {window.location =\"https://itunes.apple.com/cn/app/ren-ren-mei-yan-zhi-bo.-hu/id316709252?mt=8\"; }, 25);window.location = \"weixin:// \";";
//    js = @"alert('some thing for test!')";
    js = @"var style = document.createElement('style');style.type = 'text/css';style.innerHTML = '.download,.gscj-code-div{display: none !important;}';document.head.appendChild(style);";
    NSString *ret = [self.wapBrowser stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"ret:%@",ret);
    //    [self.webBrowser evaluateJavaScript:js completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
    //        
    //    }];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *host = [webView URL].absoluteString;
    NSLog(@"+++++host:%@",host);
    if ([host rangeOfString:@"active/share?"].location != NSNotFound) {
        
        //此方法可以 但有闪动
        NSString *js = @"setTimeout(function(){document.getElementsByClassName('download')[0].remove();}, 800);";
        js = @"var style = document.createElement('style');style.type = 'text/css';style.innerHTML = '.download,.gscj-code-div{display: none !important;}';document.head.appendChild(style);";
        [webView evaluateJavaScript:js completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
            NSLog(@"ret:%@",ret);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
