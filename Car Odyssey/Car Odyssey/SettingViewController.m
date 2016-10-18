//
//  SettingViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "SettingViewController.h"
#import "TelNumViewController.h"
#import "CheManXingViewController.h"
#import "DriverGuideViewController.h"
#import "CheckNewViewController.h"
#import "FeedBackViewController.h"
#import "NetManager.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define guideAPI @"http://139.196.179.91/carmanl/public/center/guide"
#define checkNewAPI @"http://139.196.179.91/carmanl/public/center/version"

@interface SettingViewController ()
{
    NSString *telNumStr;
    UIView *RedView;
    UIView *versionV;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"设置";
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
    UIView *telNumV = [[UIView alloc]initWithFrame:CGRectMake(0, 74*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
    telNumV.backgroundColor = [UIColor whiteColor];
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
    textL.textColor = RGB(51, 51, 51);
    textL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    textL.text = @"绑定手机";
    UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
    arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
    arrowM.image = [UIImage imageNamed:@"arrow_right@2x"];
    UILabel *telNumL = [[UILabel alloc]initWithFrame:CGRectMake(214*SCREENW_RATE, 0, 130*SCREENW_RATE, 50*SCREENW_RATE)];
    telNumL.font = [UIFont systemFontOfSize:16];
    telNumL.textColor = RGB(51, 51, 51);
    NSString *Str = @"11023443687";
    telNumStr = [Str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    telNumL.text =telNumStr;
    
    UITapGestureRecognizer *telTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toTelNum)];
    [telNumV addGestureRecognizer:telTap];
    [telNumV addSubview:arrowM];
    [telNumV addSubview:textL];
    [telNumV addSubview:telNumL];
    [self.view addSubview:telNumV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sound)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboult)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkGuide)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkNew)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(advice)];
    NSArray *TapArr = @[tap,tap1,tap2,tap3,tap4];
    NSArray *titleArr = @[@"音效开关",@"关于车漫行",@"查看司机接单指南",@"检查新版本",@"意见反馈"];
    
    for (int i = 0 ; i < 5; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(telNumV.frame)+(10+i*50)*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
        view.tag = 100+i;
        view.layer.borderWidth = .4;
        view.layer.borderColor = RGB(238, 238, 238).CGColor;
        view.backgroundColor = [UIColor whiteColor];
        UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
        textL.textColor = RGB(51, 51, 51);
        textL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        textL.text = titleArr[i];
        UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
        arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
        arrowM.image = [UIImage imageNamed:@"arrow_right@2x"];
         [view addSubview:arrowM];
        if (i == 0)
        {
            UISwitch *soundSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 80*SCREENW_RATE, 30*SCREENW_RATE)];
            soundSwitch.center = CGPointMake(SCREENW - 36*SCREENW_RATE, 25*SCREENW_RATE);
            soundSwitch.on = YES;
            soundSwitch.onTintColor = RGB(37, 155, 255);
            [view addSubview:soundSwitch];
            [arrowM removeFromSuperview];
        }
        else if (i == 3)
        {
           versionV = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40*SCREENW_RATE, 50*SCREENW_RATE)];
            label.center = CGPointMake(SCREENW - 50*SCREENW_RATE, 25*SCREENW_RATE);
            label.textColor = RGB(136, 136, 136);
            label.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            label.text = @"V1.0";
            [versionV addSubview:label];
        }
        [view addGestureRecognizer:TapArr[i]];
        [view addSubview:textL];
        [self.view addSubview:view];
        
        UIView *view5 = [self.view viewWithTag:104];
        UIButton *outLog = [UIButton buttonWithType:UIButtonTypeCustom];
        outLog.backgroundColor = [UIColor whiteColor];
        outLog.frame = CGRectMake(0, CGRectGetMaxY(view5.frame)+10*SCREENW_RATE, SCREENW, 50*SCREENW_RATE);
        outLog.titleLabel.font = [UIFont systemFontOfSize:16];
        [outLog setTitle:@"退出登录" forState:UIControlStateNormal];
        [outLog setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
        [self.view addSubview:outLog];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toTelNum
{
    TelNumViewController *telVC = [[TelNumViewController alloc]init];
    telVC.TelStr = telNumStr;
    [self.navigationController pushViewController:telVC animated:YES
     ];
}

- (void)sound
{
    
}

- (void)aboult
{
    CheManXingViewController *aboutVC = [[CheManXingViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)checkGuide
{
    DriverGuideViewController *driverVC = [[DriverGuideViewController alloc]init];
    NSString *str = guideAPI;
    driverVC.WebStr = str;
    [self.navigationController pushViewController:driverVC animated:YES];
}

- (void)checkNew
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"1" forKey:@"platform"];
    [paraDic setObject:@"1.0.0.0" forKey:@"version"];
    [[NetManager shareManager]requestUrlPost:checkNewAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        versionV.userInteractionEnabled = NO;
        NSLog(@"%@",data);
        if ([data[@"data"][@"url"]isEqualToString:@""])
        {
            RedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 64*SCREENW_RATE)];
            RedView.backgroundColor = [UIColor redColor];
            
            UIImageView *nikeM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24*SCREENW_RATE, 24*SCREENW_RATE)];
            nikeM.center = CGPointMake(150*SCREENW_RATE, 36*SCREENW_RATE);
            nikeM.image = [UIImage imageNamed:@"meiyouxinbanben@2x"];
            [RedView addSubview:nikeM];
            
            UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nikeM.frame)+10*SCREENW_RATE, nikeM.frame.origin.y, 150*SCREENW_RATE, 24*SCREENW_RATE)];
            textL.textColor = RGB(255, 254, 254);
            textL.font = [UIFont systemFontOfSize:15];
            textL.text = @"没有新版本";
            [RedView addSubview:textL];
            
            [[UIApplication sharedApplication].keyWindow addSubview:RedView];
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        }
        else
        {
            CheckNewViewController *CknVC = [[CheckNewViewController alloc]init];
            CknVC.updateAPI = data[@"data"][@"url"];
            [self.navigationController pushViewController:CknVC animated:YES];
        }
    }
    andFailedBlock:^(NSError *error)
    {
        NSLog(@"%@",error);
    }];
}

- (void)advice
{
    FeedBackViewController *feedVC = [[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:feedVC animated:YES];
}

- (void)delayMethod
{
    [RedView removeFromSuperview];
    versionV.userInteractionEnabled = YES;
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
