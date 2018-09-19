//
//  RJStoryDetailsViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJStoryDetailsViewController.h"
#import "RJCommentsCell.h"
#import "RJCommentModel.h"

@interface RJStoryDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *storyImg;

@property (weak, nonatomic) IBOutlet UILabel *storyName;

@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UITextView *content;

@property (nonatomic,strong) RJStoryModel *showStoryModel;

@property (nonatomic,strong) UIView *viewBG;

@property (nonatomic,strong) UITableView *commentsTableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *commentsList;

@property (nonatomic,strong) UILabel *commentsNumLabel;

@property (nonatomic,strong) UITextView *commentsTextView;

@property (nonatomic,strong) UIView *commentsFooterView;

@property (nonatomic,strong) UILabel *promptLabel;


@end

@implementation RJStoryDetailsViewController

#pragma mark ---------------------------View Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    [self setInfo];
    [self getStoryDetail];
    [self getCommentsList:YES];
}

- (void)setData {
    self.showStoryModel = [[RJStoryModel alloc] init];
    self.page = 1;
    self.commentsList = [NSMutableArray array];
}

- (void)setUI {
    self.viewBG = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.viewBG];
    self.viewBG.backgroundColor  = [UIColor clearColor];
    
    self.commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, KScreenWidth, KScreenHeight - 60 - 110) style:UITableViewStyleGrouped];
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentsTableView.backgroundColor = [UIColor whiteColor];
    self.commentsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.commentsTableView.showsVerticalScrollIndicator = NO;
    self.commentsTableView.scrollEnabled = YES;
    [self.viewBG addSubview:self.commentsTableView];
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"RJCommentsCell" bundle:nil]
                 forCellReuseIdentifier:@"RJCommentsCell"];
    self.viewBG.hidden = YES;
    
    UIView *commentsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, KScreenWidth, 40)];
    commentsHeaderView.backgroundColor = [UIColor whiteColor];
    [self.viewBG addSubview:commentsHeaderView];
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:commentsHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = commentsHeaderView.bounds;
    maskLayer.path = maskPath.CGPath;
    commentsHeaderView.layer.mask = maskLayer;
    
    self.commentsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth, 40)];
    [commentsHeaderView addSubview:self.commentsNumLabel];
    self.commentsNumLabel.textAlignment = NSTextAlignmentLeft;
    self.commentsNumLabel.text = @"全部评论";
    self.commentsNumLabel.font = [UIFont systemFontOfSize:20];
    self.commentsNumLabel.textColor = kColor(33, 33, 33, 1);
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 40, 0, 40, 40)];
    [commentsHeaderView addSubview:cancelBtn];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTabelViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader * headerView = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getCommentsList:YES];
    }];
    
    self.commentsTableView.mj_header = headerView;
    
    UIView *topLineView = [[UIView alloc] init];
    [self.viewBG addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentsTableView.mas_bottom);
        make.width.mas_equalTo(KScreenWidth);
        make.centerX.mas_equalTo(self.viewBG);
        make.height.mas_equalTo(1);
    }];
    topLineView.backgroundColor = kColor(230, 230, 230, 1);
    
    self.commentsFooterView = [[UIView alloc] init];
    [self.viewBG addSubview:self.commentsFooterView];
    [self.commentsFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLineView.mas_bottom);
        make.left.mas_equalTo(self.viewBG.mas_left);
        make.right.mas_equalTo(self.viewBG.mas_right);
        make.bottom.mas_equalTo(self.viewBG.mas_bottom);
    }];
    self.commentsFooterView.backgroundColor = [UIColor whiteColor];
    
    self.commentsTextView = [[UITextView alloc] init];
    [self.commentsFooterView addSubview:self.commentsTextView];
    [self.commentsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentsFooterView.mas_left).mas_offset(24);
        make.right.mas_equalTo(self.commentsFooterView.mas_right).mas_offset(-30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.commentsFooterView);
    }];
    self.commentsTextView.font = [UIFont systemFontOfSize:14];
    self.commentsTextView.backgroundColor = [UIColor clearColor];
    self.commentsTextView.delegate = self;
    self.commentsTextView.returnKeyType = UIReturnKeySend;
    
    self.promptLabel = [[UILabel alloc] init];
    [self.commentsFooterView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.commentsFooterView);
        make.left.mas_equalTo(self.commentsFooterView.mas_left).mas_offset(30);
    }];
    self.promptLabel.text = @"写下你的评论";
    self.promptLabel.textColor = kColor(102, 102, 102, 1);
    self.promptLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *lineView = [[UIView alloc] init];
    [self.commentsFooterView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentsTextView.mas_bottom);
        make.width.mas_equalTo(self.commentsTextView);
        make.centerX.mas_equalTo(self.commentsTextView);
        make.height.mas_equalTo(1);
    }];
    lineView.backgroundColor = kColor(230, 230, 230, 1);
    
    UIButton *sendCommentsBtn = [[UIButton alloc] init];
    [self.commentsFooterView addSubview:sendCommentsBtn];
    [sendCommentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentsFooterView.mas_top);
        make.left.mas_equalTo(self.commentsTextView.mas_right);
        make.right.mas_equalTo(self.commentsFooterView.mas_right);
        make.bottom.mas_equalTo(self.commentsFooterView.mas_bottom);
    }];
    [sendCommentsBtn setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    sendCommentsBtn.backgroundColor = [UIColor whiteColor];
    [sendCommentsBtn addTarget:self action:@selector(sendCommentsAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInfo {
    [self.storyImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,self.showStoryModel.thumb]] placeholderImage:KDefaultImage];
    
    self.storyName.text = self.showStoryModel.title;
    self.content.attributedText = [[NSAttributedString alloc] initWithData:[self.showStoryModel.descriptions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [self.likeBtn setImage:self.showStoryModel.likes ? [UIImage imageNamed:@"喜欢拷贝"] : [UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    [self.likeBtn setTitle:self.showStoryModel.is_like ? [NSString stringWithFormat:@"喜欢+%ld",(long)self.showStoryModel.is_like] : @"喜欢" forState:UIControlStateNormal];
    [self.commentsBtn setTitle:self.showStoryModel.comments > 0 ? [NSString stringWithFormat:@"评论+%ld",(long)self.showStoryModel.comments] : @"评论" forState:UIControlStateNormal];
}

#pragma mark tableView Delegate和DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJCommentModel *model = self.commentsList[indexPath.row];
    NSString* string =  model.content;

    CGSize commentSize = [string ql_fontSizeWithFont:[UIFont systemFontOfSize:16] andMaxWidth:KScreenWidth - 54];
 
    return commentSize.height + 40;
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
    titelLabel.text = @"没有评论了";
    titelLabel.textColor = [UIColor lightGrayColor];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    return bgView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RJCommentsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.commentsList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark --textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    self.promptLabel.hidden = existTextNum > 0 ? YES : NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        [self sendCommentsAction];
        
        return NO;
        
    }
    
    return YES;
    
}


#pragma mark ---------------------------netWork
- (void)getStoryDetail {
    [RJHttpRequest postStoryDetailWithStoryId:self.storyModel.id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSDictionary *dic = result[@"data"];
            if (dic && dic.count > 0) {
                [self.showStoryModel initWithDictionary:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setInfo];
                });
            }
        }
    }];
}

