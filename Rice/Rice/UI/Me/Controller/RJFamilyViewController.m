//
//  RJFamilyViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFamilyViewController.h"
#import "RJChoiceRelationshipViewController.h"
#import "RJSettingViewController.h"
#import "RJFamilyListModel.h"
#import "RJFamilyModel.h"
#import "RJFamilyMemberCell.h"
#import "RJAddChildCell.h"
#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "RJAddBabyInfoViewController.h"
#import "RJHomeTabBarViewController.h"
#import "RJMessageViewController.h"
#import "RJNavigationController.h"
#import "AppDelegate.h"
#import "RJChildInfoView.h"
#import "RJMemBerInfoView.h"
#import "RJFamilyFooterView.h"
#import "RJFamilySettingView.h"

@interface RJFamilyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YNPageScrollMenuViewDelegate>

@property (nonatomic,strong) UIView *noFamilyView;

@property (nonatomic,strong) NSMutableArray *meFamilyList;//家庭

@property (nonatomic,strong) NSMutableArray *childlist;//宝宝

@property (nonatomic,strong) NSMutableArray *memberlist;//家庭成员

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) UIButton *addChildBtn;//添加宝宝

@property (nonatomic,strong) NSMutableArray *tallyIDList;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) RJFamilyListModel *familyListModel;

@property (nonatomic,strong) RJFamilyFooterView *familyFooterView;


@end

@implementation RJFamilyViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
    [self setData];
    [self getFamilylist];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setAddFamilyView];
}

- (void)setData {
    self.meFamilyList = [NSMutableArray array];
    self.childlist = [NSMutableArray array];
    self.memberlist = [NSMutableArray array];
    self.tallyIDList = [NSMutableArray array];
    self.familyListModel = [[RJFamilyListModel alloc] init];
}

#pragma mark ---------------------------UI
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"setting" addTarget:self action:@selector(settingAction)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"xiaoxi" addTarget:self action:@selector(newsAction)];
    
    self.noFamilyView = [[UIView alloc] init];
    [self.view addSubview:self.noFamilyView];
    [self.noFamilyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    self.noFamilyView.backgroundColor = [UIColor whiteColor];
    
    //云朵
    UIImageView *cloud1 = [[UIImageView alloc] init];
    [self.noFamilyView addSubview:cloud1];
    [cloud1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.noFamilyView.mas_left).mas_offset(30);
        make.top.mas_equalTo(self.noFamilyView.mas_top).mas_offset(50);
    }];
    cloud1.image = [UIImage imageNamed:@"baiyun"];
    cloud1.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *cloud2 = [[UIImageView alloc] init];
    [self.noFamilyView addSubview:cloud2];
    [cloud2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.noFamilyView.mas_right).mas_offset(-30);
        make.bottom.mas_equalTo(self.noFamilyView.mas_bottom).mas_offset(-150);
    }];
    cloud2.image = [UIImage imageNamed:@"baiyun"];
    cloud2.contentMode = UIViewContentModeScaleAspectFill;
    
    //花
    UIImageView *flowers = [[UIImageView alloc] init];
    [self.noFamilyView addSubview:flowers];
    [flowers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.noFamilyView.mas_left).mas_offset(30);
        make.bottom.mas_equalTo(self.noFamilyView.mas_bottom).mas_offset(-50);
    }];
    flowers.image = [UIImage imageNamed:@"hua"];
    flowers.contentMode = UIViewContentModeScaleAspectFill;
    
    //添加按钮
    DLCustomButton *addFamily = [DLCustomButton buttonWithType:UIButtonTypeCustom withSpace:5];
    addFamily.buttonStyle = DLButtonImageTop;
    addFamily.padding = 2;
    [addFamily setImage:[UIImage imageNamed:@"tianjiabaobao"] forState:UIControlStateNormal];
    [addFamily setTitle:@"点击添加宝宝" forState:UIControlStateNormal];
    addFamily.titleLabel.font = [UIFont systemFontOfSize:16];
    [addFamily setTitleColor:kColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [self.noFamilyView addSubview:addFamily];
    [addFamily mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.noFamilyView.height - 60);
        make.width.mas_equalTo(KScreenWidth / 2);
        make.height.mas_equalTo(KScreenHeight / 2);
        make.centerX.mas_equalTo(self.noFamilyView);
    }];
    [addFamily addTarget:self action:@selector(addFamilyAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.noFamilyView.hidden = YES;
}

- (void)setAddFamilyView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    //宝宝
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJAddChildCell" bundle:nil] forCellWithReuseIdentifier:@"RJAddChildCell"];
    
    //家庭成员
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJFamilyMemberCell" bundle:nil] forCellWithReuseIdentifier:@"RJFamilyMemberCell"];
    
    //footerView
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"RJFamilyFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RJFamilyFooterView"];
    
    [self.view addSubview:self.myCollectionView];
    self.myCollectionView.hidden = YES;
    
    //添加宝宝
    self.addChildBtn = [[UIButton alloc] init];
    [self.view addSubview:self.addChildBtn];
    [self.addChildBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(120);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-(((((KScreenWidth - 60) / 2) / 2) - 40) /2));
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.addChildBtn setImage:[UIImage imageNamed:@"tianjiabaobao_3"] forState:UIControlStateNormal];
    [self.addChildBtn addTarget:self action:@selector(addChildAction) forControlEvents:UIControlEventTouchUpInside];
    self.addChildBtn.hidden = YES;
}

