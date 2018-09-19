//
//  RJWebViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJWebViewController.h"

@interface RJWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation RJWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressView = [[UIProgressView alloc] init];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    self.title = self.title_str ? self.title_str :@"加载中...";
    [self setUIBarButtonItem:self.title_str];
    
    self.webview.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.remoteURL]];
    [self.webview loadRequest:request];
}

- (void)backToHistory{
    //后退
    if([self.webview canGoBack]){
        [self.webview goBack];
    }else{
        [self closeViewController];
    }
}

- (void)refrash{
    [self.webview loadRequest:self.webview.request];
}

- (void)closeViewController{
//    //关闭窗口
//    if(self.startType == 1){
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (NSString *)currPageTitle{
    NSString *titleStr = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    return titleStr;
}

- (void)setUIBarButtonItem:(NSString *)title {
    
    NSString *titleStr = title?title:@"";
    
    self.navigationItem.titleView = [UIView titleViewWithTitle:@"" font:17 textColor:[UIColor whiteColor]];
    
    
    CGFloat rightButtonsWidth = 10 + 40 * 2;
    UIBarButtonItem *refrashBar = [UIBarButtonItem barButtonItemWithTitle:@"" titleColor:nil textFont:17 image:[UIImage imageNamed:@"icon_renovate"] addTarget:self action:@selector(refrash) andSmallImage:nil];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    UIBarButtonItem *closeBar = [UIBarButtonItem barButtonItemWithTitle:@"" titleColor:nil textFont:17 image:[UIImage imageNamed:@"icon_close"] addTarget:self action:@selector(closeViewController) andSmallImage:nil];
    self.navigationItem.rightBarButtonItems = @[closeBar,negativeSpacer,refrashBar];
    
    UIBarButtonItem *backBarButton = [UIBarButtonItem barButtonItemWithTitle:titleStr titleColor:kColor(255, 255, 255, 1) textFont:17 image:[UIImage imageNamed:@"ReturnButton"]addTarget:self action:@selector(backToHistory) maxWidth:KScreenWidth - rightButtonsWidth - 10];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    self.progressView.progress = 0.0f;
    self.progressView.hidden = NO;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.progressView.progress = 0.5f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([NSString ql_isEmpty:self.title]) {
        NSString *title_str = [self currPageTitle];
        [self setUIBarButtonItem:title_str];
    }
    //    [self getInfo];
    
    self.progressView.progress = 1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
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
