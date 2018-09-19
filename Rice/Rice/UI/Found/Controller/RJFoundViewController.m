//
//  RJFoundViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFoundViewController.h"
#import "RJFoundLayout.h"
#import "RJFoundCell.h"

@interface RJFoundViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *mycollectionView;
@property(nonatomic,strong)UICollectionViewLayout *layout;

@property(nonatomic,strong)NSArray *heightArr;

@end

@implementation RJFoundViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
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
    [self setUI];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"发现";
    [self.view addSubview:self.mycollectionView];
}

#pragma mark collectionViewDelegate-collectionViewDatesource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RJFoundCell* cell = (RJFoundCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"RJFoundCell" forIndexPath:indexPath];
    
    NSString *height = self.heightArr[indexPath.row];
    cell.titleName.layer.cornerRadius = [height integerValue] / 4;
    [cell.titleName setTitle:@"有趣" forState:UIControlStateNormal];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.heightArr.count;
}

-(UICollectionView *)mycollectionView{
    if(!_mycollectionView){
        _mycollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:self.layout];
        _mycollectionView.backgroundColor = [UIColor whiteColor];
        _mycollectionView.delegate=self;
        _mycollectionView.dataSource=self;
        [_mycollectionView registerNib:[UINib nibWithNibName:@"RJFoundCell" bundle:nil] forCellWithReuseIdentifier:@"RJFoundCell"];
    }
    return _mycollectionView;
}

-(UICollectionViewLayout *)layout{
    if(!_layout){
        _layout = [[RJFoundLayout alloc] initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            return [self.heightArr[index.item] floatValue];
        }];
    }
    return _layout;
}

-(NSArray *)heightArr{
    if(!_heightArr){
        //随机生成高度
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<20; i++) {
            [arr addObject:@(arc4random()%50+80)];
        }
        _heightArr = [arr copy];
    }
    return _heightArr;
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
