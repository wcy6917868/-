//
//  WalkLienceViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "WalkLienceViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define postImageAPI @"http://115.29.246.88:9999/common/upload"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface WalkLienceViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *travelImageA;
    UIImageView *travelImageB;
    UIImagePickerController *pickerC1;
    UIImagePickerController *pickerC2;

}

@end

@implementation WalkLienceViewController

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
    label1.text = @"行驶证照片";
    [view addSubview:label1];
    
    travelImageA = [[UIImageView alloc]initWithFrame:CGRectMake(168*SCREENW_RATE, 15 *SCREENW_RATE, 160*SCREENW_RATE, 90*SCREENW_RATE)];
    if ([Ultitly shareInstance].travelA == nil)
    {
        travelImageA.image = [UIImage imageNamed:@"polaroid"];
    }
    else
    {
        travelImageA.image = [Ultitly shareInstance].travelA;
    }
    
    travelImageA.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postA)];
    [travelImageA addGestureRecognizer:tap];
    [view addSubview:travelImageA];
    [self.view addSubview:view];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(15 *SCREENW_RATE, CGRectGetMaxY(view.frame)+1*SCREENW_RATE, 345*SCREENW_RATE, 120*SCREENW_RATE)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120*SCREENW_RATE, 30*SCREENW_RATE)];
    label2.textColor = RGB(136, 136, 136);
    label2.center = CGPointMake(86*SCREENW_RATE, 60*SCREENW_RATE);
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"行驶证照片";
    [view1 addSubview:label2];
    
    travelImageB = [[UIImageView alloc]initWithFrame:CGRectMake(168*SCREENW_RATE, 15 *SCREENW_RATE, 160*SCREENW_RATE, 90*SCREENW_RATE)];
    if ([Ultitly shareInstance].travelB == nil)
    {
        travelImageB.image = [UIImage imageNamed:@"polaroid"];
    }
    else
    {
        travelImageB.image = [Ultitly shareInstance].travelB;
    }
    travelImageB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postB)];
    [travelImageB addGestureRecognizer:tap1];
    [view1 addSubview:travelImageB];
    [self.view addSubview:view1];
    
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(21*SCREENW_RATE, CGRectGetMaxY(view1.frame)+10, 335*SCREENW_RATE, 20*SCREENW_RATE)];
    noticeL.text = @"文件尺寸最大不超过2M,照片支持Jpg/png等常规格式";
    noticeL.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
    noticeL.textColor = RGB(136, 136, 136);
    [self.view addSubview:noticeL];
    
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, SCREENH - 95*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    postBtn.backgroundColor = RGB(37, 155, 255);
    [postBtn setTitle:@"确定" forState:UIControlStateNormal];
    [postBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [postBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postA
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        pickerC1 = [[UIImagePickerController alloc]init];
        pickerC1.delegate = self;
        pickerC1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerC1.allowsEditing = YES;
        [self presentViewController:pickerC1 animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        pickerC1 = [[UIImagePickerController alloc]init];
        pickerC1.delegate = self;
        pickerC1.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerC1.allowsEditing = YES;
        [self presentViewController:pickerC1 animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)postB
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        pickerC2 = [[UIImagePickerController alloc]init];
        pickerC2.delegate = self;
        pickerC2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerC2.allowsEditing = YES;
        [self presentViewController:pickerC2 animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        pickerC2 = [[UIImagePickerController alloc]init];
        pickerC2.delegate = self;
        pickerC2.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerC2.allowsEditing = YES;
        [self presentViewController:pickerC2 animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
    {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker == pickerC1)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [Ultitly shareInstance].travelA = image;
        NSData *imageData = UIImagePNGRepresentation(image);
        travelImageA.image = image ;
        [[NetManager shareManager]requestUrlPostImage:postImageAPI andParameter:nil withImageData:imageData withSuccessBlock:^(id data)
        {
            if ([data[@"status"]isEqualToString:@"9000"])
            {
               // NSLog(@"%@",data);
                [Ultitly shareInstance].travel_a = data[@"data"][@"path"];
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
            //NSLog(@"%@",error);
        }];
        
    }
    else if (picker == pickerC2)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [Ultitly shareInstance].travelB = image;
        NSData *imageData = UIImagePNGRepresentation(image);
        travelImageB.image = image;
        [[NetManager shareManager]requestUrlPostImage:postImageAPI andParameter:nil withImageData:imageData withSuccessBlock:^(id data)
         {
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 NSLog(@"%@",data);
                [Ultitly shareInstance].travel_b = data[@"data"][@"path"];
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

- (void)sure:(UIButton *)sureBtn
{
    if ([Ultitly shareInstance].travel_a != nil && [Ultitly shareInstance].travel_b != nil)
    {
        _block(@"gou@2x");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将行驶证正面以及反面照片全部上传" preferredStyle:UIAlertControllerStyleAlert];
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
