//
//  ViewController.m
//  NHInterProcessPro
//
//  Created by hu jiaju on 16/5/26.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "NHWapBrowser.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSDate+TimeAgo.h"
#import "NSDate+PBHelper.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *wapJSCaller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect infoRect = CGRectMake(60, 100, 200, 50);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"call weixin without register" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callWinxin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"call A" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callWinxinWithRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"call B" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callWithB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"call test" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callWithTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"Run JS" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callJavascript) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    infoRect.origin.y += 100;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = infoRect;
    [btn setTitle:@"time ago" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(timeAgoEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)callWinxin {
    
    NSString *url_s = @"weixin://";
    NSURL *url = [NSURL URLWithString:url_s];
    BOOL can = [[UIApplication sharedApplication] canOpenURL:url];
    NSLog(@"wether can open %@:%d",url_s,can);
    [[UIApplication sharedApplication] openURL:url];
}

- (void)callWinxinWithRegister {
    NSString *url_s = @"processa://";
    NSURL *url = [NSURL URLWithString:url_s];
    BOOL can = [[UIApplication sharedApplication] canOpenURL:url];
    NSLog(@"wether can open %@:%d",url_s,can);
    [[UIApplication sharedApplication] openURL:url];
}

- (void)callWithB {
    NSString *url_s = @"processb://";
    NSURL *url = [NSURL URLWithString:url_s];
    BOOL can = [[UIApplication sharedApplication] canOpenURL:url];
    NSLog(@"wether can open %@:%d",url_s,can);
    [[UIApplication sharedApplication] openURL:url];
}

- (void)callWithTest {
//    NHWapBrowser *wapb = [[NHWapBrowser alloc] init];
//    [self.navigationController pushViewController:wapb animated:true];
    
    [self callJavascript];
}

- (void)callJavascript {
    //需要创建webview 因为利用了window的重定向机制
    JSContext *context = [[JSContext alloc] init];
    
    NSString *funCode =
    @"var isValidNumber = function() {"
    "    setTimeout(function () {window.location.href =\"https://itunes.apple.com/cn/app/ren-ren-mei-yan-zhi-bo.-hu/id316709252?mt=8\"; }, 25);"
    "    window.location.href = \"renren://plat=aicaibang\";"
    "};";
    [context evaluateScript:funCode];
    // 获得isValidNumber函数并传参调用
//    JSValue *jsFunction = context[@"isValidNumber"];
//    JSValue *value1 = [jsFunction callWithArguments:@[]];
//    NSLog(@"%@", [value1 toBool]? @"有效": @"无效");    // 有效
    
    [self.view addSubview:self.wapJSCaller];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"html"];
    NSString *htmls = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *resource = [[NSBundle mainBundle] pathForResource:@"activityHtml" ofType:@"bundle"];
    NSURL *baseURL = [NSURL fileURLWithPath:resource];
    [self.wapJSCaller loadHTMLString:htmls baseURL:baseURL];
}

- (UIWebView *)wapJSCaller {
    if (!_wapJSCaller) {
        //CGRect bounds = CGRectMake(10, 100, 300, 200);
        UIWebView *wap = [[UIWebView alloc] initWithFrame:self.view.bounds];
        wap.backgroundColor = [UIColor clearColor];
        wap.opaque = false;
        wap.scalesPageToFit = true;
        wap.scrollView.bounces = false;
        wap.delegate = self;
        _wapJSCaller = wap;
    }
    return _wapJSCaller;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"curl :%@",request.URL.absoluteString);
    
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('platName').innerText = '爱财帮';"];
    
    NSString *js = @"document.getElementById('platName').innerText = '爱财帮';setTimeout(function () {window.location.href = \"https://itunes.apple.com/cn/app/ren-ren-mei-yan-zhi-bo.-hu/id316709252?mt=8\"; }, 25);window.location.href = \"renren:// \";";
    js = @"document.getElementById('platName').innerText ='爱财帮';window.appUrl='https://itunes.apple.com/cn/app/ren-ren-mei-yan-zhi-bo.-hu/id316709252?mt=8';setTimeout(function() {setTimeout(function(){document.getElementById('loading').style.display = 'none';document.getElementById('confirm').style.display = 'block';document.getElementById('layer').style.display='block';},1600)}, 25);window.location.href = \"renren://\";";
    
    //js = @"window.location.href = 'itms-services://?action=download-manifest&url=https://www.youtuker.com//Resources/admin/20160630/57749af26dcb3.plist'";
    [self.wapJSCaller stringByEvaluatingJavaScriptFromString:js];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
    });
    return formatter;
}

- (void)timeAgoEvent {
    NSDateFormatter *formatter = self.dateFormatter;
    NSTimeInterval interval = arc4random()%100000000;
    NSDate *justNow = [NSDate dateWithTimeIntervalSinceNow:30];
    NSLog(@"just now:%@",[justNow pb_timeAgo]);
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:-interval];
    
    NSString *time = [formatter stringFromDate:now];
    NSLog(@"time is :%@",time);
    NSLog(@"time ago is:%@",[now pb_timeAgo]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
