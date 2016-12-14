//
//  CheManXingViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "CheManXingViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface CheManXingViewController ()

@end

@implementation CheManXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"关于车漫行";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    UIImageView *backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENH - 210*SCREENW_RATE, SCREENW, 210*SCREENW_RATE)];
    backGroundImage.image = [UIImage imageNamed:@"bg_guanyu"];
    [self.view addSubview:backGroundImage];
    
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*SCREENW_RATE, 80*SCREENW_RATE)];
    carImage.center = CGPointMake(SCREENW/2, 159*SCREENW_RATE);
    carImage.image = [UIImage imageNamed:@"logo3"];
    [self.view insertSubview:carImage aboveSubview:backGroundImage];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carImage.frame), SCREENW, 51*SCREENW_RATE)];
    label.text = @"大数据 - 共享经济 - 环保";
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:label aboveSubview:backGroundImage];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+183*SCREENW_RATE, SCREENW, 20*SCREENW_RATE)];
    label1.text = @"版本 V1.0";
    label1.textColor = RGB(68, 68, 68);
    label1.font = [UIFont systemFontOfSize:18];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:label1 aboveSubview:backGroundImage];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), SCREENW, 28*SCREENW_RATE)];
    label2.text = @"车 漫 行 软 件";
    label2.textColor = RGB(136, 136, 136);
    label2.font = [UIFont systemFontOfSize:12];
    label2 .textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:label2 aboveSubview:backGroundImage];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame), SCREENW, 28*SCREENW_RATE)];
    label3.text = @"copyright @ 2016 All Right reserved";
    label3.textColor = RGB(136, 136, 136);
    label3.font = [UIFont systemFontOfSize:12];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:label3 aboveSubview:backGroundImage];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