- (void)setheadListView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 150, 44)];
    self.scrollView.backgroundColor = kNavColor;
    self.navigationItem.titleView = self.scrollView;
    
    YNPageConfigration *style_config_2 = [YNPageConfigration defaultConfig];
    style_config_2.showBottomLine = YES;
    style_config_2.bottomLineBgColor = kNavColor;
    style_config_2.bottomLineHeight = 1;
    style_config_2.scrollViewBackgroundColor = kNavColor;
    style_config_2.showAddButton = YES;
    style_config_2.addButtonNormalImageName = @"icon-more";

    YNPageScrollMenuView *style_2 = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, 0, KScreenWidth - 150, 44) titles:self.tallyIDList.mutableCopy configration:style_config_2 delegate:self currentIndex:0];
    [self.scrollView addSubview:style_2];
}

- (void)pagescrollMenuViewItemOnClick:(UIButton *)label index:(NSInteger)index {
    if ([label.titleLabel.text isEqualToString:@"+"] && index == self.tallyIDList.count - 1) {
        [self addFamilyAction];
    }else {
        self.familyListModel = self.meFamilyList[index];
        [self getChildslist:self.familyListModel.id];
        [self getFamilyMemberslist:self.familyListModel.id];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0: {
            return self.childlist.count;
        }
            break;
        case 1: {
            return self.memberlist.count;
        }
            break;
        default: {
            return 0;
        }
            break;
    }}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionFooter) {
        __weak typeof (self) weakSelf = self;
        if (indexPath.section == 1) {
            self.familyFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RJFamilyFooterView" forIndexPath:indexPath];
            self.familyFooterView.invitationAction = ^(UIButton *sender) {
                
            };
            self.familyFooterView.exitFamilyAction = ^(UIButton *sender) {
                [weakSelf familySetting:weakSelf.familyListModel];
            };
            return self.familyFooterView;
        }
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //添加宝宝
        RJAddChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJAddChildCell" forIndexPath:indexPath];
        cell.model = self.childlist[indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
        //家庭成员
        RJFamilyMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RJFamilyMemberCell" forIndexPath:indexPath];
        cell.model = self.memberlist[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 
    return CGSizeMake(0, 0);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 1) {
        // 底部View
        return CGSizeMake(KScreenWidth, 144);
    }
    return CGSizeMake(0, 0);
}

#pragma mark   UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RJFamilyModel *model = self.childlist[indexPath.row];
        [self editChildInfo:model];
    }else if (indexPath.section == 1) {
        RJFamilyModel *model = self.memberlist[indexPath.row];
        [self editMemberInfo:model];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 添加宝宝
        return CGSizeMake((KScreenWidth - 60) / 2, 280);
    }
    else if (indexPath.section == 1) {
        // 家庭成员
        return CGSizeMake((KScreenWidth - 200) / 3, 90);
    }
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        // 添加宝宝
        if (self.childlist.count == 1) {
            return UIEdgeInsetsMake(0, (((KScreenWidth - 60) / 2) / 2), 0, (((KScreenWidth - 60) / 2) / 2));
        }
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    else if (section == 1) {
        // 家庭成员
        return UIEdgeInsetsMake(30, 30, 0, 30);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




#pragma mark ---添加家庭
- (void)addFamilyAction {
    RJChoiceRelationshipViewController *choiceRelationshipVC = [[RJChoiceRelationshipViewController alloc] init];
    [self.navigationController pushViewController:choiceRelationshipVC animated:YES];
}

- (void)addChildAction {
    RJAddBabyInfoViewController *addBabyInfoViewController = [[RJAddBabyInfoViewController alloc] init];
    addBabyInfoViewController.familyListModel = self.familyListModel;
    [self.navigationController pushViewController:addBabyInfoViewController animated:YES];
}

#pragma mark ---设置
- (void)settingAction {
    RJSettingViewController *settingVC = [[RJSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark ---修改宝宝信息
- (void)editChildInfo:(RJFamilyModel *)model {
    RJChildInfoView * moreView = [[RJChildInfoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) model:model];
    moreView.deleteAction = ^(UIButton *sender) {
        [self delChild:model.id];
    };
    
    moreView.nameEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改昵称" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = text;
            [self childInfoEdit:model.id sex:nil birth:nil child_name:text device:nil];
        };
    };
    moreView.birthDayEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改生日" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"生日：%@",text];
            [self childInfoEdit:model.id sex:nil birth:text child_name:text device:nil];
        };
        
    };
    
    moreView.sexEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改性别" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"性别：%@",text];
            [self childInfoEdit:model.id sex:[text isEqualToString:@"男"] ? 1 : [text isEqualToString:@"男"] ? 2 : 0  birth:text child_name:text device:nil];
        };
    };
    
    moreView.relationshipEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改关系" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"与宝宝的关系：%@",text];
            [self childInfoEdit:model.id sex:nil birth:text child_name:text device:nil];
        };
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}

