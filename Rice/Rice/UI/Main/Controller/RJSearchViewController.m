//
//  RJSearchViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/18.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJSearchViewController.h"
#import "RJStoryModel.h"
#import "RJStoryListModel.h"
#import "RJHotWordsCollectionReusableView.h"
#import "RJHotWordsCell.h"
#import "RJHistoricalRecordCell.h"
#import "RJSearchAlbumCollectionReusableView.h"
#import "RJHeaderSearchAlbumCollectionReusableView.h"
#import "RJNewsStoryCell.h"
#import "RJAlbumDetailsController.h"
#import "RJStoryDetailsViewController.h"


@interface RJSearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic,strong) NSMutableArray *hotArrList;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *seachAlbumrList;

@property (nonatomic,strong) NSMutableArray *seachStoryList;

@property (nonatomic,strong) RJHotWordsCollectionReusableView *hotWordsCollectionReusableView;

@property (nonatomic,strong) RJSearchAlbumCollectionReusableView *searchAlbumCollectionReusableView;

@property (nonatomic,strong) RJHeaderSearchAlbumCollectionReusableView *headerSearchAlbumCollectionReusableView;


@end

@implementation RJSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"    "
                                                                         titleColor:kColor(255, 255, 255, 1)
                                                                           textFont:17
                                                                              image:[UIImage imageNamed:@"黑ReturnButton"]
                                                                          addTarget:self
                                                                             action:@selector(backVC)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithText:@"搜索" titleColor:kColor(76, 76, 76, 1) textFont:17 addTarget:self action:@selector(searchAction)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
    self.isSearch = NO;
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
    [self getHotSearch];
}

- (void)setData {
    self.isSearch = NO;
    self.page = 1;
    self.hotArrList = [NSMutableArray array];
    self.seachAlbumrList = [NSMutableArray array];
    self.seachStoryList = [NSMutableArray array];
}

#pragma mark ---------------------------UI
- (void)setUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(50, 20, KScreenWidth - 100, 28)];
    bgView.backgroundColor = kColor(232, 232, 232, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 14;
    
    self.navigationItem.titleView = bgView;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 4, 20, 20)];
    [bgView addSubview:searchImg];
    searchImg.image = [UIImage imageNamed:@"SearchButton"];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(32, 0, KScreenWidth - 100 - 20, 28)];
    [bgView addSubview:self.searchTextField];
    self.searchTextField.backgroundColor = kColor(232, 232, 232, 1);
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.cornerRadius = 14;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchTextField becomeFirstResponder];
    
    //myCollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = kColor(232, 232, 232, 1);
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    //HeaderView
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJHotWordsCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJHotWordsCollectionReusableView"];
    
    //
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJSearchAlbumCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJSearchAlbumCollectionReusableView"];
    
    //
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJHeaderSearchAlbumCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJHeaderSearchAlbumCollectionReusableView"];
    
    //热门
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJHotWordsCell" bundle:nil] forCellWithReuseIdentifier:@"RJHotWordsCell"];
    
    //历史
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJHistoricalRecordCell" bundle:nil] forCellWithReuseIdentifier:@"RJHistoricalRecordCell"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJNewsStoryCell" bundle:nil] forCellWithReuseIdentifier:@"RJNewsStoryCell"];
    
    
    
    [self.view addSubview:self.myCollectionView];
}

#pragma mark ---------------------------delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.isSearch) {
        return 3;
    }else {
        return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSearch) {
        switch (section) {
            case 0: {
                return 0;
            }
                break;
            case 1: {
                return self.seachAlbumrList.count;
            }
                break;
            case 2: {
                return self.seachStoryList.count;
            }
                break;
            default: {
                return 0;
            }
                break;
        }
    }else {
        switch (section) {
            case 0: {
                return self.hotArrList.count;
            }
                break;
            case 1: {
                return [RJUserHelper shareInstance].expertModelArr.count;
            }
                break;
            default: {
                return 0;
            }
                break;
        }
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    __weak typeof (self) weakSelf = self;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (self.isSearch) {
            if (indexPath.section == 0) {
                self.headerSearchAlbumCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJHeaderSearchAlbumCollectionReusableView" forIndexPath:indexPath];
                self.headerSearchAlbumCollectionReusableView.searchName.text = [NSString stringWithFormat:@"以下是%@的搜索结果",[RJUserHelper shareInstance].lastLoginUserInfo.nickname];
                return self.headerSearchAlbumCollectionReusableView;
            }else if (indexPath.section == 1) {
                self.searchAlbumCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJSearchAlbumCollectionReusableView" forIndexPath:indexPath];
                self.searchAlbumCollectionReusableView.searchTitle.text = @"专辑";
                self.searchAlbumCollectionReusableView.contentTitle.text = [NSString stringWithFormat:@"共搜索到%ld个专辑",(long)self.seachAlbumrList.count];
                return self.searchAlbumCollectionReusableView;
            }else if (indexPath.section == 2) {
                self.searchAlbumCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJSearchAlbumCollectionReusableView" forIndexPath:indexPath];
                self.searchAlbumCollectionReusableView.searchTitle.text = @"故事";
                self.searchAlbumCollectionReusableView.contentTitle.text = [NSString stringWithFormat:@"共搜索到%ld个故事",(long)self.seachStoryList.count];
                return self.searchAlbumCollectionReusableView;
            }
        }else {
            if (indexPath.section == 0) {
                //轮播图
                self.hotWordsCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJHotWordsCollectionReusableView" forIndexPath:indexPath];
                self.hotWordsCollectionReusableView.hotWords.text = @"热门搜索标签";
                return self.hotWordsCollectionReusableView;
            }else if (indexPath.section == 1) {
                self.hotWordsCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJHotWordsCollectionReusableView" forIndexPath:indexPath];
                self.hotWordsCollectionReusableView.hotWords.text = @"历史搜索标签";
                return self.hotWordsCollectionReusableView;
            }
        }
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        if(indexPath.section == 1) {
            //专辑
            RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJNewsStoryCell" forIndexPath:indexPath];
            cell.storyListmodel = self.seachAlbumrList[indexPath.row];
            return cell;
        }else if (indexPath.section == 2) {
            //故事
            RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJNewsStoryCell" forIndexPath:indexPath];
            cell.storyListmodel = self.seachStoryList[indexPath.row];
            return cell;
        }
    }else {
        if(indexPath.section == 0) {
            //热门
            RJHotWordsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJHotWordsCell" forIndexPath:indexPath];
            cell.hotWordsTitle.text = self.hotArrList[indexPath.row];
            return cell;
        }else if (indexPath.section == 1) {
            //历史
            RJHistoricalRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJHistoricalRecordCell" forIndexPath:indexPath];
            cell.historicalRecordTitle.text = [RJUserHelper shareInstance].expertModelArr[indexPath.row];
            return cell;
        }
    }
   
        return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        if (section == 0) {
            
            return CGSizeMake(KScreenWidth, 30);
            
        }else if (section == 1 || section == 2) {
            
            return CGSizeMake(KScreenWidth, 44);
        }
    }else {
        if (section == 0 || section == 1) {
            // 头部
            return CGSizeMake(KScreenWidth, 44);
        }
    }
    
    return CGSizeMake(0, 0);
    
}

