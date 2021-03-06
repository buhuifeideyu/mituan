//
//  YYChooseTypeAlertView.m
//  YYFramework
//
//  Created by 李永 on 2017/5/23.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "YYChooseTypeAlertView.h"
#import "YYChooseTypeAlertViewCell.h"

@interface YYChooseTypeAlertView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *imgArr;
@property(nonatomic,strong)UITableView *tableView;
@end
static const CGFloat cellH = 50;
static NSString *const YYChooseAlertTableViewCellID = @"YYChooseTypeAlertViewCell";
@implementation YYChooseTypeAlertView
#pragma mark --- 懒加载

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

#pragma mark --- 建表
- (UITableView *)tableView
{
    if (!_tableView)
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        /**
         *开发者可自定义cell
         */
        [_tableView registerNib:[UINib nibWithNibName:@"YYChooseTypeAlertViewCell" bundle:nil] forCellReuseIdentifier:YYChooseAlertTableViewCellID];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        
        CGFloat tbCenterX = KScreenWidth * 0.5;
        CGFloat tbCenterY = KScreenHeight * 0.5;
        CGFloat tbW = KScreenWidth - 40;
        CGFloat tbH = _titleArr.count * cellH;
        if (tbH > KScreenHeight *0.7){
            _tableView.scrollEnabled = YES;
            tbH = KScreenHeight*0.7;
        }
        else
        {
            _tableView.scrollEnabled = NO;
        }
        
        _tableView.center = CGPointMake(0, 0);
        _tableView.bounds = CGRectMake(0, 0, tbW, tbH);
        
        //        [UIView animateWithDuration:0.3 animations:^{
        //            _tableView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        //            _tableView.center = CGPointMake(tbCenterX + 10, tbCenterY + 10);
        //        } completion:^(BOOL finished) {
        //            [UIView animateWithDuration:0.15 animations:^{
        _tableView.center = CGPointMake(tbCenterX , tbCenterY );
        //            }];
        //        }];
        
    }
    return _tableView;
}
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr
{
    if (self = [super initWithFrame:frame])
    {
        self.titleArr = titleArr;
        _imgArr = [NSArray array];
        _imgArr = @[@"devicelist_add_class1",@"equipment_icon_new_fan",@"devicelist_add_class2"];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseViewClicked:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //初始化UI
        [self setupUIWithFrame:frame];
    }
    return self;
}

#pragma mark --- UIGestureRecognizerDelegate 解决冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]){
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark --- 手势点击
- (void)chooseViewClicked:(UITapGestureRecognizer *)tap
{
    
    if ([self.delegate respondsToSelector:@selector(chooseTypeAlertViewWillDisappear:)]) {
        [self.delegate chooseTypeAlertViewWillDisappear:self];
    }
    [self hideChooseTypeView];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
#pragma mark --- 显示
- (void)showChooseTypeView
{
    //    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.alpha = 1;
    //    }];
}
#pragma mark --- 隐藏
- (void)hideChooseTypeView
{
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.alpha = 0;
    //        _tableView.center = CGPointMake(MainWidth, 0);
    //    } completion:^(BOOL finished) {
    [self removeFromSuperview];
    //    }];
}
#pragma mark --- 初始化UI
- (void)setupUIWithFrame:(CGRect)frame
{
    [self addSubview:self.tableView];
}

#pragma mark --- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYChooseTypeAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YYChooseAlertTableViewCellID forIndexPath:indexPath];
    cell.typeName = _titleArr[indexPath.row];
    cell.typeImg  = _imgArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(chooseTypeAlertView:didSelectedIndex:)])
    {
        [self.delegate chooseTypeAlertView:self didSelectedIndex:indexPath.row];
    }
    
    [self hideChooseTypeView];
}

@end

