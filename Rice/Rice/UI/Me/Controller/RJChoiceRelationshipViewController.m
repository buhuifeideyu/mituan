//
//  RJChoiceRelationshipViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/7.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJChoiceRelationshipViewController.h"
#import "RJAddBabyInfoViewController.h"

@interface RJChoiceRelationshipViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *grandpaBtn;//爷爷

@property (weak, nonatomic) IBOutlet UIButton *dadBtn;//爸爸

@property (weak, nonatomic) IBOutlet UIButton *motherBtn;//妈妈

@property (weak, nonatomic) IBOutlet UIButton *grandmotherBtn;//外婆

@property (weak, nonatomic) IBOutlet UIButton *grandfather;//外公

@property (weak, nonatomic) IBOutlet UIButton *grandma;//奶奶

@property (weak, nonatomic) IBOutlet UITextField *textField;//其他关系

@end

@implementation RJChoiceRelationshipViewController

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
    [self setUI];
}

#pragma mark ---------------------------UI
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
}

#pragma mark ---------------------------Action
#pragma mark ---返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//选择爷爷
- (IBAction)grandpaAction:(id)sender {
    [self addBabyInfo:@"爷爷"];
}

//选择爸爸
- (IBAction)dadAction:(id)sender {
    [self addBabyInfo:@"爸爸"];
}

//选择妈妈
- (IBAction)motherAction:(id)sender {
    [self addBabyInfo:@"妈妈"];
}

//选择外婆
- (IBAction)grandmotherAction:(id)sender {
    [self addBabyInfo:@"外婆"];
}

//选择外公
- (IBAction)grandfather:(id)sender {
    [self addBabyInfo:@"外公"];
}

//选择奶奶
- (IBAction)grandmaAction:(id)sender {
    [self addBabyInfo:@"奶奶"];
}

//选择其他关系
- (void)otherAction:(NSString *)relationStr {
    [self addBabyInfo:relationStr];
}

- (void)addBabyInfo:(NSString *)relation {
    RJAddBabyInfoViewController *addBabyInfoViewController = [[RJAddBabyInfoViewController alloc] init];
    addBabyInfoViewController.relationship = relation;
    [self.navigationController pushViewController:addBabyInfoViewController animated:YES];
}

#pragma mark ---------------------------UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self otherAction:textField.text];
        return NO;
    }
    
    return YES;
    
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
