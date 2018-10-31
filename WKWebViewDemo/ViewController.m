//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by colehuang on 2018/9/4.
//  Copyright © 2018年 ColeHuang. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>


@interface ViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong)UIProgressView * progressView;

@end

@implementation ViewController

- (IBAction)button:(id)sender {
    [_webView evaluateJavaScript:@"clickBtn()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [[WKPreferences alloc]init];
    //自定义配置，一般用于js调用oc方法(OC拦截URL中的数据做自定义操作)
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    config.userContentController = userContentController;
    
    //js call oc 声明处理callOC这个js方法
    [config.userContentController addScriptMessageHandler:self name:@"callOC"];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100) configuration:config];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    //添加此属性可触发侧滑返回上一网页与下一网页操作
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    
    //    NSURL *path = @"http://172.16.193.77:5000/test";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *filePath = [NSString stringWithFormat:@"file://%@",path];
    NSURL *url = [[NSURL alloc] initWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate

//和UIWebView中类似
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始到达时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [_webView evaluateJavaScript:@"alertMessage('tt')" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
        NSLog(@"%@",error);
    }];
}
// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//收到服务器重定向请求后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}
// 在收到响应开始加载后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//}
// 在请求开始加载之前调用，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//}

#pragma mark - WKUIDelegate
//- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//
//}
// 在js中调用alert函数时，会调用该方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();//此处的completionHandler()就是调用JS方法时，`evaluateJavaScript`方法中的completionHandler
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
// 在js中调用confirm函数时，会调用该方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
}
// 在js中调用prompt函数时，会调用该方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
}

#pragma mark - WKScriptMessageHandler
//获取js传递的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"didReceiveScriptMessage");
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"callOC"]) {
        NSLog(@"callOC");
        
    }
}




@end
