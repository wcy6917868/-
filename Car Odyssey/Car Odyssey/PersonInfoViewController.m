//
//  PersonInfoViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/17.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "PersonInfoViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"个人信息中心";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
}

- (void)configUI
{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, 90*SCREENW_RATE)];
    headV.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 70*SCREENW_RATE, 90*SCREENW_RATE)];
    label.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    label.textColor = RGB(51, 51, 51);
    label.text = @"用户昵称";
    [headV addSubview:label];
    [self.view addSubview:headV];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59*SCREENW_RATE, 59*SCREENW_RATE)];
    imageV.center = CGPointMake(SCREENW - 70*SCREENW_RATE, CGRectGetMidY(headV.frame));
    imageV.image = [UIImage imageNamed:@"touxiang0@2x"];
    [self.view addSubview:imageV];
    
    UIImageView *cameraV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)-18*SCREENW_RATE, CGRectGetMaxY(imageV.frame)-18*SCREENW_RATE, 18*SCREENW_RATE, 18*SCREENW_RATE)];
    cameraV.image = [UIImage imageNamed:@"huantouxinag0@2x"];
    [self.view addSubview:cameraV];
    
    UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
    arrowV.center = CGPointMake(CGRectGetMaxX(imageV.frame)+16*SCREENW_RATE,CGRectGetMidY(headV.frame));
    arrowV.image = [UIImage imageNamed:@"arrow_right@2x"];
    [self.view addSubview:arrowV];
    
    NSArray *titleArr = @[@"用户昵称",@"城市",@"性别",@"年龄"];
    for (int i = 0; i < 4; i ++)
    {
        UILabel *infoL = [[UILabel alloc]initWithFrame:CGRectMake(0, ((CGRectGetMaxY(headV.frame)+10)+ i*50)*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
        infoL.backgroundColor = [UIColor whiteColor];
        infoL.textColor = RGB(51, 51, 51);
        infoL.layer.borderColor = RGB(238, 238, 238).CGColor;
        infoL.layer.borderWidth = 0.5f;
        infoL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        infoL.userInteractionEnabled = YES;
        infoL.text = [NSString stringWithFormat:@"   %@",titleArr[i]];
         [self.view addSubview:infoL];
        if (i == 0)
        {
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREENW - 155*SCREENW_RATE, infoL.frame.origin.y+1*SCREENW_RATE, 140*SCREENW_RATE, 48*SCREENW_RATE)];
            tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            tf.backgroundColor = [UIColor whiteColor];
            [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"起个独特的名字吧" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
            tf.clearsOnBeginEditing = YES;
            [self.view insertSubview:tf aboveSubview:infoL];
        }
        else if (i == 1)
        {
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREENW - 125*SCREENW_RATE, infoL.frame.origin.y+1, 110*SCREENW_RATE, 48*SCREENW_RATE)];
            tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            tf.backgroundColor = [UIColor whiteColor];
            tf.textColor = RGB(51, 51, 51);
            tf.text = @"上海市宝山区";
            tf.clearsOnBeginEditing = YES;
            [self.view insertSubview:tf aboveSubview:infoL];
        }
        else if (i == 2)
        {
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREENW - 105*SCREENW_RATE, infoL.frame.origin.y+1*SCREENW_RATE, 90*SCREENW_RATE, 48*SCREENW_RATE)];
            tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            tf.backgroundColor = [UIColor whiteColor];
            [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"男生or女生" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
            tf.clearsOnBeginEditing = YES;
            [self.view insertSubview:tf aboveSubview:infoL];
        }
        else if (i == 3)
        {
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREENW - 75*SCREENW_RATE, infoL.frame.origin.y+1*SCREENW_RATE, 60*SCREENW_RATE, 48*SCREENW_RATE)];
            tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            tf.backgroundColor = [UIColor whiteColor];
            [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"几零后" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
            tf.clearsOnBeginEditing = YES;
            [self.view insertSubview:tf aboveSubview:infoL];
        }
       
    }
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    
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