#pragma mark ---修改家庭成员信息
- (void)editMemberInfo:(RJFamilyModel *)model {
    RJMemBerInfoView * moreView = [[RJMemBerInfoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) model:model];
    moreView.deleteAction = ^(UIButton *sender) {
        [self familyMemberDel:model.id];
    };
    
    moreView.nameEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改昵称" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = text;
            [self memberInfoEdit:model.id nickname:text relation:nil sex:nil];
        };
    };
    
    moreView.relationshipEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改与宝宝的关系" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"与宝宝的关系：%@",text];;
           
        };
    };
    
    moreView.remarkEditorAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改备注" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"备注：%@",text];;
            
        };
    };
    
    moreView.jurisdictionAction = ^(UIButton *sender, UILabel *label) {
        YYEditView *edit = [[YYEditView alloc] init];
        [edit showEditViewWithTitil:@"修改权限" andName:nil canBeEmpty:NO];
        edit.returnTextBlock = ^(NSString *text){
            label.text = [NSString stringWithFormat:@"权限设置：%@",text];;
            
        };
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}

#pragma mark ---家庭设置
- (void)familySetting:(RJFamilyListModel *)model {
    RJFamilySettingView * moreView = [[RJFamilySettingView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) model:model];
    moreView.exitAction = ^(UIButton *sender) {
        [self delFamily:model.id];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:moreView];
}


#pragma mark ---消息
- (void)newsAction {
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        RJHomeTabBarViewController *tabViewController = (RJHomeTabBarViewController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:2];

}

