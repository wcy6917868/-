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
#define LoginAPI @"http://139.196.179.91/carmanl/public/account/login"
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNav];
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
    //导航栏右边按钮设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registed)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
}

- (void)configUI
{
    //创建汽车图片
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48*SCREENW_RATE, 59*SCREENW_RATE)];
    carImage.center = CGPointMake(187.5 * SCREENW_RATE, 140 *SCREENW_RATE);
    carImage.image = [UIImage imageNamed:@"logo@2x"];
    [self.view addSubview:carImage];
    //创建文本输入框
    UILabel *userL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*SCREENW_RATE, 30*SCREENW_RATE)];
    userL.text = @"   账号";
    userL.textColor = RGB(34, 34, 34);
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
    passL.text = @"   密码";
    passL.textColor = RGB(34, 34, 34);
    passL.font = [UIFont systemFontOfSize:16];
    passWord = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(user.frame), SCREENW, 50*SCREENW_RATE)];
    passWord.borderStyle = UITextBorderStyleNone;
    passWord.backgroundColor = [UIColor whiteColor];
    passWord.placeholder = @"请输入密码";
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
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(passWord.frame)+24*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    loginBtn.backgroundColor = RGB(37, 155, 255);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(toLog) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    
    _danxuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _danxuanBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(loginBtn.frame)+11*SCREENW_RATE, 25*SCREENW_RATE, 25*SCREENW_RATE);
    [_danxuanBtn setBackgroundImage:[UIImage imageNamed:@"danxuan1@2x"] forState:UIControlStateNormal];
    [_danxuanBtn setUserInteractionEnabled:NO];
    [self.view addSubview:_danxuanBtn];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_danxuanBtn.frame)+8*SCREENW_RATE, _danxuanBtn.frame.origin.y+2, 40*SCREENW_RATE, 20*SCREENW_RATE)];
    textL.text = @"同意";
    textL.font = [UIFont systemFontOfSize:14];
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

    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(textL1.frame)+150*SCREENW_RATE, 115.5*SCREENW_RATE, 1*SCREENW_RATE)];
    lineV1.backgroundColor = RGB(204, 204, 204);
    [self.view addSubview:lineV1];
    
    UILabel *textL2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 124*SCREENW_RATE, 30*SCREENW_RATE)];
    textL2.center = CGPointMake(200.5*SCREENW_RATE, lineV1.frame.origin.y);
    textL2.text = @"   其他方式登录";
    textL2.font = [UIFont systemFontOfSize:14];
    textL2.textColor = RGB(102, 102, 102);
    [self.view addSubview:textL2];
    
    UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL2.frame),lineV1.frame.origin.y, 100.5*SCREENW_RATE, 1*SCREENW_RATE)];
    lineV2.backgroundColor = RGB(204, 204, 204);
    [self.view addSubview:lineV2];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(180*SCREENW_RATE, CGRectGetMaxY(textL2.frame)+12*SCREENW_RATE, 32*SCREENW_RATE, 27*SCREENW_RATE);
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixin@2x"] forState:UIControlStateNormal];
    [self.view addSubview:weixinBtn];
    
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

- (void)toLog
{
    if (user.text.length > 0 && passWord.text.length > 0)
    {
        NSMutableDictionary *paramterDic = [NSMutableDictionary dictionary];
        [paramterDic setObject:user.text forKey:@"mobile"];
        [paramterDic setObject:passWord.text forKey:@"passwd"];
        [[NetManager shareManager]requestUrlPost:LoginAPI andParameter:paramterDic withSuccessBlock:^(id data)
        {
            NSLog(@"%@",data);
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                [Ultitly shareInstance].id = data[@"data"][@"id"];
                [self delayMethod];
            }
            else if ([data[@"status"]isEqualToString:@"0000"])
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器响应失败,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
            }
            else if ([data[@"status"]isEqualToString:@"1000"])
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
            }
            else if ([data[@"status"]isEqualToString:@"2000"])
            {
                [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:data[@"msg"]];
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2];
            }
        }
        andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
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
    NSString *APIStr = @"http://139.196.179.91/carmanl/public/account/responsibility";
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
    MapViewController *MVC = [[MapViewController alloc]init];
    [self.navigationController pushViewController:MVC animated:YES];
    AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
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
