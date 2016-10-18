//
//  InfoViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/18.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "InfoViewController.h"
#import "SystemInfoViewController.h"
#import "ConmentViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"消息中心";
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
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *systemV =  [[UIView alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, 79*SCREENW_RATE)];
    systemV.backgroundColor = [UIColor whiteColor];
    systemV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkSysInfo)];
    [systemV addGestureRecognizer:tap];
    [self.view addSubview:systemV];
    
    UIImageView *bellPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44*SCREENW_RATE, 44*SCREENW_RATE)];
    bellPic.center = CGPointMake(37*SCREENW_RATE, CGRectGetMidY(systemV.bounds));
    bellPic.image = [UIImage imageNamed:@"xtxx0@2x"];
    [systemV addSubview: bellPic];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bellPic.frame)+15*SCREENW_RATE, 18*SCREENW_RATE, 70*SCREENW_RATE, 26*SCREENW_RATE)];
    textL.textColor = RGB(51, 51, 51);
    textL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    textL.text = @"系统消息";
    [systemV addSubview:textL];
    
    UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame)+5*SCREENW_RATE, textL.frame.origin.y+7*SCREENW_RATE, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redV.image  = [UIImage imageNamed:@"red0@2x"];
    [systemV addSubview: redV];
    
    UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(textL.frame.origin.x, CGRectGetMaxY(textL.frame)*SCREENW_RATE, 240*SCREENW_RATE, 18*SCREENW_RATE)];
    textL1.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
    textL1.textColor = RGB(136, 136, 136);
    textL1.text = @"恭喜你成为优品的成员,我们将送您一份大礼";
    [systemV addSubview:textL1];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(systemV.frame), SCREENW, 1*SCREENW_RATE)];
    lineV.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:lineV];
    
    UIView *conmentV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), SCREENW, 79*SCREENW_RATE)];
    conmentV.backgroundColor = [UIColor whiteColor];
    conmentV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkConmInfo)];
    [conmentV addGestureRecognizer:tap1];
    [self.view addSubview:conmentV];
    
    UIImageView *conmentPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44*SCREENW_RATE, 44*SCREENW_RATE)];
    conmentPic.center = CGPointMake(37*SCREENW_RATE, CGRectGetMidY(conmentV.bounds));
    conmentPic.image = [UIImage imageNamed:@"hdxx0@2x"];
    [conmentV addSubview: conmentPic];
    
    UILabel *textL2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(conmentPic.frame)+15*SCREENW_RATE, 18*SCREENW_RATE, 70*SCREENW_RATE, 26*SCREENW_RATE)];
    textL2.textColor = RGB(51, 51, 51);
    textL2.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    textL2.text = @"评论消息";
    [conmentV addSubview:textL2];
    
    UILabel *textL3 = [[UILabel alloc]initWithFrame:CGRectMake(textL.frame.origin.x, CGRectGetMaxY(textL2.frame), 100*SCREENW_RATE, 18*SCREENW_RATE)];
    textL3.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
    textL3.textColor = RGB(136, 136, 136);
    textL3.text = @"暂无新消息";
    [conmentV addSubview:textL3];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(conmentV.frame), SCREENW, 1*SCREENW_RATE)];
    lineV1.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:lineV1];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkSysInfo
{
    SystemInfoViewController *sysVC = [[SystemInfoViewController alloc]init];
    [self.navigationController pushViewController:sysVC animated:YES];
}

- (void)checkConmInfo
{
    ConmentViewController *conmentVC = [[ConmentViewController alloc]init];
    [self.navigationController pushViewController:conmentVC animated:YES];
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
