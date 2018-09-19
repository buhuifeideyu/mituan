//
//  RJMainViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJMainViewController.h"
#import "RJStoryModel.h"
#import "RJStoryListModel.h"
#import "RJHeadBannerCollectionReusableView.h"
#import "RJRandomCell.h"
#import "RJSleepCell.h"
#import "RJLikesCell.h"
#import "RJCollectionCell.h"
#import "RJRecentPlayCell.h"
#import "RJMoreStoriesCollectionReusableView.h"
#import "RJNewsStoryCollectionReusableView.h"
#import "RJNewsStoryCell.h"
#import "RJSpecialColumnCollectionReusableView.h"
#import "RJSpecialColumnOtherCollectionReusableView.h"
#import "RJPlayView.h"
#import "RJStoryDetailsViewController.h"
#import "RJStoryLabelDetailsController.h"
#import "RJAlbumDetailsController.h"
#import "RJSearchViewController.h"

#import "RJHomePlayListCell.h"

#define kRJHeadBannerCollectionReusableViewId @"RJHeadBannerCollectionReusableViewId"
#define kRJMoreStoriesCollectionReusableViewId @"RJMoreStoriesCollectionReusableViewId"
#define kRJRandomCellId @"RJRandomCellId"
#define kRJSleepCellId @"RJSleepCellId"
#define kRJLikesCellId @"RJLikesCellId"
#define kRJCollectionCellId @"RJCollectionCellId"
#define kRJRecentPlayCellId @"RJRecentPlayCellId"
#define kRJNewsStoryCellId @"RJNewsStoryCellId"


@interface RJMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZYBannerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)  RJMainViewController *__self;

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) UIButton *searchBtn;//搜索按钮

@property (nonatomic,strong) UIButton *rightBtn;//数据按钮


@property (nonatomic,assign) NSInteger page;

//轮播图
@property (nonatomic,strong) NSMutableArray<RJBannerInfo *> *bannerAds;

@property (nonatomic,strong) NSMutableArray<RJBannerInfo *> *bannerMoreAds;

@property (nonatomic,strong) NSMutableArray *randomList;//随便听听

@property (nonatomic,strong) NSMutableArray *sleepList;//今日睡前故事

@property (nonatomic,strong) NSMutableArray *likeList;//我喜欢的列表

@property (nonatomic,strong) NSMutableArray *collectList;//收藏列表

@property (nonatomic,strong) NSMutableArray *columnList;//专栏列表

@property (nonatomic,strong) NSMutableArray *newsList;//最新列表

@property (nonatomic,strong) NSMutableArray *columnListSubclass;

@property (nonatomic,strong) NSMutableArray *columnList1;
@property (nonatomic,strong) NSMutableArray *columnList2;
@property (nonatomic,strong) NSMutableArray *columnList3;
@property (nonatomic,strong) NSMutableArray *columnList4;


@property (nonatomic,strong) RJPlayView *playView;

@property (nonatomic,strong) NSMutableArray *playerList;//播放列表

@property (nonatomic,strong) UIView *playTableViewBgView;


@property (nonatomic,strong) UITableView *playTableView;//播放列表


/*定时器*/
@property(nonatomic,strong)NSTimer *timer;


@property (nonatomic,strong) RJHeadBannerCollectionReusableView *headBannerCollectionReusableView;//轮播图
@property (nonatomic,strong) RJMoreStoriesCollectionReusableView *moreStoriesCollectionReusableView;//更多故事
@property (nonatomic,strong) RJNewsStoryCollectionReusableView *newsStoryCollectionReusableView;//最新故事
@property (nonatomic,strong) RJSpecialColumnCollectionReusableView *specialColumnCollectionReusableView;//专栏
@property (nonatomic,strong) RJSpecialColumnOtherCollectionReusableView *specialColumnOtherCollectionReusableView;//专栏Other


@end

@implementation RJMainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

#pragma mark ---------------------------View Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
    [self setData];
    [self getStoryList:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self setSearchUI];
    [self playViewUI];
    [self playTableViewUI];
    
}