#pragma mark ---------------------------Action
#pragma mark ---分享
- (IBAction)sharedAction:(id)sender {
    
}

#pragma mark ---评论
- (IBAction)commentsAtion:(id)sender {
    self.viewBG.hidden = !self.viewBG.hidden;
}

#pragma mark ---隐藏评论
- (void)cancelTabelViewAction {
    self.viewBG.hidden = YES;
}

#pragma mark ---发表评论
- (void)sendCommentsAction {
    [self sendComments];
}

#pragma mark ---喜欢
- (IBAction)likeAtion:(id)sender {
    if (self.showStoryModel.likes) {
        [self getStoryDelLike];
    }else {
        [self getStoryLike];
    }
}

#pragma mark ---播放
- (IBAction)playAction:(id)sender {
    
}

#pragma mark ---------------------------netWork
#pragma mark ---点赞
- (void)getStoryLike {
    [RJHttpRequest postLikeAddWithStory_id:self.showStoryModel.id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            self.showStoryModel.is_like = self.showStoryModel.is_like + 1;
            self.showStoryModel.likes = [NSString stringWithFormat:@"%d",1];
            [self.likeBtn setImage:[UIImage imageNamed:@"喜欢拷贝"] forState:UIControlStateNormal];
            [self.commentsBtn setTitle:self.showStoryModel.is_like > 0 ? [NSString stringWithFormat:@"喜欢+%ld",(long)self.showStoryModel.is_like] : @"喜欢" forState:UIControlStateNormal];
        }
    }];
}

#pragma mark ---删除点赞
- (void)getStoryDelLike {
    [RJHttpRequest postLikeDelWithStory_id:self.showStoryModel.id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            self.showStoryModel.is_like = self.showStoryModel.is_like - 1;
            self.showStoryModel.likes = [NSString stringWithFormat:@"%d",0];
            [self.likeBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
            [self.commentsBtn setTitle:self.showStoryModel.is_like > 0 ? self.showStoryModel.is_like > 0 ? [NSString stringWithFormat:@"喜欢+%ld",(long)self.showStoryModel.is_like] : @"喜欢" : @"喜欢" forState:UIControlStateNormal];
        }
    }];
}

#pragma mark ---评论列表
- (void)getCommentsList:(BOOL )isrefresh {
    [RJHttpRequest postCommentListWithPage:self.page story_id:self.storyModel.id callback:^(NSDictionary *result) {
        [self.commentsTableView.mj_header endRefreshing];
        if ([result ql_boolForKey:@"status"]) {
            NSArray *dataArr = result[@"data"];
            if (isrefresh) {
                [self.commentsList removeAllObjects];
            }
            if (dataArr && dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    RJCommentModel *model = [[RJCommentModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.commentsList addObject:model];
                }
            }
            [self.commentsTableView reloadData];
        }
    }];
}

#pragma mark ---添加评论
- (void)sendComments {
    if (self.commentsTextView.text.length < 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入评论";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    [RJHttpRequest postCommentAddWithStory_id:self.storyModel.id content:self.commentsTextView.text callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"评论成功";
            [hud hideAnimated:YES afterDelay:1];
            self.showStoryModel.comments = self.showStoryModel.comments  + 1;
            [self.commentsBtn setTitle:self.showStoryModel.comments  > 0 ? [NSString stringWithFormat:@"评论+%ld",(long)self.showStoryModel.comments] : @"评论" forState:UIControlStateNormal];
            [self getCommentsList:YES];
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
