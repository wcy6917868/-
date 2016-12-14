//
//  RecommendViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "RecommendViewController.h"
#import "InviteFeedbackViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define inviteJoinAPI @"http://115.29.246.88:9999/center/invite"

@interface RecommendViewController ()
{
    UITextField *nameTF;
    UITextField *telNumTF;
}

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.view.backgroundColor = RGB(238, 238, 238);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.title = @"邀请加盟";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
}

- (void)configUI
{
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 78*SCREENW_RATE, 150*SCREENW_RATE, 48*SCREENW_RATE)];
    textL.font = [UIFont systemFontOfSize:18];
    textL.textColor = RGB(51, 51, 51);
    textL.textAlignment = NSTextAlignmentLeft;
    textL.text = @"短信推荐";
    [self.view addSubview:textL];
    
    nameTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(textL.frame), 345*SCREENW_RATE, 50*SCREENW_RATE)];
    nameTF.backgroundColor = [UIColor whiteColor];
    UIView *padV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 10*SCREENW_RATE)];
    nameTF.leftViewMode = UITextFieldViewModeAlways;
    nameTF.leftView = padV;
    nameTF.font = [UIFont systemFontOfSize:16];
    [nameTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"输入邀请人的姓名" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    [self.view addSubview:nameTF];
    
    telNumTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(nameTF.frame)+1, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    telNumTF.backgroundColor = [UIColor whiteColor];
    UIView *padV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 10*SCREENW_RATE)];
    telNumTF.leftViewMode = UITextFieldViewModeAlways;
    telNumTF.leftView = padV1;
    telNumTF.font = [UIFont systemFontOfSize:16];
    [telNumTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"输入被邀请人的号码" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    [self.view addSubview:telNumTF];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(telNumTF.frame.origin.x, CGRectGetMaxY(telNumTF.frame)+25*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    sureBtn.backgroundColor = RGB(68, 157, 254);
    [sureBtn setTitle:@"确认邀请" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureInvite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureInvite:(UIButton *)selectedBtn
{
    if (nameTF.text.length != 0 && telNumTF.text.length != 0)
    {
        selectedBtn.userInteractionEnabled = NO;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userid = [ud objectForKey:@"userid"];
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:userid forKey:@"id"];
        [paraDic setObject:nameTF.text forKey:@"name"];
        [paraDic setObject:telNumTF.text forKey:@"mobile"];
        [[NetManager shareManager]requestUrlPost:inviteJoinAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             selectedBtn.userInteractionEnabled = YES;
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 NSLog(@"%@",data);
                 InviteFeedbackViewController *INFDVC = [[InviteFeedbackViewController alloc]init];
                 [self.navigationController pushViewController:INFDVC animated:YES];
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
             selectedBtn.userInteractionEnabled = YES;
             NSLog(@"%@",error);
         }];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"邀请人的姓名和手机号码都不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action];
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
