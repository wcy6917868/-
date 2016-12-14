//
//  PostDrivingLicenceViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "PostDrivingLicenceViewController.h"
#import "Ultitly.h"
#import "NetManager.h"
#define postImageAPI @"http://115.29.246.88:9999/common/upload"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface PostDrivingLicenceViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *driveImage1;
    UIImageView *driveImage2;
    UIImagePickerController *picker1;
    UIImagePickerController *picker2;
}

@end

@implementation PostDrivingLicenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [btn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.title = @"上传证件照";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)configUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15 *SCREENW_RATE, 79*SCREENW_RATE, 345*SCREENW_RATE, 120*SCREENW_RATE)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*SCREENW_RATE, 30*SCREENW_RATE)];
    label1.textColor = RGB(136, 136, 136);
    label1.center = CGPointMake(86*SCREENW_RATE, 60*SCREENW_RATE);
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"驾驶证照片";
    [view addSubview:label1];
    
    driveImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(168*SCREENW_RATE, 15 *SCREENW_RATE, 160*SCREENW_RATE, 90*SCREENW_RATE)];
    if ([Ultitly shareInstance].driverA == nil)
    {
        driveImage1.image = [UIImage imageNamed:@"polaroid"];
    }
    else
    {
        driveImage1.image = [Ultitly shareInstance].driverA;
    }
    driveImage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postDrive)];
    [driveImage1 addGestureRecognizer:tap];
    [view addSubview:driveImage1];
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(15 *SCREENW_RATE, CGRectGetMaxY(view.frame)+1*SCREENW_RATE, 345*SCREENW_RATE, 120*SCREENW_RATE)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*SCREENW_RATE, 30*SCREENW_RATE)];
    label2.textColor = RGB(136, 136, 136);
    label2.center = CGPointMake(86*SCREENW_RATE, 60*SCREENW_RATE);
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"驾驶证照片";
    [view1 addSubview:label2];
    
    driveImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(168*SCREENW_RATE, 15 *SCREENW_RATE, 160*SCREENW_RATE, 90*SCREENW_RATE)];
    if ([Ultitly shareInstance].driverB == nil)
    {
       driveImage2.image = [UIImage imageNamed:@"polaroid"];
    }
    else
    {
        driveImage2.image = [Ultitly shareInstance].driverB;
    }
    
    driveImage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postDriveL2)];
    [driveImage2 addGestureRecognizer:tap1];
    [view1 addSubview:driveImage2];
    [self.view addSubview:view1];
    
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(21*SCREENW_RATE, CGRectGetMaxY(view1.frame)+10*SCREENW_RATE, 335*SCREENW_RATE, 20*SCREENW_RATE)];
    noticeL.text = @"文件尺寸最大不超过2M,照片支持Jpg/png等常规格式";
    noticeL.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
    noticeL.textColor = RGB(136, 136, 136);
    [self.view addSubview:noticeL];
    
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, SCREENH - 95*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    postBtn.backgroundColor = RGB(37, 155, 255);
    [postBtn setTitle:@"确定" forState:UIControlStateNormal];
    [postBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [postBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postDrive
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        picker1 = [[UIImagePickerController alloc]init];
        picker1.delegate = self;
        picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker1.allowsEditing = YES;
        [self presentViewController:picker1 animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        picker1 = [[UIImagePickerController alloc]init];
        picker1.delegate = self;
        picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker1.allowsEditing = YES;
        [self presentViewController:picker1 animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)postDriveL2
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        picker2 = [[UIImagePickerController alloc]init];
        picker2.delegate = self;
        picker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker2.allowsEditing = YES;
        [self presentViewController:picker2 animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        picker2 = [[UIImagePickerController alloc]init];
        picker2.delegate = self;
        picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker2.allowsEditing = YES;
        [self presentViewController:picker2 animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    if (picker == picker1) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [Ultitly shareInstance].driverA = image;
        NSData *imageData = UIImagePNGRepresentation(image);
        driveImage1.image = image;
        [[NetManager shareManager]requestUrlPostImage:postImageAPI andParameter:nil withImageData:imageData withSuccessBlock:^(id data)
        {
            if ([data[@"status"]isEqualToString:@"9000"])
            {
            [Ultitly shareInstance].driver_a = data[@"data"][@"path"];

            }
            else if ([data[@"status"]isEqualToString:@"1000"])
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
            }
            
        }
        andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
        }];
       
    }
    else if (picker == picker2)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [Ultitly shareInstance].driverB = image;
        NSData *imageData = UIImagePNGRepresentation(image);
        driveImage2.image = image;
        [[NetManager shareManager]requestUrlPostImage:postImageAPI andParameter:nil withImageData:imageData withSuccessBlock:^(id data)
         {
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                  [Ultitly shareInstance].driver_b = data[@"data"][@"path"];
             }
             else if ([data[@"status"]isEqualToString:@"1000"])
             {
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                 [alertC addAction:action];
                 [self presentViewController:alertC animated:YES completion:nil];
             }
         }
         andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
}

- (void)surePost
{
    if ([Ultitly shareInstance].driver_a != nil && [Ultitly shareInstance].driver_b != nil)
    {
        _block(@"gou");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将驾驶证正面以及反面照片全部上传" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:nil];
        [alertC addAction:cancelAC];
        [self presentViewController:alertC animated:YES completion:nil];
    }
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