#pragma mark ---------------------------初始化
- (void)setData {
    
    self.page = 1;
    [self initBannerAds];
    self.randomList = [NSMutableArray array];
    self.sleepList = [NSMutableArray array];
    self.likeList = [NSMutableArray array];
    self.collectList = [NSMutableArray array];
    self.columnList = [NSMutableArray array];
    self.newsList = [NSMutableArray array];
    self.columnList1 = [NSMutableArray array];
    self.columnList2 = [NSMutableArray array];
    self.columnList3 = [NSMutableArray array];
    self.columnList4 = [NSMutableArray array];
    self.columnListSubclass = [NSMutableArray array];
    
}

#pragma mark ---初始化BannerAds
- (void)initBannerAds {
    self.bannerAds = [NSMutableArray array];
    //ad default banner image
    RJBannerInfo *defaultAd1 = [RJBannerInfo createWithName:@"1111"];
    RJBannerInfo *defaultAd2 = [RJBannerInfo createWithName:@"2222"];
    [self.bannerAds addObject:defaultAd1];
    [self.bannerAds addObject:defaultAd2];
    
    self.bannerMoreAds = [NSMutableArray array];
    //ad default banner image
    [self.bannerMoreAds addObject:defaultAd1];
    [self.bannerMoreAds addObject:defaultAd2];
    
}

