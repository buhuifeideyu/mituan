//
//  RJSettingViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/7.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJSettingViewController.h"
#import "YYFileUploader.h"
#import "YYUploadImageInfo.h"
#import "YYImageHelper.h"
#import "RJCallPhoneAlertView.h"
#import "RJWebViewController.h"
#import "RJFeedbackViewController.h"

@interface RJSettingViewController ()<UITableViewDelegate,UITableViewDataSource,YYFileUploadDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *settingArr;

@property (nonatomic,strong) NSString *headImgString;// 头像地址

@property (nonatomic, strong) YYFileUploader *fileUploader;

@property (nonatomic, strong) UIImage * currentImage;//头像照片

@property (nonatomic, strong) MBProgressHUD  *uploadFileHud;

@property (nonatomic,weak)  RJSettingViewController *__self;

@property (nonatomic,strong) UIImageView *headerView;

@property (nonatomic,strong) UILabel *nickName;

@property (nonatomic,strong) UIButton *modificationBtn;

@property (nonatomic,strong) UIButton *weixinBtn;

@property (nonatomic,strong) UIButton *phoneBtn;

@property (nonatomic,strong) UIButton *qqbtn;

@property (nonatomic,strong) NSDictionary *setDic;


@end

@implementation RJSettingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
    [self getSettingList];
}

- (void)setData {
    
    self.__self = self;
    self.settingArr = [NSMutableArray arrayWithObjects:
                  @"消息提醒",
                  @"帮助说明",
                  @"意见反馈",
                  @"联系客服",
                  @"版本信息",
                  @"给个好评",
                  @"分享APP",
                  @"检查更新",
                  nil];
    self.fileUploader = [YYFileUploader createUploader];
    self.fileUploader.delegate = self;
    self.currentImage = nil;
    
    self.setDic = [NSDictionary dictionary];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.__self.view);
        make.height.mas_equalTo(self.__self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
}

