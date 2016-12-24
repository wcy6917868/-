//
//  LoginViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "NetManager.h"
#import "ExplainViewController.h"
#import "ForgetPassWordViewController.h"
#import "Ultitly.h"
#import "JPUSHService.h"
#import <MBProgressHUD.h>
#define LoginAPI @"http://115.29.246.88:9999/account/login"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *danxuanBtn;

@end

@implementation LoginViewController
{
    bool isSelected ;
    UITextField *user;
    UITextField *passWord;
    UIButton *loginBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNav];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    
}

- (void)initNav
{
    //标题设置
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = RGB(238, 238, 238);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    //导航栏返回按钮设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [btn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//  导航栏右边按钮设置

}

- (void)configUI
{
    //创建汽车图片
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48*SCREENW_RATE, 59*SCREENW_RATE)];
    carImage.center = CGPointMake(187.5 * SCREENW_RATE, 140 *SCREENW_RATE);
    carImage.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:carImage];
    //创建文本输入框
    UILabel *userL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*SCREENW_RATE, 30*SCREENW_RATE)];
    userL.text = @"账号";
    userL.textColor = RGB(34, 34, 34);
    userL.textAlignment = NSTextAlignmentCenter;
    userL.font = [UIFont systemFontOfSize:16];
    user = [[UITextField alloc]initWithFrame:CGRectMake(0, 220.5*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
    user.borderStyle = UITextBorderStyleNone;
    user.backgroundColor = [UIColor whiteColor];
    user.placeholder = @"请输入手机号";
    user.clearsOnBeginEditing = YES;
    user.leftView = userL;
    [user setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:user];
    
    UILabel *passL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*SCREENW_RATE, 30*SCREENW_RATE)];
    passL.text = @"密码";
    passL.textAlignment = NSTextAlignmentCenter;
    passL.textColor = RGB(34, 34, 34);
    passL.font = [UIFont systemFontOfSize:16];
    
    passWord = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(user.frame), SCREENW, 50*SCREENW_RATE)];
    passWord.borderStyle = UITextBorderStyleNone;
    passWord.backgroundColor = [UIColor whiteColor];
    passWord.placeholder = @"请输入密码";
    passWord.secureTextEntry = YES;
    passWord.clearsOnBeginEditing = YES;
    passWord.leftView = passL;
    
    UIButton *forgetPass = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPass.frame = CGRectMake(0, 0, 80*SCREENW_RATE, 30*SCREENW_RATE);
    forgetPass.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetPass setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPass setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
    [forgetPass addTarget:self action:@selector(forgetPass) forControlEvents:UIControlEventTouchUpInside];
    passWord.rightView = forgetPass;
    [passWord setLeftViewMode:UITextFieldViewModeAlways];
    [passWord setRightViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:passWord];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(user.frame), SCREENW, 1*SCREENW_RATE)];
    lineV.backgroundColor = RGB(242, 242, 242);
    [self.view addSubview:lineV];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(passWord.frame)+24*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    loginBtn.backgroundColor = RGB(37, 155, 255);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(toLog:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    
    _danxuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _danxuanBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(loginBtn.frame)+11*SCREENW_RATE, 25*SCREENW_RATE, 25*SCREENW_RATE);
    [_danxuanBtn setBackgroundImage:[UIImage imageNamed:@"danxuan1"] forState:UIControlStateNormal];
    [_danxuanBtn setUserInteractionEnabled:NO];
    [self.view addSubview:_danxuanBtn];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_danxuanBtn.frame)+8*SCREENW_RATE, _danxuanBtn.frame.origin.y+2, 40*SCREENW_RATE, 20*SCREENW_RATE)];
    textL.text = @"同意";
    textL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    textL.textColor = RGB(102, 102, 102);
    [self.view addSubview:textL];
    
    UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame), textL.frame.origin.y, 210*SCREENW_RATE, 20*SCREENW_RATE)];
    textL1.text = @"《服务标准及违约责任认定》";
    textL1.textAlignment = NSTextAlignmentLeft;
    textL1.textColor = RGB(37, 155, 255);
    textL1.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    textL1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(privacy)];
    [textL1 addGestureRecognizer:tap];
    [self.view addSubview:textL1];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)registed
{
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)toLog:(UIButton *)selectedBtn
{
    if (user.text.length > 0 && passWord.text.length > 0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        selectedBtn.userInteractionEnabled = NO;
        NSMutableDictionary *paramterDic = [NSMutableDictionary dictionary];
        [paramterDic setObject:user.text forKey:@"mobile"];
        [paramterDic setObject:passWord.text forKey:@"passwd"];
        [[NetManager shareManager]requestUrlPost:LoginAPI andParameter:paramterDic withSuccessBlock:^(id data)
        {
            selectedBtn.userInteractionEnabled = YES;
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Ultitly shareInstance].id = data[@"data"][@"id"];
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:@"isLog"  forKey:@"isLogin"];
                [ud setObject:data[@"data"][@"id"] forKey:@"userid"];
                [ud setObject:data[@"data"][@"realname"] forKey:@"name"];
                [ud setObject:data[@"data"][@"age"] forKey:@"age"];
                [ud setObject:data[@"data"][@"license"] forKey:@"license"];
                [ud setObject:data[@"data"][@"gender"] forKey:@"gender"];
                [ud setObject:data[@"data"][@"account_money"] forKey:@"accountmoney"];
                [ud setObject:data[@"data"][@"account_integral"] forKey:@"accountintegral"];
                [ud setObject:data[@"data"][@"portrait"] forKey:@"headportrait"];
                [ud setObject:data[@"data"][@"portraitname"] forKey:@"portraitname"];
                [ud setObject:user.text forKey:@"mobile"];
                [ud setObject:passWord.text forKey:@"passWord"];
                [ud setObject:user.text forKey:@"mobile"];
                [ud setObject:data[@"data"][@"locid"] forKey:@"city"];
                [ud synchronize];
                [JPUSHService setTags:data[@"data"][@"jg_tags"] aliasInbackground:data[@"data"][@"jg_alias"]];
                [self delayMethod];
            }
            else if ([data[@"status"]isEqualToString:@"1000"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }
         andFailedBlock:^(NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             selectedBtn.userInteractionEnabled = YES;
        }];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或者密码都不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)privacy
{
    ExplainViewController *explainVC = [[ExplainViewController alloc]init];
    NSString *titleStr = @"服务标准及违约责任认定";
    NSString *APIStr = @"http://115.29.246.88:9999/account/responsibility";
    explainVC.titleStr = titleStr;
    explainVC.APIStr = APIStr;
    [self.navigationController pushViewController:explainVC animated:YES];
}

- (void)forgetPass
{
    ForgetPassWordViewController *forgetPassVC = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:forgetPassVC animated:YES];
}

- (void)delayMethod
{
    AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    MapViewController *MVC = [[MapViewController alloc]init];
    appdel.mapViewController = MVC;
    [appdel setDrawwer];
    MVC.checkUnfinished = @"isCheck";
    appdel.window.tintColor = [UIColor blueColor];
    appdel.window.rootViewController = appdel.drawerController;
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