#pragma mark ---------------------------UI
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.__self = self;
    //导航栏设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    //myCollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    self.myCollectionView.delegate = self.__self;
    self.myCollectionView.dataSource = self.__self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    //轮播图头视图
    [self.myCollectionView registerClass:[RJHeadBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRJHeadBannerCollectionReusableViewId];
    //更多故事
    [self.myCollectionView registerClass:[RJMoreStoriesCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kRJMoreStoriesCollectionReusableViewId];
    //最新故事
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJNewsStoryCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJNewsStoryCollectionReusableView"];
    //专栏
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJSpecialColumnCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJSpecialColumnCollectionReusableView"];
    //专栏Other
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJSpecialColumnOtherCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RJSpecialColumnOtherCollectionReusableView"];
    
    
    
    //随便听听
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJRandomCell" bundle:nil] forCellWithReuseIdentifier:kRJRandomCellId];
    //睡前故事
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJSleepCell" bundle:nil] forCellWithReuseIdentifier:kRJSleepCellId];
    
    //我喜欢的
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJLikesCell" bundle:nil] forCellWithReuseIdentifier:kRJLikesCellId];
    //收藏的专辑
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJCollectionCell" bundle:nil] forCellWithReuseIdentifier:kRJCollectionCellId];
    //最近播放的
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJRecentPlayCell" bundle:nil] forCellWithReuseIdentifier:kRJRecentPlayCellId];
    //最新故事
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJNewsStoryCell" bundle:nil] forCellWithReuseIdentifier:kRJNewsStoryCellId];
    
    
    [self.view addSubview:self.myCollectionView];
    
    if (@available(iOS 11.0, *)) {
        self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.__self.view);
//        make.height.mas_equalTo(self.__self.view);
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
    
}

#pragma mark ---搜索
- (void)setSearchUI {
    self.searchBtn = [[UIButton alloc] init];
    [self.view addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(27);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
    }];
    [self.searchBtn setImage:[UIImage imageNamed:@"SearchButton"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = [[UIButton alloc] init];
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(27);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.rightBtn setImage:[UIImage imageNamed:@"数据Button"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(dataRightAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---播放View
- (void)playViewUI {
    self.playView = [[RJPlayView alloc] init];
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.myCollectionView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(8);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-8);
        make.height.mas_equalTo(54);
    }];
    self.playView.layer.masksToBounds = YES;
    self.playView.layer.cornerRadius = 8;
    __weak RJMainViewController *weakSelf = self;
    
    //播放
    self.playView.playStoryAction = ^(RJStoryListModel *model, UIButton *playStoryBtn) {
//        [RJPlayerManager manager].musicArray = weakSelf.playerList;
        if ([RJPlayerManager manager].isFristPlayerPauseBtn==NO) {
            [weakSelf playerWithIndex:0];//标记是不是没点列表直接点了播放按钮如果是就默认播放按钮
        }else{
            [[RJPlayerManager manager] playAndPause];
        }
        //读取总时间
        if ([RJPlayerManager manager].isPlay) {
            [weakSelf.playView.playStoryBtn setImage:[UIImage imageNamed:@"列表暂停"] forState:UIControlStateNormal];
        }else{
            [weakSelf.playView.playStoryBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        }
    };
    
    //下一曲
    self.playView.nextStoryAction = ^(RJStoryListModel *model) {
        
        if (weakSelf.playerList.count > 0) {
            if ([RJPlayerManager manager].isPlay) {
                [[RJPlayerManager manager] playNext];
                [weakSelf playerWithIndex:[RJPlayerManager manager].index];
            }
        }else {
            [weakSelf playerWithIndex:0];
        }
        //读取总时间
        if ([RJPlayerManager manager].isPlay) {
            [weakSelf.playView.playStoryBtn setImage:[UIImage imageNamed:@"列表暂停"] forState:UIControlStateNormal];
        }else{
            [weakSelf.playView.playStoryBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        }
        
        [RJSignStoryIdSimple manager].isFirstClickedListPlayer=0;//第一次点击列表播放
    };
    
    //播放列表
    self.playView.playlistAction = ^(RJStoryListModel *model) {
        [weakSelf.playTableView reloadData];
        weakSelf.playTableViewBgView.hidden = !weakSelf.playTableViewBgView.hidden;
    };
    
//    [self.playView.playerSlider setValue: animated:YES];
    
}

#pragma mark ---playTableView
- (void)playTableViewUI {
    self.playTableViewBgView = [[UIView alloc] init];
    [self.view addSubview:self.playTableViewBgView];
    [self.playTableViewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.playView.mas_top);
    }];
    self.playTableViewBgView.backgroundColor = kColor(255, 255, 255, 0.2);
    
    UIView* headerBgView = [[UIView alloc] init];
    [self.playTableViewBgView addSubview:headerBgView];
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playTableViewBgView.mas_top).mas_offset(96);
        make.left.mas_equalTo(self.playTableViewBgView.mas_left).mas_offset(8);
        make.right.mas_equalTo(self.playTableViewBgView.mas_right).mas_offset(-8);
        make.height.mas_equalTo(42);
    }];
    headerBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *albumDetailsBtn = [[UIButton alloc] init];
    [headerBgView addSubview:albumDetailsBtn];
    [albumDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBgView);
        make.width.mas_equalTo((KScreenWidth - 16) / 3);
        make.left.mas_equalTo(headerBgView.mas_left);
        make.height.mas_equalTo(headerBgView.mas_height);
    }];
    [albumDetailsBtn setTitle:@"专辑详情" forState:UIControlStateNormal];
    [albumDetailsBtn setTitleColor:kColor(131, 131, 131, 1) forState:UIControlStateNormal];
    albumDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [albumDetailsBtn addTarget:self action:@selector(albumDetailsAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playerListBtn = [[UIButton alloc] init];
    [headerBgView addSubview:playerListBtn];
    [playerListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBgView);
        make.width.mas_equalTo((KScreenWidth - 16) / 3);
        make.left.mas_equalTo(albumDetailsBtn.mas_right);
        make.height.mas_equalTo(headerBgView.mas_height);
    }];
    [playerListBtn setTitle:@"播放列表" forState:UIControlStateNormal];
    [playerListBtn setTitleColor:kColor(33, 33, 33, 1) forState:UIControlStateNormal];
    playerListBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [playerListBtn addTarget:self action:@selector(playerListAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *historicalBtn = [[UIButton alloc] init];
    [headerBgView addSubview:historicalBtn];
    [historicalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBgView);
        make.width.mas_equalTo((KScreenWidth - 16) / 3);
        make.left.mas_equalTo(playerListBtn.mas_right);
        make.height.mas_equalTo(headerBgView.mas_height);
    }];
    [historicalBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [historicalBtn setTitleColor:kColor(131, 131, 131, 1) forState:UIControlStateNormal];
    historicalBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [historicalBtn addTarget:self action:@selector(historicalAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    [headerBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headerBgView.mas_bottom);
        make.width.mas_equalTo(headerBgView);
        make.left.mas_equalTo(headerBgView);
        make.height.mas_equalTo(2);
    }];
    lineView.backgroundColor = kColor(186, 186, 186, 1);
    
    self.playTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.playTableViewBgView addSubview:self.playTableView];
    [self.playTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playTableViewBgView.mas_top).mas_offset(96+42);
        make.left.mas_equalTo(self.playTableViewBgView.mas_left).mas_offset(8);
        make.right.mas_equalTo(self.playTableViewBgView.mas_right).mas_offset(-8);
        make.bottom.mas_equalTo(self.playTableViewBgView.mas_bottom);
    }];
    
    self.playTableView.delegate = self;
    self.playTableView.dataSource = self;
    self.playTableView.backgroundColor = [UIColor whiteColor];
    self.playTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.playTableView.showsVerticalScrollIndicator = NO;
    self.playTableView.scrollEnabled = YES;
    
    [self.playTableView registerNib:[UINib nibWithNibName:@"RJHomePlayListCell" bundle:nil]
         forCellReuseIdentifier:@"RJHomePlayListCell"];
    
  
    self.playTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.playTableViewBgView.hidden = YES;
}