#pragma mark tableView Delegate和DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 220)];
    headerBgView.backgroundColor = kNavColor;
    
    //头像
    self.headerView = [[UIImageView alloc] init];
    [headerBgView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerBgView.mas_top).mas_offset(20);
        make.centerX.mas_equalTo(headerBgView);
        make.height.mas_equalTo(93);
        make.width.mas_equalTo(93);
    }];
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,[RJUserHelper shareInstance].lastLoginUserInfo.head]] placeholderImage:[UIImage imageNamed:@"shangchuantouxian"]];
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.cornerRadius = 93 / 2;
    self.headerView.userInteractionEnabled = YES;
    
    
    //昵称
    self.nickName = [[UILabel alloc] init];
    [headerBgView addSubview:self.nickName];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(headerBgView);
    }];
    self.nickName.text = [RJUserHelper shareInstance].lastLoginUserInfo.nickname;
    self.nickName.textColor = [UIColor whiteColor];
    self.nickName.textAlignment = NSTextAlignmentCenter;
    self.nickName.font = [UIFont systemFontOfSize:15];
    
    //修改
    self.modificationBtn = [[UIButton alloc] init];
    [headerBgView addSubview:self.modificationBtn];
    [self.modificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.nickName);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    [self.modificationBtn setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    [self.modificationBtn addTarget:self action:@selector(modificationAction) forControlEvents:UIControlEventTouchUpInside];
    
    //微信
    self.weixinBtn = [[UIButton alloc] init];
    [headerBgView addSubview:self.weixinBtn];
    [self.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerBgView.mas_left).mas_offset(20);
        make.bottom.mas_equalTo(headerBgView.mas_bottom).mas_offset(-16);
        make.height.mas_equalTo(30);
    }];
    [self.weixinBtn setImage:[UIImage imageNamed:@"bangdingweixin~"] forState:UIControlStateNormal];
    [self.weixinBtn setTitle:@"绑定微信" forState:UIControlStateNormal];
    [self.weixinBtn setTitleColor:kColor(78, 77, 77, 1) forState:UIControlStateNormal];
    self.weixinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.weixinBtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
    
    //手机
    self.phoneBtn = [[UIButton alloc] init];
    [headerBgView addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerBgView);
        make.centerY.mas_equalTo(self.weixinBtn);
        make.height.mas_equalTo(self.weixinBtn);
        make.width.mas_equalTo(self.weixinBtn);
    }];
    [self.phoneBtn setImage:[UIImage imageNamed:@"bangdingshouji~"] forState:UIControlStateNormal];
    [self.phoneBtn setTitle:@"绑定手机" forState:UIControlStateNormal];
    [self.phoneBtn setTitleColor:kColor(78, 77, 77, 1) forState:UIControlStateNormal];
    self.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    
    //QQ
    self.qqbtn = [[UIButton alloc] init];
    [headerBgView addSubview:self.qqbtn];
    [self.qqbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerBgView.mas_right).mas_offset(-20);
        make.centerY.mas_equalTo(self.weixinBtn);
        make.height.mas_equalTo(self.weixinBtn);
    }];
    [self.qqbtn setImage:[UIImage imageNamed:@"bangdingqq~"] forState:UIControlStateNormal];
    [self.qqbtn setTitle:@"绑定QQ" forState:UIControlStateNormal];
    [self.qqbtn setTitleColor:kColor(78, 77, 77, 1) forState:UIControlStateNormal];
    self.qqbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.qqbtn addTarget:self action:@selector(qqAction) forControlEvents:UIControlEventTouchUpInside];
    
    return headerBgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *loginOutBtn = [[UIButton alloc] init];
    [footerView addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.top.mas_equalTo(footerView.mas_top).mas_offset(30);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(KScreenWidth * 0.33);
    }];
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.layer.cornerRadius = 5;
    loginOutBtn.backgroundColor = kNavColor;
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingcell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.settingArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        RJCallPhoneAlertView * moreView = [[RJCallPhoneAlertView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) phoneNum:self.setDic[@"OFFICIAL_TEL"]];
        moreView.continueAction = ^(UIButton *continueButton) {
            [self.view addSubview:[RJCallPhoneAlertView callPhoneClickWithWebViewWithCallPhoneNum:self.setDic[@"OFFICIAL_TEL"]]];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:moreView];
    }else if (indexPath.row == 5) {
        RJWebViewController *webVC = [[RJWebViewController alloc] init];
        webVC.title_str = @"给个好评";
        webVC.remoteURL = self.setDic[@"DOWNLOAD_URL_IOS"];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.row == 1) {
        RJWebViewController *webVC = [[RJWebViewController alloc] init];
        webVC.title_str = @"帮助说明";
        webVC.remoteURL = self.setDic[@"HELP"];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.row) {
        RJFeedbackViewController *feedbackViewController = [[RJFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
}

#pragma mark ---------------------------Action
#pragma mark ---退出登录
- (void)loginOutAction {
    [RJHttpRequest postLoginOutCallback:^(NSDictionary *result) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([result ql_boolForKey:@"status"]) {
            [[RJUserHelper shareInstance] userLogout];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"退出登录";
            [hud hideAnimated:YES afterDelay:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark ---获取配置信息
- (void)getSettingList {
    [RJHttpRequest postAppConfigCallback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            self.setDic = result[@"data"];
        }
    }];
}

- (void)modificationAction {
    YYEditView *edit = [[YYEditView alloc] init];
    [edit showEditViewWithTitil:@"修改昵称" andName:nil canBeEmpty:NO];
    edit.returnTextBlock = ^(NSString *text){
        self.nickName.text = text;
        [self updateUserInfoWithNickname:text];
    };
}

#pragma mark ---------------------------newtWork
#pragma mark ---修改个人信息
- (void)updateUserInfoWithNickname:(NSString *)nickname  {
    
        [RJHttpRequest postUserSetWithEmain:nil nickname:nickname sex:nil  birthday:nil sign:nil job:nil info:nil province:nil city:nil now_city:nil callback:^(NSDictionary *result) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([result ql_boolForKey:@"status"]) {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"修改成功";
                [hud hideAnimated:YES afterDelay:1];
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
