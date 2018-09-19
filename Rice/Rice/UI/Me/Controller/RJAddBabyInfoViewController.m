//
//  RJAddBabyInfoViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJAddBabyInfoViewController.h"

@interface RJAddBabyInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;

@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *addBadyBtn;

@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,copy) NSString *dateStr;

@end

@implementation RJAddBabyInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
}

- (void)setData {
    self.sex = 0;
}

#pragma mark ---------------------------UI
- (void)setUI {
    self.addBadyBtn.layer.masksToBounds = YES;
    self.addBadyBtn.layer.cornerRadius = 5;
    
    NSDate *maxDate = [NSDate date];
    NSTimeInterval interval = 365 * 10 * 24 * 60 * 60;
    NSDate *minDate = [maxDate initWithTimeIntervalSinceNow: - interval];
    self.datePicker.maximumDate = maxDate;
    self.datePicker.minimumDate = minDate;

}

#pragma mark ---------------------------action
#pragma mark ---sex
- (IBAction)maleAction:(id)sender {
    self.maleBtn.backgroundColor = [UIColor lightGrayColor];
    self.femaleBtn.backgroundColor = [UIColor clearColor];
    self.sex = 1;
}

- (IBAction)femaleAction:(id)sender {
    self.femaleBtn.backgroundColor = [UIColor lightGrayColor];
    self.maleBtn.backgroundColor = [UIColor clearColor];
    self.sex = 2;
}

#pragma mark ---addBady
- (IBAction)addBadyAction:(id)sender {
    if (self.sex == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请选择性别";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }else if ([NSString ql_isEmpty:self.dateStr]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请选择宝宝生日";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }else {
        if (self.familyListModel.family_name) {
            [self addFamilyChild:self.familyListModel.id child_sex:self.sex child_birth:self.dateStr];
        }else {
            [self addFamily:self.relationship child_sex:self.sex child_birth:self.dateStr];
        }
    }
}

- (IBAction)chooseTimeAction:(id)sender {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    self.dateStr = [formatter stringFromDate:date];
}

#pragma mark ---back
- (IBAction)backVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------------------netWork
- (void)addFamily:(NSString *)member_relation child_sex:(NSInteger )child_sex child_birth:(NSString *)child_birth {
    [RJHttpRequest postFamilyAddWithMember_relation:member_relation child_sex:child_sex child_birth:child_birth callback:^(NSDictionary *result) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([result ql_boolForKey:@"status"]) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"添加成功";
            [hud hideAnimated:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)addFamilyChild:(NSInteger )family_id child_sex:(NSInteger )child_sex child_birth:(NSString *)child_birth {
    [RJHttpRequest postChildAddWithFamily_id:family_id sex:child_sex birth:child_birth callback:^(NSDictionary *result) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([result ql_boolForKey:@"status"]) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"添加成功";
            [hud hideAnimated:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
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
