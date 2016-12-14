//
//  InviteFeedbackViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "InviteFeedbackViewController.h"
#import "MapViewController.h"
#import "NetManager.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define inviteAPI @"http://115.29.246.88:9999/center/invite"
@interface InviteFeedbackViewController ()

@end

@implementation InviteFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.view.backgroundColor = RGB(255, 255, 255);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25*SCREENW_RATE, 25*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"guanbi4"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.title = @"邀请加盟";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
}

- (void)configUI
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90*SCREENW_RATE, 90*SCREENW_RATE)];
    imageV.center = CGPointMake(CGRectGetMidX(self.view.frame), 135*SCREENW_RATE);
    imageV.image = [UIImage imageNamed:@"yaoqingchenggong"];
    [self.view addSubview:imageV];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*SCREENW_RATE, 50*SCREENW_RATE)];
    textL.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(imageV.frame)+25*SCREENW_RATE);
    textL.font = [UIFont systemFontOfSize:18];
    textL.textColor = RGB(51, 51, 51);
    textL.text = @"邀请成功";
    textL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textL];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(textL.frame), 345*SCREENW_RATE, 24*SCREENW_RATE)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(136, 136, 136);
    label.text = @"感谢你的邀请,我们将通过您填写的手机号码发送邀请";
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(label.frame), 345*SCREENW_RATE, 24*SCREENW_RATE)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = RGB(136, 136, 136);
    label1.text = @"函 , 如若被邀请的该用户注册成功,我们将通知您 , 并";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(label1.frame), 345*SCREENW_RATE, 24*SCREENW_RATE)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = RGB(136, 136, 136);
    label2.text = @"发放奖励";
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(label2.frame)+36*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    sureBtn.backgroundColor = RGB(37, 155, 255);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 5.0f;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureInvite
{
    
    MapViewController *homeVC = [[MapViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
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
