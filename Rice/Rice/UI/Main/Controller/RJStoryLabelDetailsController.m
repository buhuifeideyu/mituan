//
//  RJStoryLabelDetailsController.m
//  Rice
//
//  Created by 李永 on 2018/9/14.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJStoryLabelDetailsController.h"
#import "RJSpecialColumnCollectionReusableView.h"
#import "RJSpecialColumnOtherCollectionReusableView.h"
#import "RJMoreStoriesCollectionReusableView.h"
#import "RJNewsStoryCollectionReusableView.h"
#import "RJNewsStoryCell.h"

#define kRJNewsStoryCollectionReusableViewId @"RJNewsStoryCollectionReusableViewId"
#define kRJNewsStoryCellId @"RJNewsStoryCellId"

@interface RJStoryLabelDetailsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) RJNewsStoryCollectionReusableView *newsStoryCollectionReusableView;//最新故事

@property (nonatomic,strong) NSMutableArray *storyList;

@property (nonatomic,assign) NSInteger page;

@end

@implementation RJStoryLabelDetailsController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark ---------------------------View Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setData];
    [self getStoryList];
}

- (void)setData {
    self.storyList = [NSMutableArray array];
    self.page = 1;
}

#pragma mark ---------------------------UI
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //myCollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    //最新故事
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJNewsStoryCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJNewsStoryCollectionReusableView"];
    
    //最新故事
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJNewsStoryCell" bundle:nil] forCellWithReuseIdentifier:kRJNewsStoryCellId];
    
    [self.view addSubview:self.myCollectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0: {
            return self.storyList.count;
        }
            break;
        default: {
            return 0;
        }
            break;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    //    __weak typeof (self) weakSelf = self;
    if (kind == UICollectionElementKindSectionHeader) {
        self.newsStoryCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJNewsStoryCollectionReusableView" forIndexPath:indexPath];
        self.newsStoryCollectionReusableView.newsStoryLabel.text = self.labelString;
        return self.newsStoryCollectionReusableView;
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
    cell.model = self.storyList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

     return CGSizeMake(KScreenWidth, 80);
    
    
}

#pragma mark   UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 最新故事
    return CGSizeMake((KScreenWidth - 24) / 2, 220);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
    return UIEdgeInsetsMake(0, 8, 0, 8);

}


#pragma mark ---------------------------netWork
- (void)getStoryList {
    [RJHttpRequest postStoryListWithPage:self.page recommend:0 album_id:0 story_type:0 label:0 keyword:nil callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *dataArr = result[@"data"];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    RJStoryModel *model = [[RJStoryModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.storyList addObject:model];
                }
            }
        }
        [self.myCollectionView reloadData];
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
