//
//  CheckNewViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/17.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "CheckNewViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]


@interface CheckNewViewController ()

@end

@implementation CheckNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"版本更新";
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
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*SCREENW_RATE, 80*SCREENW_RATE)];
    imageV.image = [UIImage imageNamed:@"logo3"];
    imageV.center = CGPointMake(187.5*SCREENW_RATE,180*SCREENW_RATE);
    [self.view addSubview:imageV];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), 160*SCREENW_RATE, 30*SCREENW_RATE)];
    textL.font = [UIFont systemFontOfSize:14];
    textL.textColor = RGB(51, 51, 51);
    textL.text = @"监测到新版本V2.0.0.0";
    textL.center = CGPointMake(187.5*SCREENW_RATE, CGRectGetMaxY(imageV.frame)+15*SCREENW_RATE);
    textL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textL];
    
    UIButton *cancelUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelUpdate.frame = CGRectMake(70*SCREENW_RATE, CGRectGetMaxY(textL.frame)+50*SCREENW_RATE, 100*SCREENW_RATE, 40*SCREENW_RATE);
    cancelUpdate.layer.borderColor = RGB(51, 51, 51).CGColor;
    cancelUpdate.layer.borderWidth = 1.0f;
    [cancelUpdate setTitle:@"取消升级" forState:UIControlStateNormal];
    [cancelUpdate setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    cancelUpdate.layer.cornerRadius = 5.0f;
    cancelUpdate.layer.masksToBounds = YES;
    [cancelUpdate addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelUpdate];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(cancelUpdate.frame)+30*SCREENW_RATE, cancelUpdate.frame.origin.y, 100*SCREENW_RATE, 40*SCREENW_RATE);
    [sureBtn setTitle:@"确认升级" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
    sureBtn.layer.borderColor = RGB(37, 155, 255).CGColor;
    sureBtn.layer.borderWidth = 1.0f;
    sureBtn.layer.cornerRadius = 5.0f;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)update
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, SCREENH - 64*SCREENW_RATE)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_updateAPI]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
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
