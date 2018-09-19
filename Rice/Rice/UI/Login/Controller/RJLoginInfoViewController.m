//
//  RJLoginInfoViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJLoginInfoViewController.h"
#import "RJHomeTabBarViewController.h"
#import "RJFamilyViewController.h"
#import "YYFileUploader.h"
#import "YYUploadImageInfo.h"
#import "YYImageHelper.h"
#import "AppDelegate.h"

#define UploaderTag 20180906

@interface RJLoginInfoViewController ()<YYFileUploadDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginApp;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;

@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,strong) NSString *headImgString;// 头像地址

@property (nonatomic, strong) YYFileUploader *fileUploader;

@property (nonatomic, strong) UIImage * currentImage;//头像照片

@property (nonatomic, strong) MBProgressHUD  *uploadFileHud;

@end

@implementation RJLoginInfoViewController

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
    self.sex = 0;
    self.fileUploader = [YYFileUploader createUploader];
    self.fileUploader.delegate = self;
    self.currentImage = nil;
}

- (void)setUI {
    self.nameTextField.layer.masksToBounds = YES;
    self.nameTextField.layer.cornerRadius = 5;
    [self.nameTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.loginApp.layer.masksToBounds = YES;
    self.loginApp.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewAction)];
    [self.headerView addGestureRecognizer:tapGesturRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//进入App
- (IBAction)loginAppAction:(id)sender {
    [self updateUserInfo];
}

#pragma mark - tabBarController
- (void)createTabBarControllerAndPresent {
    
    RJHomeTabBarViewController *tabBarVC = [[RJHomeTabBarViewController alloc] init];
    [UIApplication sharedApplication].windows.firstObject.rootViewController = tabBarVC;
    
    [tabBarVC setSelectedIndex:3];
}

//点击男
- (IBAction)manAction:(id)sender {
    self.sex = 1;
    [self.maleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//点击女
- (IBAction)femaleAction:(id)sender {
    self.sex = 2;
    [self.femaleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//上传图片
- (void)headerViewAction {
    [self addPhoto];
}

- (void)addPhoto {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"上传"] message:@"请选择上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self photograph];
    }];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self getFromAlbum];
    }];
    UIAlertAction* defaultAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //取消退出
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alert addAction:defaultAction1];
    [alert addAction:defaultAction2];
    [alert addAction:defaultAction3];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 从相册中选择
- (void)getFromAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:nil];
}

// 拍照
- (void)photograph {
    
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"没有摄像头";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (!info) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    @autoreleasepool {
        UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
        
        NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
        UIImage *editImage = [UIImage imageWithData:data];
        
        self.uploadFileHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.uploadFileHud.label.text = @"图片上传中...";
        self.headerView.image = editImage;
        self.headerView.layer.masksToBounds = YES;
        self.headerView.layer.cornerRadius = self.headerView.height / 2;
        YYUploadImageInfo * imageTask = [YYUploadImageInfo createWithImage:editImage];
        
        imageTask.taskId = UploaderTag;
        
        [self.fileUploader addTask:imageTask];
        [self.fileUploader startUpload];
        
        image = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - YYFileUploadDelegate

- (void)didUploadFail:(id<YYFileUploadInfo>)task uploader:(YYFileUploader *)uploader{
    id<YYFileUploadInfo> logoTask = [uploader taskByID:UploaderTag];
    
    [YYImageHelper removeImageInPath:logoTask.localPath];
}

- (void)didAllTaskUploadFinish:(YYFileUploader *)uploader {
    if (self.uploadFileHud) {
        self.uploadFileHud.mode = MBProgressHUDModeText;
        self.uploadFileHud.label.text = @"正在提交";
    }
    
    id<YYFileUploadInfo> logoTask = [uploader taskByID:UploaderTag];
    
    [YYImageHelper removeImageInPath:logoTask.localPath];
    
    self.headImgString = logoTask.fileUrl;
    
    [self.fileUploader cleanTasks];
    
    if (self.headImgString) {
        [self updataImgInfo];
    }else {
        [self.uploadFileHud hideAnimated:YES afterDelay:1];
    }
    
}

#pragma mark ---------------------------UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]){
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}

#pragma mark ---------------------------netWork
#pragma mark ---提交头像
- (void)updataImgInfo {
    [RJHttpRequest postUserHeadSetWithHead:self.headImgString callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            self.uploadFileHud.label.text = @"头像设置成功";
            [self.uploadFileHud hideAnimated:YES afterDelay:1];
        }else {
            self.uploadFileHud.label.text = @"头像设置失败";
            [self.uploadFileHud hideAnimated:YES afterDelay:1];
        }
    }];
}

#pragma mark ---修改资料
- (void)updateUserInfo {
    if (self.nameTextField.text.length > 0) {
        [RJHttpRequest postUserSetWithEmain:nil nickname:self.nameTextField.text.length > 0 ? self.nameTextField.text : nil sex:self.sex  birthday:nil sign:nil job:nil info:nil province:nil city:nil now_city:nil callback:^(NSDictionary *result) {
            if ([result ql_boolForKey:@"status"]) {
                [self createTabBarControllerAndPresent];
            }
        }];
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入昵称";
        [hud hideAnimated:YES afterDelay:1];
    }
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
