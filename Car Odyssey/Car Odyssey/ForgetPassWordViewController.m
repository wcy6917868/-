//
//  ForgetPassWordViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/10.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "NetManager.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define forgetPassWordAPI @"http://115.29.246.88:9999/account/lospass"

@interface ForgetPassWordViewController ()
{
    UITextField *ManIdTF;
}

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationItem.title = @"忘记密码";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21, 15);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    self.view.backgroundColor = RGB(238, 238, 238);
    ManIdTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 94*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    ManIdTF.backgroundColor = [UIColor whiteColor];
    UIView *paddingV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 24*SCREENW_RATE)];
    paddingV.backgroundColor = [UIColor whiteColor];
    ManIdTF.leftViewMode = UITextFieldViewModeAlways;
    ManIdTF.leftView = paddingV;
    [ManIdTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"身份证号码" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    [self.view addSubview:ManIdTF];
    
    NSArray *titleArr = @[@"请输入手机号码",@"验证码",@"设置新密码"];
    for (int i = 0; i < 3; i ++)
    {
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(ManIdTF.frame)+(15+i*51) *SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
        tf.backgroundColor = [UIColor whiteColor];
        UIView *padV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 24*SCREENW_RATE)];
        padV.backgroundColor = [UIColor whiteColor];
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.leftView = padV;
        tf.tag = 100 + i;
        [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:titleArr[i] attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
        [self.view addSubview:tf];
        
    }
    UITextField *tf1 = [self.view viewWithTag:100];
    UIButton *getBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tf1.frame)-100*SCREENW_RATE,tf1.frame.origin.y, 100*SCREENW_RATE, 50*SCREENW_RATE)];
    getBtn.backgroundColor = RGB(37, 155, 255);
    getBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [getBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [getBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view insertSubview:getBtn aboveSubview:tf1];
    
    UITextField *lastTF = [self.view viewWithTag:102];
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(lastTF.frame)+28*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    finishBtn.backgroundColor = RGB(37,155, 255);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finish:(UIButton *)selectedBtn
{
    selectedBtn.userInteractionEnabled = NO;
    UITextField *telNumTF = [self.view viewWithTag:100];
    UITextField *yzmTf = [self.view viewWithTag:101];
    UITextField *newPassWD = [self.view viewWithTag:102];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:ManIdTF.text forKey:@"idcard"];
    [paraDic setObject:telNumTF.text forKey:@"mobile"];
    [paraDic setObject:yzmTf.text forKey:@"yzm"];
    [paraDic setObject:newPassWD.text forKey:@"newpass"];
    if (ManIdTF.text.length && telNumTF.text.length && yzmTf.text.length && newPassWD.text.length != 0)
    {
        [[NetManager shareManager]requestUrlPost:forgetPassWordAPI andParameter:paraDic withSuccessBlock:^(id data)
        {
            selectedBtn.userInteractionEnabled = YES;
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                NSLog(@"%@",data);
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
                
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
           
        }];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证号码/手机号码/验证码/以及新的密码都必须填写" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
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
