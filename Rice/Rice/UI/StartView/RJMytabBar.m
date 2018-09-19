//
//  RJMytabBar.m
//  Rice
//
//  Created by 李永 on 2018/9/9.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJMytabBar.h"

#define TABBAR_BTN_START_TAG 100
#define BTN_COUNT  4

@interface TabBarButton : UIButton

@property (nonatomic,strong) UIButton *tabBarBtn;

@property (nonatomic,strong) UIImageView *imgView;


@end

@implementation TabBarButton


- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"init");
        
    }
    
    return self;
}

// init方法会调用initWithFrame ,给控件添加子控件在initWithFrame中添加
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tabBarBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:self.tabBarBtn];
        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(10);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.width.mas_equalTo(20);
            make.height.mas_offset(20);
        }];
    }
   return self;
}

// 重写高亮的方法。在这个方法中，我们忽略按钮的高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    //    NSLog(@"highlighted = %d", highlighted);
    //    [super setHighlighted:NO];
}

@end

@interface RJMytabBar ()

// 保存分栏之前选中的按钮
@property (nonatomic, retain) TabBarButton *preSelBtn;
@end

@implementation RJMytabBar

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"init");
    }
    
    return self;
}

// init方法会调用initWithFrame ,给控件添加子控件在initWithFrame中添加
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 1.2 设置背景视图的背景图片
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.3 设置用户交互属性可用(父控件不能与用户进行交互，则所有子控件都不能与用户交互)
        self.userInteractionEnabled = YES;
        
        // 2. 在分栏背景上添加按钮
        for (int i = 0; i < BTN_COUNT; i++) {
            TabBarButton *btn = [[TabBarButton alloc] initWithFrame:CGRectMake( i * (KScreenWidth / 4), CGRectGetMaxY(self.frame), KScreenWidth / 4, CGRectGetHeight(self.frame))];
            
            // 设置正常状态下的显示图片
//            NSString *imageName = [NSString stringWithFormat:@"tab_%d", i];
//            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            switch (i) {
                case 0:
                    [btn.tabBarBtn setTitle:@"故事" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitle:@"" forState:UIControlStateSelected];
                    [btn.tabBarBtn setImage:[UIImage imageNamed:@"故事"] forState:UIControlStateSelected];
                    break;
                case 1:
                    [btn.tabBarBtn setTitle:@"发现" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitle:@"发现" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                    break;
                case 2:
                    [btn.tabBarBtn setTitle:@"消息" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitle:@"消息" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                    break;
                case 3:
                    [btn.tabBarBtn setTitle:@"家庭" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitle:@"家庭" forState:UIControlStateNormal];
                    [btn.tabBarBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                    break;
                    
                default:
                    break;
            }
            
            // 第一个按钮默认为选中
            if (i == 0) {
                btn.selected = YES;
                self.preSelBtn = btn;
                self.preSelBtn.selected = YES;
            }
            
            // 监听按钮的点击事件
            [btn.tabBarBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            
            btn.tabBarBtn.tag = TABBAR_BTN_START_TAG + i;
            
            // 将按钮添加到背景视图上显示
            [self addSubview:btn];
        }
    }
    
    return self;
}


- (void)btnClick:(TabBarButton *)btn
{
    // 1. 取消之前选中按钮的选中状态
    self.preSelBtn.selected = NO;

    // 2. 将当前点击的按钮设为选中状态
    btn.selected = YES;
    
//    if (btn.selected && btn.tag == TABBAR_BTN_START_TAG + 3) {
//        self.preSelBtn.imgView.image = [UIImage imageNamed:@"小太阳"];
//    }else {
//        self.preSelBtn.imgView.image = [UIImage imageNamed:@""];
//    }

    // 3. 保存当前选中的按钮
    self.preSelBtn = btn;

    // 如果代理实现了协议方法，通过协议方法通知代码当前控件上的第几个按钮被点击了。
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemWithIndex:)]) {

        [self.delegate tabBar:self didSelectItemWithIndex:btn.tag - TABBAR_BTN_START_TAG];
    }
}


// 这个方法在控件的frame(大小)修改后被调用
- (void)layoutSubviews
{
    // 这行代码不能少
    [super layoutSubviews];
    
    // 取出子控件的个数
    NSUInteger count = self.subviews.count;
    
    // 调整子控件的大小
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / count;
    CGFloat btnH = self.bounds.size.height;
    
    int i = 0;
    // 取出所有的子控件,调整frame
    for (TabBarButton *btn in self.subviews) {
        // 设置frame
        CGFloat btnX = btnW * i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
}

@end