#pragma mark ---------------------------netWork
#pragma mark ---获取家庭列表
- (void)getFamilylist {
    [RJHttpRequest postFamilyListCallback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *arr = result[@"data"];
            [self.meFamilyList removeAllObjects];
            [self.tallyIDList removeAllObjects];
            if (arr && arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    RJFamilyListModel *model = [[RJFamilyListModel alloc] init];
                    [model initWithDictionary:dic];
//                    if (model.memberList.count > 0) {
//                        for (NSDictionary *memberdic in model.memberList) {
//                            RJFamilyModel *memberModel = [[RJFamilyModel alloc] init];
//                            [memberModel initWithDictionary:memberdic];
//                        }
//                    }
                    [self.meFamilyList addObject:model];
                    [self.tallyIDList addObject:model.family_name];
                }
            }
            if (self.meFamilyList.count > 0) {
                self.myCollectionView.hidden = NO;
                self.noFamilyView.hidden = YES;
                [self.tallyIDList addObject:@"+"];
                self.familyListModel = self.meFamilyList[0];
                [self getChildslist:self.familyListModel.id];
                [self getFamilyMemberslist:self.familyListModel.id];
            }else {
                self.myCollectionView.hidden = YES;
                self.noFamilyView.hidden = NO;
                [self.tallyIDList addObject:@"我的家"];
                [self.tallyIDList addObject:@"+"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setheadListView];
            });
        }else {
            [self.tallyIDList removeAllObjects];
            self.addChildBtn.hidden = YES;
            self.myCollectionView.hidden = YES;
            self.noFamilyView.hidden = NO;
        }
    }];
}

#pragma mark ---获取宝宝列表
- (void)getChildslist:(NSInteger )family_id {
    [RJHttpRequest postChildListWithFamily_id:family_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *arr = result[@"data"];
            [self.childlist removeAllObjects];
            if (arr && arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    RJFamilyModel *model = [[RJFamilyModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.childlist addObject:model];
                }
            }
            if (self.childlist.count == 1) {
                self.addChildBtn.hidden = NO;
            }else {
                self.addChildBtn.hidden = YES;
            }
            [self.myCollectionView reloadData];
        }
    }];
}


#pragma mark ---获取家庭成员列表
- (void)getFamilyMemberslist:(NSInteger )family_id {
    [RJHttpRequest postFamilyMemberListWithFamily_id:family_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            NSArray *arr = result[@"data"];
            [self.memberlist removeAllObjects];
            if (arr && arr.count > 0) {
                for (NSDictionary *dic in arr) {
                    RJFamilyModel *model = [[RJFamilyModel alloc] init];
                    [model initWithDictionary:dic];
                    [self.memberlist addObject:model];
                }
            }
            [self.myCollectionView reloadData];
        }
    }];
}

#pragma mark ---退出家庭
- (void)exitFamily:(NSInteger )family_id {
    [RJHttpRequest postFamilyMemberQuitWithFamily_id:family_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getFamilylist];
        }
    }];
}

#pragma mark ---删除成员
- (void)familyMemberDel:(NSInteger )member_id {
    [RJHttpRequest postFamilyMemberDelWithMember_id:member_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getFamilylist];
        }
    }];
}

#pragma mark ---成员信息修改
- (void)memberInfoEdit:(NSInteger )member_id nickname:(NSString *)nickname relation:(NSString *)relation sex:(NSInteger )sex {
    [RJHttpRequest postFamilyMemberEditWithMember_id:member_id nickname:nickname relation:relation sex:sex callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getFamilylist];
        }
    }];
}

#pragma mark ---宝宝信息修改
- (void)childInfoEdit:(NSInteger )child_id sex:(NSInteger )sex birth:(NSString *)birth child_name:(NSString *)child_name device:(NSString *)device {
    [RJHttpRequest postChildEditWithChild_id:child_id sex:sex birth:birth child_name:child_name device:device callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getChildslist:self.familyListModel.id];
        }
    }];
}

#pragma mark ---家庭删除
- (void)delFamily:(NSInteger )family_id {
    [RJHttpRequest postFamilyDelWithFamily_id:family_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getFamilylist];
        }
    }];
}

#pragma mark ---删除宝宝
- (void)delChild:(NSInteger )child_id {
    [RJHttpRequest postChildDelWithChild_id:child_id callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            [self getChildslist:self.familyListModel.id];
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
