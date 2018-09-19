//
//  RJStartViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJStartViewController.h"
#import "ZYBannerView.h"
#import "RJLoginViewController.h"
#import "RJHomeTabBarViewController.h"
#import "RJBannerInfo.h"

@interface RJStartViewController () <UIScrollViewDelegate>
{
    UIButton * openButton;
    UIPageControl * pageControl;
    UIButton *localImageBtn;
}

@property (nonatomic,strong) NSMutableArray *scrollImages;//滚动视图图片数组

@end

@implementation RJStartViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.self.scrollImages = [NSMutableArray new];
    [self getBanner];
}

#pragma mark - UI
- (void)setUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(KScreenWidth * self.scrollImages.count, 0);
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.canCancelContentTouches = NO;//是否可以中断touches
    scrollView.delaysContentTouches = NO;//是否延迟touches事件
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    if (self.scrollImages.count < 1) {
        UIImageView * imgview = [[UIImageView alloc] initWithImage:KStartDefaultImage];
        [scrollView addSubview:imgview];
        [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scrollView.mas_top).mas_offset(-20);
            make.height.mas_equalTo(KScreenHeight);
            make.width.mas_equalTo(KScreenWidth);
            make.left.mas_equalTo(KScreenWidth);
        }];
    }else {
        for (int index = 0; index < self.scrollImages.count; index++) {
            RJBannerInfo *info = self.scrollImages[index];
            UIImageView * imgview = [[UIImageView alloc] init];
            [scrollView addSubview:imgview];
            [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scrollView.mas_top).mas_offset(-20);
                make.height.mas_equalTo(KScreenHeight + 20);
                make.width.mas_equalTo(KScreenWidth);
                make.left.mas_equalTo(KScreenWidth * index);
            }];
            [imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,info.pic]] placeholderImage:KStartDefaultImage];
        }
    }
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.scrollImages.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = kColor(68, 169, 242, 1);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-10);
        make.centerX.mas_equalTo(self.view);
    }];
    
    openButton = [[UIButton alloc] init];
    [self.view addSubview:openButton];
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-40);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
    [openButton setTitle:@"点击进入" forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [openButton.layer setBorderWidth:1.0]; //边框宽度
    [openButton.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
    [openButton.layer setCornerRadius:22.0]; //设置矩形四个圆角半径
    [openButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    openButton.hidden = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger index = targetContentOffset->x/KScreenWidth;
    if (index == (self.scrollImages.count - 1)) {
        pageControl.hidden = NO;
        openButton.hidden = NO;
    }else {
        pageControl.hidden = NO;
        openButton.hidden = YES;
    }
    pageControl.currentPage = index;
}

#pragma mark ---Action
- (void)nextAction {
    if ([RJUserHelper shareInstance].lastLoginUserInfo) {
        RJHomeTabBarViewController *tabBarVC = [[RJHomeTabBarViewController alloc] init];
        
        [UIApplication sharedApplication].windows.firstObject.rootViewController = tabBarVC;
    }else {
        RJLoginViewController *loginVC = [[RJLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark ---------------------------netWork
#pragma mark ---banner
- (void)getBanner {
    [RJHttpRequest postAdWithPosition:kGuidePagee callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *dicArr = result[@"data"];
            if (dicArr && dicArr.count > 0) {
                for (NSDictionary *dic  in dicArr) {
                    RJBannerInfo *model = [[RJBannerInfo alloc] init];
                    [model initWithDictionary:dic];
                    [self.scrollImages addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUI];
            });
        }
    }];
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
