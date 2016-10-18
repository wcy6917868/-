//
//  ViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define SCREENW_RATE SCREENW/375

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = [UIColor yellowColor];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (void)initUI
{
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImage.image = [UIImage imageNamed:@"xx1.jpg"];
    [self.view addSubview:backgroundImage];
    
    UIButton *Logbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Logbtn.frame = CGRectMake(15*SCREENW_RATE, SCREENH - 97.5*SCREENW_RATE, 150*SCREENW_RATE, 50*SCREENW_RATE);
    [Logbtn.layer setMasksToBounds:YES];
    [Logbtn.layer setCornerRadius:5.0];
    [Logbtn setBackgroundColor:RGB(37, 155, 255)];
    [Logbtn setTitle:@"登录" forState:UIControlStateNormal];
    Logbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [Logbtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [Logbtn addTarget:self action:@selector(pushLog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Logbtn];
    
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48*SCREENW_RATE, 56*SCREENW_RATE)];
    carImage.center = CGPointMake(SCREENW/2, 94*SCREENW_RATE);
    carImage.image  = [UIImage imageNamed:@"logo_shouye@2x"];
    [self.view insertSubview:carImage aboveSubview:backgroundImage];
    
    UIImageView *BnxImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 260*SCREENW_RATE, 38*SCREENW_RATE)];
    BnxImage.center = CGPointMake(SCREENW/2, (CGRectGetMaxY(carImage.frame)+36)*SCREENW_RATE);
    BnxImage.image  = [UIImage imageNamed:@"cmxbnx@2x"];
    [self.view insertSubview:BnxImage aboveSubview:backgroundImage];
    
    UILabel *bnxL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*SCREENW_RATE, 36*SCREENW_RATE)];
    bnxL.center = CGPointMake(SCREENW/2, CGRectGetMaxY(BnxImage.frame)+18*SCREENW_RATE);
    bnxL.textColor = RGB(255, 255, 255);
    bnxL.textAlignment = NSTextAlignmentCenter;
    bnxL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    bnxL.text = @"大 数 据 - 共 享 经 济 - 环 保";
    
    [self.view insertSubview:bnxL aboveSubview:backgroundImage];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(CGRectGetMaxX(Logbtn.frame)+45*SCREENW_RATE, SCREENH - 97.5*SCREENW_RATE, 150*SCREENW_RATE, 50*SCREENW_RATE);
    [regBtn.layer setMasksToBounds:YES];
    [regBtn.layer setCornerRadius:5.0];
    [regBtn setBackgroundColor:[UIColor whiteColor]];
    [regBtn setTitle:@"加入" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [regBtn setTitleColor:RGB(3, 8, 25) forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(pushJoin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    
}

- (void)pushLog
{
    LoginViewController *LoginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

- (void)pushJoin
{
    RegisterViewController *regisVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regisVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
