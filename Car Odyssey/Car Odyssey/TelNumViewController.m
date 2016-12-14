//
//  TelNumViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "TelNumViewController.h"
#import "ChangeTelNumViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface TelNumViewController ()

@end

@implementation TelNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(255, 255, 255);
    self.navigationItem.title = @"手机号";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)back
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44*SCREENW_RATE, 44*SCREENW_RATE)];
    imageV.center = CGPointMake(SCREENW/2, 104*SCREENW_RATE);
    imageV.image = [UIImage imageNamed:@"sjh_dq"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+12*SCREENW_RATE, SCREENW, 31*SCREENW_RATE)];
    label.textColor = RGB(34, 34, 34);
    label.font = [UIFont systemFontOfSize:16];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [ud objectForKey:@"mobile"];
    label.text = [NSString stringWithFormat:@"您当前手机号为%@",mobile];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREENW, 20*SCREENW_RATE)];
    label1.textColor = RGB(136, 136, 136);
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"更换后个人信息不变,下次可以使用新手机号登录";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(0, SCREENH - 50*SCREENW_RATE, SCREENW, 50*SCREENW_RATE);
    changeBtn.backgroundColor = [UIColor whiteColor];
    [changeBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    [changeBtn setTitleColor:RGB(37, 155, 255)forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
}

- (void)changeNum
{
    ChangeTelNumViewController *changeVC = [[ChangeTelNumViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
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
