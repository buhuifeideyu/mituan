//
//  RJMessageViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJMessageViewController.h"
#import "RJMessageCell.h"
#import "RJMessageModel.h"

@interface RJMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *messagelist;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger type;

@end

@implementation RJMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
    [self getmeesageListWithType:self.type isrefresh:YES];
}

- (void)setData {
    self.messagelist = [NSMutableArray array];
    self.page = 1;
    self.type = 0;
}

#pragma mark ---UI
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = YES;
    [self.view addSubview:self.tableView];
    
    MJRefreshGifHeader * headerView = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self getmeesageListWithType:self.type isrefresh:YES];
    }];
    self.tableView.mj_header = headerView;

    MJRefreshFooter * footerView = [MJRefreshFooter footerWithRefreshingBlock:^{
        self.page += self.page;
        [self getmeesageListWithType:self.type isrefresh:NO];
    }];
    self.tableView.mj_footer = footerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RJMessageCell" bundle:nil]
         forCellReuseIdentifier:@"RJMessageCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark tableView Delegate和DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, KScreenWidth, 44);
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    [bgView addSubview:titelLabel];
    titelLabel.text = @"无更多消息";
    titelLabel.textColor = [UIColor lightGrayColor];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    return bgView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagelist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RJMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.messagelist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ---------------------------netWork
- (void)getmeesageListWithType:(NSInteger )type isrefresh:(BOOL )isrefresh {
    [RJHttpRequest postMessageListWithPage:self.page type:self.type callback:^(NSDictionary *result) {
        [self.tableView.mj_header endRefreshing];
        if ([result ql_boolForKey:@"status"]) {
            if (isrefresh) {
                [self.messagelist removeAllObjects];
            }
            NSArray *dataArr = [result objectForKey:@"data"];
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    RJMessageModel *model = [[RJMessageModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.messagelist addObject:model];
                }
            }
        }
        [self.tableView reloadData];
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
