//
//  ChangeTelNumViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ChangeTelNumViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define changeTelNumTestAPI @"http://115.29.246.88:9999/center/mobcode"
#define changeTelNumAPI @"http://115.29.246.88:9999/center/mobile"
@interface ChangeTelNumViewController ()<UITextFieldDelegate>
{
    BOOL telNumBool;
    BOOL testNumBool;
}

@end

@implementation ChangeTelNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(255, 255, 255);
    self.navigationItem.title = @"手机号";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 77*SCREENW_RATE, 300*SCREENW_RATE, 46*SCREENW_RATE)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB(136, 136, 136);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"更换后个人信息不变,下次可以新手机号登录";
    [self.view addSubview:label];
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(label.frame), 345*SCREENW_RATE, 50*SCREENW_RATE)];
    tf.backgroundColor = [UIColor whiteColor];
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
    tf.leftView = paddingView;
    [tf addTarget:self action:@selector(valueChage:) forControlEvents:UIControlEventEditingChanged];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = @"请输入手机号码";
    tf.tag = 100;
    tf.delegate = self;
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame = CGRectMake(0, 0, 100*SCREENW_RATE, 50*SCREENW_RATE);
    [getBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [getBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    getBtn.backgroundColor = RGB(37, 155, 255);
    [getBtn addTarget:self action:@selector(getTestNum:) forControlEvents:UIControlEventTouchUpInside];
    tf.rightView = getBtn;
    tf.rightViewMode = UITextFieldViewModeAlways;
    tf.layer.borderColor = RGB(238, 238, 238).CGColor;
    tf.layer.borderWidth = .4;
    [self.view addSubview:tf];
    
    UITextField *tf1 = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(tf.frame), 345*SCREENW_RATE, 50*SCREENW_RATE)];
    tf1.backgroundColor = [UIColor whiteColor];
    UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
    tf1.leftView = paddingView1;
    tf1.leftViewMode = UITextFieldViewModeAlways;
    tf1.placeholder = @"验证码";
    tf1.layer.borderColor = RGB(238, 238, 238).CGColor;
    tf1.layer.borderWidth = .4;
    tf1.tag = 101;
    [tf1 addTarget:self action:@selector(valueChage:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:tf1];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(tf1.frame)+19, 345*SCREENW_RATE, 50*SCREENW_RATE);
    joinBtn.backgroundColor  = [UIColor grayColor];
    [joinBtn setTitle:@"加入车漫行" forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [joinBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(gogogo:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.tag = 102;
    [self.view addSubview:joinBtn];
    telNumBool = NO;
    testNumBool = NO;

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getTestNum:(UIButton *)getNumBtn
{
    UITextField *tf = [self.view viewWithTag:100];
    if (tf.text.length > 0)
    {
        getNumBtn.userInteractionEnabled = NO;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:tf.text forKey:@"mobile"];
        [[NetManager shareManager]requestUrlPost:changeTelNumTestAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
              getNumBtn.userInteractionEnabled = YES;
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 __block NSInteger time = 59; //倒计时时间
                 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                 dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                 dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                 dispatch_source_set_event_handler(_timer, ^{
                     if(time <= 0){ //倒计时结束，关闭
                         dispatch_source_cancel(_timer);
                         dispatch_async(dispatch_get_main_queue(), ^{
                             getNumBtn.backgroundColor = RGB(37, 155, 255);
                             [getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                             getNumBtn.userInteractionEnabled = YES;
                         });
                     }else{
                         int seconds = time % 2333;
                         dispatch_async(dispatch_get_main_queue(), ^{
                             //设置按钮显示读秒效果
                             getNumBtn.backgroundColor = RGB(204, 204, 204);
                             [getNumBtn setTitle:[NSString stringWithFormat:@"%d 秒",seconds] forState:UIControlStateNormal];
                             getNumBtn.userInteractionEnabled = NO;
                         });
                         time--;
                     }
                 });
                 dispatch_resume(_timer);
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
              getNumBtn.userInteractionEnabled = YES;
         }];
     
    }
    else
    {
        [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"请输入手机号码"];
    }
   
}

- (void)valueChage:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    UITextField *tf = [self.view viewWithTag:100];
    UITextField *tf1 = [self.view viewWithTag:101];
    UIButton *btn = [self.view viewWithTag:102];
    if (textField == tf)
    {
        if (textField.text.length > 0)
        {
            telNumBool = YES;
        }
        else
        {
            telNumBool = NO;
        }
    }
    if (textField == tf1)
    {
        if (textField.text.length > 0)
        {
            testNumBool = YES;
        }
        else
        {
            testNumBool = NO;
        }
    }
    if (testNumBool == YES && telNumBool == YES)
    {
        btn.backgroundColor = RGB(37, 155, 255);
        btn.enabled = YES;
    }
    else
    {
        btn.backgroundColor = [UIColor grayColor];
        btn.enabled = NO;
    }
    
}

- (void)gogogo:(UIButton *)selectedBtn
{
    selectedBtn.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    UITextField *tf = [self.view viewWithTag:100];
    UITextField *tf1 = [self.view viewWithTag:101];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:tf.text forKey:@"mobile"];
    [paraDic setObject:tf1.text forKey:@"code"];
    [[NetManager shareManager]requestUrlPost:changeTelNumAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        selectedBtn.userInteractionEnabled = YES;
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            NSLog(@"%@",data);
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号码修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];

            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:tf.text forKey:@"mobile"];
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
        selectedBtn.selected = YES;
        
    }];
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
