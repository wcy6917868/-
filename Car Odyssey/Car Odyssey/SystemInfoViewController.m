//
//  SystemInfoViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/18.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "SystemInfoViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface SystemInfoViewController ()

@end

@implementation SystemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"系统消息";
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
    self.view.backgroundColor = RGB(238, 238, 238);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENW/2-30*SCREENW_RATE, 132*SCREENW_RATE, 60*SCREENW_RATE, 60*SCREENW_RATE)];
    imageV.image = [UIImage imageNamed:@"Shape-77"];
    [self.view addSubview:imageV];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150*SCREENW_RATE, 50*SCREENW_RATE)];
    textL.center = CGPointMake(SCREENW/2, CGRectGetMaxY(imageV.frame)+25*SCREENW_RATE);
    textL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    textL.textColor = RGB(170, 170, 170);
    textL.textAlignment = NSTextAlignmentCenter;
    textL.text = @"暂时还没有系统消息!";
    [self.view addSubview:textL];
                               
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