#pragma mark   UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        if (indexPath.section == 1) {
            RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
            albumDetailsVC.storyListModel = self.seachAlbumrList[indexPath.row];
            [self.navigationController pushViewController:albumDetailsVC animated:YES];
        }else if (indexPath.section == 2) {
            RJStoryDetailsViewController *storyDetailsViewController = [[RJStoryDetailsViewController alloc] init];
            storyDetailsViewController.storyModel = self.seachStoryList[indexPath.row];
            [self.navigationController pushViewController:storyDetailsViewController animated:YES];
        }
    }else {
        if (indexPath.section == 0) {
            self.isSearch = YES;
            [self getStoryAlbumList:self.hotArrList[indexPath.row]];
            [self getStoryList:self.hotArrList[indexPath.row]];
        }else if (indexPath.section == 1) {
            self.isSearch = YES;
            [self getStoryAlbumList:[RJUserHelper shareInstance].expertModelArr[indexPath.row]];
            [self getStoryList:[RJUserHelper shareInstance].expertModelArr[indexPath.row]];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        if (indexPath.section == 1){
            
            return CGSizeMake(KScreenWidth, 220);
        }else if (indexPath.section == 2){
            
            return CGSizeMake((KScreenWidth - 24) / 2, 220);
        }
    }else {
        if (indexPath.section == 0) {
            
            return CGSizeMake((KScreenWidth - 20) / 2, 30);
        }else if (indexPath.section == 1){
            
            return CGSizeMake(KScreenWidth / 3, 30);
        }
    }
    
  return CGSizeMake(0, 0);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

#pragma mark ---------------------------textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}

#pragma mark ---Action
#pragma mark ---返回
- (void)backVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---搜索
- (void)searchAction {
    [self.searchTextField resignFirstResponder];
    if (self.searchTextField.text.length > 0) {
        self.isSearch = YES;
        [self getStoryAlbumList:self.searchTextField.text];
        [self getStoryList:self.searchTextField.text];
        if (![NSString ql_isEmpty:self.searchTextField.text]) {
            [[RJUserHelper shareInstance].expertModelArr addObject:self.searchTextField.text];
        }
    }else {
        return ;
    }
    
}

#pragma mark ---热搜
- (void)getHotSearch {
    [RJHttpRequest postHotSearchCallback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *dicArr = result[@"data"];
            [self.hotArrList removeAllObjects];
            if (dicArr && dicArr.count > 0) {
                self.hotArrList = [NSMutableArray arrayWithArray:dicArr];
            }
        }
        [self.myCollectionView reloadData];
    }];
}

#pragma mark ---专辑列表
- (void)getStoryAlbumList:(NSString *)text {
    [RJHttpRequest postAlbumListWithPage:self.page keyword:text callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *albumList = result[@"data"];
            [self.seachAlbumrList removeAllObjects];
            if (albumList && albumList.count > 0) {
                for (NSDictionary *dic in albumList) {
                    RJStoryListModel *model = [[RJStoryListModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.seachAlbumrList addObject:model];
                }
            }
            [self.myCollectionView reloadData];
        }
        
    }];
}

#pragma mark ---故事列表
- (void)getStoryList:(NSString *)text {
    [RJHttpRequest postStoryListWithPage:self.page recommend:nil album_id:nil story_type:nil label:nil keyword:text callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *storyList = result[@"data"];
            [self.seachStoryList removeAllObjects];
            if (storyList && storyList.count > 0) {
                for (NSDictionary *dic in storyList) {
                    RJStoryModel *model = [[RJStoryModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.seachStoryList addObject:model];
                }
            }
            [self.myCollectionView reloadData];
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