#pragma mark ---------------------------Action
//播放时调用
- (void)playerWithIndex:(NSInteger)index {
    
    [RJPlayerManager manager].isFristPlayerPauseBtn = YES;
    // 寻找model
    RJStoryModel *model = [RJPlayerManager manager].musicArray[index];
    [RJSignStoryIdSimple manager].storyID = [NSString stringWithFormat:@"%ld",model.id];

    if ([RJSignStoryIdSimple manager].isFirstClickedListPlayer==0) {//第一次点击列表播放
        if ([RJPlayerManager manager].isStartPlayer) {
            [RJPlayerManager manager].isStartPlayer(0);
        }
    }
    [RJSignStoryIdSimple manager].isFirstClickedListPlayer = 1;
    
    [self reloadPlayUI:model];
    
    // 修改播放歌曲
    [[RJPlayerManager manager] replaceItemWithUrlString:model.url];
    
}

#pragma mark ---刷新播放UI {
- (void)reloadPlayUI:(RJStoryModel *)model {
    // 改变图片 标题 音频
    [self.playView.playerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
    
    //读取总时间
    if ([RJPlayerManager manager].isPlay) {
        [self.playView.playStoryBtn setImage:[UIImage imageNamed:@"列表暂停"] forState:UIControlStateNormal];
    }else{
        [self.playView.playStoryBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
    
    self.playView.playStoryName.text = model.title;
    
    NSString *time = [NSDate getHHMMSSFromSS:model.length];
    
    RJUserDefaultsSET(time, TOTALTIME);
    RJUserDefaultsSynchronize;
    self.playView.storyTime.text = time;
    [self lockScreen:time];
}

#pragma mark ---锁屏传值
-(void)lockScreen:(NSString *)totalTime {
    NSNumber *time = [NSNumber numberWithDouble:[totalTime doubleValue]];
    if ([RJPlayerManager manager].musicArray.count) {
        RJStoryModel *model = [RJPlayerManager manager].musicArray[[RJPlayerManager manager].index];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        //设置歌曲时长
        [info setObject:time forKey:MPMediaItemPropertyPlaybackDuration];
        [info setObject:[NSNumber numberWithDouble:0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //设置歌曲名
        info[MPMediaItemPropertyTitle] = model.title;
        //演唱者
        [info setObject:model.title forKey:MPMediaItemPropertyArtist];
        //设置歌手头像
        NSString *str=[NSString stringWithFormat:@"%@",model.thumb];
        NSString *url=[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //设置歌手头像
        if ([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]) {
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
            info[MPMediaItemPropertyArtwork] = artwork;
        }
        [info setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo =  info;
        //更新字典
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    }
}


#pragma mark ---专栏故事详情
- (void)getStoryDetails:(NSString *)titleString {
    RJStoryLabelDetailsController  *storyLabelDetailsViewController = [[RJStoryLabelDetailsController alloc] init];
    storyLabelDetailsViewController.labelString = titleString;
    [self.navigationController pushViewController:storyLabelDetailsViewController animated:YES];
}

#pragma mark ---搜索
- (void)searchAction {
    RJSearchViewController *searchVC = [[RJSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark ---数据统计
- (void)dataRightAction {
    
}

#pragma mark ---专辑详情
- (void)albumDetailsAction {
    
}

#pragma mark ---播放列表
- (void)playerListAction {
    
}

#pragma mark ---历史记录
- (void)historicalAction {
    
}

#pragma mark ---------------------------delegate
#pragma mark ZYBannerViewDelegate
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index {

}

#pragma mark ZYBannerViewDelegate
- (void)banner:(ZYBannerView *)banner didScrollToItemAtIndex:(NSInteger)index {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 8 + self.columnList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 0;
        }
            break;
        case 1: {
            //随便听听
            return self.randomList.count;
        }
            break;
        case 2: {
            // 睡前故事
            return self.sleepList.count;
        }
            break;
        case 3: {
            // 我喜欢的列表
            return self.likeList.count;
        }
        case 4: {
            // 我收藏的列表
            return self.collectList.count;
        }
            break;
        case 5: {
            // 专栏列表
            return 0;
        }
            break;
        case 6: {
            //更多故事
            return 0;
        }
        case 7: {
            //最新故事
            return self.newsList.count;
//            return 4;
        }
        case 8:{
            //专栏
            RJStoryListModel *model = [[RJStoryListModel alloc] init];
            model = self.columnList[0];
            for (NSDictionary *dic in model.storyList) {
                RJStoryModel *model = [[RJStoryModel alloc] init];
                [model initWithDictionary:dic];
                [self.columnList1 addObject:model];
            }
            return model.storyList.count;
        }
            break;
        case 9:{
            //专栏other
            RJStoryListModel *model = [[RJStoryListModel alloc] init];
            model = self.columnList[1];
            for (NSDictionary *dic in model.storyList) {
                RJStoryModel *model = [[RJStoryModel alloc] init];
                [model initWithDictionary:dic];
                [self.columnList2 addObject:model];
            }
            return model.storyList.count;
        }
            break;
        case 10:{
            //专栏other
            RJStoryListModel *model = [[RJStoryListModel alloc] init];
            model = self.columnList[2];
            for (NSDictionary *dic in model.storyList) {
                RJStoryModel *model = [[RJStoryModel alloc] init];
                [model initWithDictionary:dic];
                [self.columnList3 addObject:model];
            }
            return model.storyList.count;
        }
            break;
        case 11:{
            //专栏other
            RJStoryListModel *model = [[RJStoryListModel alloc] init];
            model = self.columnList[3];
            for (NSDictionary *dic in model.storyList) {
                RJStoryModel *model = [[RJStoryModel alloc] init];
                [model initWithDictionary:dic];
                [self.columnList4 addObject:model];
            }
            return model.storyList.count;
        }
            break;
        default: {
            return 0;
        }
            break;
    }}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    __weak typeof (self) weakSelf = self;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            //轮播图
            self.headBannerCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kRJHeadBannerCollectionReusableViewId forIndexPath:indexPath];
            self.headBannerCollectionReusableView.datas = self.bannerAds;
            self.headBannerCollectionReusableView.bannerView.delegate = self.__self;
            self.headBannerCollectionReusableView.bannerView.pageControlFrame = CGRectMake((KScreenWidth - 80) / 2, CGRectGetMaxY(self.headBannerCollectionReusableView.frame) - 20, 80, 20);
            return self.headBannerCollectionReusableView;
        }else if (indexPath.section == 6) {
            self.moreStoriesCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kRJMoreStoriesCollectionReusableViewId forIndexPath:indexPath];
            self.moreStoriesCollectionReusableView.datas = self.bannerMoreAds;
            self.moreStoriesCollectionReusableView.bannerView.delegate = self.__self;
            self.moreStoriesCollectionReusableView.bannerView.pageControlFrame = CGRectMake((KScreenWidth - 80) / 2, CGRectGetMaxY(self.moreStoriesCollectionReusableView.frame) - 20, 80, 20);
            return self.moreStoriesCollectionReusableView;
        }else if (indexPath.section == 7) {
            self.newsStoryCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJNewsStoryCollectionReusableView" forIndexPath:indexPath];
            return self.newsStoryCollectionReusableView;
        }else if (indexPath.section == 8 || indexPath.section == 10 || indexPath.section == 11){
            self.specialColumnCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJSpecialColumnCollectionReusableView" forIndexPath:indexPath];
            self.specialColumnCollectionReusableView.model = self.columnList[indexPath.section - 8];
            self.specialColumnCollectionReusableView.moreAction = ^(UIButton *sender, UILabel *label) {
                [weakSelf getStoryDetails:label.text];
            };
            return self.specialColumnCollectionReusableView;
        }else if (indexPath.section == 9){
            self.specialColumnOtherCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJSpecialColumnOtherCollectionReusableView" forIndexPath:indexPath];
            self.specialColumnOtherCollectionReusableView.model = self.columnList[1];
            self.specialColumnOtherCollectionReusableView.moreAction = ^(UIButton *sender, UILabel *label) {
                [weakSelf getStoryDetails:label.text];
            };
            return self.specialColumnOtherCollectionReusableView;
        }
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //随便听听
        RJRandomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJRandomCellId forIndexPath:indexPath];
        cell.model =  self.randomList[indexPath.row];
        cell.randomPlayAction = ^(RJStoryListModel *model, UIButton *playButton) {
            if (model.storyList.count > 0) {
                [self.playerList removeAllObjects];
                for (NSDictionary *dic in model.storyList) {
                    RJStoryModel *model = [[RJStoryModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.playerList addObject:model];
                }
            }else {
                return ;
            }
            [RJPlayerManager manager].musicArray = self.playerList;
            if ([RJPlayerManager manager].isFristPlayerPauseBtn==NO) {
                [self.__self playerWithIndex:0];//标记是不是没点列表直接点了播放按钮如果是就默认播放按钮
            }else{
                [[RJPlayerManager manager] playAndPause];
            }
            //读取总时间
            if ([RJPlayerManager manager].isPlay) {
                [playButton setImage:[UIImage imageNamed:@"列表暂停"] forState:UIControlStateNormal];
            }else{
                [playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
            }
        };
        return cell;
    }else if(indexPath.section == 2) {
        //今日睡眠故事
        RJSleepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJSleepCellId forIndexPath:indexPath];
        cell.model =  self.sleepList[indexPath.row];
        cell.sleepPlayAction = ^(RJStoryListModel *model, UIButton *playButton) {
            if (model.storyList.count > 0) {
                [self.playerList removeAllObjects];
                for (NSDictionary *dic in model.storyList) {
                    RJStoryModel *model = [[RJStoryModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.playerList addObject:model];
                }
            }else {
                return ;
            }
            [RJPlayerManager manager].musicArray = self.playerList;
            if ([RJPlayerManager manager].isFristPlayerPauseBtn==NO) {
                [self.__self playerWithIndex:0];//标记是不是没点列表直接点了播放按钮如果是就默认播放按钮
            }else{
                [[RJPlayerManager manager] playAndPause];
            }
            //读取总时间
            if ([RJPlayerManager manager].isPlay) {
                [playButton setImage:[UIImage imageNamed:@"列表暂停"] forState:UIControlStateNormal];
            }else{
                [playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
            }
        };
        return cell;
    }else if(indexPath.section == 3) {
        //我喜欢的
        RJLikesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJLikesCellId forIndexPath:indexPath];
        cell.model =  self.likeList[indexPath.row];
        return cell;
    }else if(indexPath.section == 4) {
        //收藏的专辑
        RJCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJCollectionCellId forIndexPath:indexPath];
        cell.model =  self.collectList[indexPath.row];
        return cell;
    }else if(indexPath.section == 5) {
        //最近播放
        RJRecentPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJRecentPlayCellId forIndexPath:indexPath];
        cell.model =  self.columnList[indexPath.row];
        return cell;
    }else if(indexPath.section == 7) {
        //最新故事
        RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
//        cell.model = self.newsList[indexPath.row];
        return cell;
    }else if(indexPath.section == 8) {
        //专栏
        RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
        cell.model = self.columnList1[indexPath.row];
        return cell;
    }else if(indexPath.section == 9) {
        //专栏
        RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
        cell.model = self.columnList2[indexPath.row];
        return cell;
    }else if(indexPath.section == 10) {
        //专栏
        RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
        cell.model = self.columnList3[indexPath.row];
        return cell;
    }else if(indexPath.section == 11) {
        //专栏
        RJNewsStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRJNewsStoryCellId forIndexPath:indexPath];
        cell.model = self.columnList4[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   if (section == 0) {
        // 广告栏
        return CGSizeMake(KScreenWidth, kHomeBannerHeight);
    }else if (section == 6) {
        return CGSizeMake(KScreenWidth, kHomeBannerHeight + 40);
    }else if (section == 7 || section == 8 || section == 10 || section == 11) {
        return CGSizeMake(KScreenWidth, 80);
    }else if (section == 9) {
        return CGSizeMake(KScreenWidth, 302);
    }
        return CGSizeMake(0, 0);
    
}

#pragma mark   UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //随便听听
        RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
        albumDetailsVC.storyListModel = self.randomList[indexPath.row];
        [self.navigationController pushViewController:albumDetailsVC animated:YES];
    }else if(indexPath.section == 2) {
        //今日睡眠故事
        RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
        albumDetailsVC.storyListModel = self.sleepList[indexPath.row];
        [self.navigationController pushViewController:albumDetailsVC animated:YES];
    }else if(indexPath.section == 3) {
        //我喜欢的
        RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
        albumDetailsVC.storyListModel = self.likeList[indexPath.row];
        [self.navigationController pushViewController:albumDetailsVC animated:YES];
    }else if(indexPath.section == 4) {
        //收藏的专辑
        RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
        albumDetailsVC.storyListModel = self.collectList[indexPath.row];
        [self.navigationController pushViewController:albumDetailsVC animated:YES];
    }else if(indexPath.section == 5) {
        //最近播放
        RJAlbumDetailsController *albumDetailsVC = [[RJAlbumDetailsController alloc] init];
        albumDetailsVC.storyListModel = self.columnList[indexPath.row];
        [self.navigationController pushViewController:albumDetailsVC animated:YES];
    }else if(indexPath.section == 8) {
        RJStoryDetailsViewController *storyDetailsViewController = [[RJStoryDetailsViewController alloc] init];
        storyDetailsViewController.storyModel = self.columnList1[indexPath.row];
        [self.navigationController pushViewController:storyDetailsViewController animated:YES];
    }else if(indexPath.section == 9) {
        //专栏
        RJStoryDetailsViewController *storyDetailsViewController = [[RJStoryDetailsViewController alloc] init];
        storyDetailsViewController.storyModel = self.columnList2[indexPath.row];
        [self.navigationController pushViewController:storyDetailsViewController animated:YES];
    }else if(indexPath.section == 10) {
        //专栏
        RJStoryDetailsViewController *storyDetailsViewController = [[RJStoryDetailsViewController alloc] init];
        storyDetailsViewController.storyModel = self.columnList3[indexPath.row];
        [self.navigationController pushViewController:storyDetailsViewController animated:YES];
    }else if(indexPath.section == 11) {
        //专栏
        RJStoryDetailsViewController *storyDetailsViewController = [[RJStoryDetailsViewController alloc] init];
        storyDetailsViewController.storyModel = self.columnList4[indexPath.row];
        [self.navigationController pushViewController:storyDetailsViewController animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        // 随便听听
        return CGSizeMake(KScreenWidth, 178 );
    }
    else if (indexPath.section == 2) {
        // 睡前故事
        return CGSizeMake(KScreenWidth, 100);
    }
    else if (indexPath.section == 3) {
        // 我喜欢的
        return CGSizeMake(KScreenWidth, 100);
    }else if (indexPath.section == 4) {
        // 我收藏的
        return CGSizeMake(KScreenWidth, 100);
    }else if (indexPath.section == 5) {
        // 专栏
        return CGSizeMake(KScreenWidth, 100);
    }else if (indexPath.section == 7 || indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 10 || indexPath.section == 11) {
        // 最新故事
        return CGSizeMake((KScreenWidth - 24) / 2, 220);
    }else {
        return CGSizeMake(0, 0);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2 || section == 3 || section == 4) {
        return UIEdgeInsetsMake(8, 0, 0, 0);
    }else if (section == 5) {
        return UIEdgeInsetsMake(0, 0, 30, 0);
    }else if (section == 7 || section == 8 || section == 10 || section == 11) {
        return UIEdgeInsetsMake(0, 8, 0, 8);
    }else if (section == 9) {
        return UIEdgeInsetsMake(0, 8, 0, 8);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark tableView Delegate和DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJHomePlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RJHomePlayListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.playerList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ---------------------------NetWork
#pragma mark ---故事首页
- (void)getStoryList:(BOOL )isrefresh {
    [RJHttpRequest postStoryIndexWithPage:self.page callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            if (isrefresh) {
                [self.randomList removeAllObjects];
                [self.sleepList removeAllObjects];
                [self.likeList removeAllObjects];
                [self.collectList removeAllObjects];
                [self.columnList removeAllObjects];
                [self.newsList removeAllObjects];
                [self.bannerAds removeAllObjects];
                [self.bannerMoreAds removeAllObjects];
                [self.columnList1 removeAllObjects];
                [self.columnList2 removeAllObjects];
                [self.columnList3 removeAllObjects];
                [self.columnList4 removeAllObjects];
            }
            NSDictionary *storyListDic = result[@"data"];
            if (storyListDic && storyListDic.count > 0) {
                NSArray *randomArr = storyListDic[@"randomList"];
                NSArray *sleepArr = storyListDic[@"sleepList"];
                NSArray *likeArr = storyListDic[@"likeList"];
                NSArray *collectArr = storyListDic[@"collectList"];
                NSArray *columnArr = storyListDic[@"columnList"];
                NSArray *newsArr = storyListDic[@"newList"];
                NSArray *banner = storyListDic[@"banner"];
                NSArray *bannerMore = storyListDic[@"bannerMore"];
                
                //轮播图
                if (banner && banner.count > 0) {
                    for (NSDictionary *dic in banner) {
                        RJBannerInfo *model = [[RJBannerInfo alloc] init];
                        [model initWithDictionary:dic];
                        [self.bannerAds addObject:model];
                    }
                }
                if (bannerMore && bannerMore.count > 0) {
                    for (NSDictionary *dic in bannerMore) {
                        RJBannerInfo *model = [[RJBannerInfo alloc] init];
                        [model initWithDictionary:dic];
                        [self. bannerMoreAds addObject:model];
                    }
                }
                
                //随便听听
                if (randomArr && randomArr.count > 0) {
                    for (NSDictionary *dic in randomArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.randomList addObject:model];
                    }
                }
                //今日睡前故事
                if (sleepArr && sleepArr.count > 0) {
                    for (NSDictionary *dic in sleepArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.sleepList addObject:model];
                    }
                }
                //我喜欢的列表
                if (likeArr && likeArr.count > 0) {
                    for (NSDictionary *dic in likeArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.likeList addObject:model];
                    }
                }
                //收藏列表
                if (collectArr && collectArr.count > 0) {
                    for (NSDictionary *dic in collectArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.collectList addObject:model];
                    }
                }
                //专栏列表
                if (columnArr && columnArr.count > 0) {
                    for (NSDictionary *dic in columnArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.columnList addObject:model];
                    }
                }
                
                
                //最新故事
                if (newsArr && newsArr.count > 0) {
                    for (NSDictionary *dic in newsArr) {
                        RJStoryListModel *model = [[RJStoryListModel alloc] init];
                        [model initWithDictionary:dic];
                        [self.newsList addObject:model];
                    }
                }
                RJStoryListModel *albumModel = self.randomList[0];
                self.playView.playerTitle.text = albumModel.title;
                if (self.playerList.count > 0 && self.playerList) {
                    
                }else {
                    self.playerList = [NSMutableArray array];
                    if (albumModel.storyList.count > 0) {
                        for (NSDictionary *dic in albumModel.storyList) {
                            RJStoryModel *model = [[RJStoryModel alloc] init];
                            [model initWithDictionary:dic];
                            [self.playerList addObject:model];
                        }
                    }
                    RJStoryModel *playStoryModel = self.playerList[0];
                    [RJPlayerManager manager].index = 0;
                    self.playView.playStoryName.text = playStoryModel.title;
                    NSString *time = [NSDate getHHMMSSFromSS:playStoryModel.length];
                    self.playView.storyTime.text = time;
                    [RJPlayerManager manager].musicArray = self.playerList;
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
