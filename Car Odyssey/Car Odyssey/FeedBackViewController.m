//
//  FeedBackViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/17.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define feedBackAPI @"http://139.196.179.91/carmanl/public/center/feedback"

@interface FeedBackViewController ()<UITextViewDelegate>
{
    UILabel *placeholderL;
    UITextView *textV;
    UITextField *telNumTF;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"意见反馈";
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
    UIView *txView = [[UIView alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 79*SCREENW_RATE, 345*SCREENW_RATE, 190*SCREENW_RATE)];
    txView.backgroundColor = [UIColor whiteColor];
    txView.layer.cornerRadius = 5.0f;
    [self.view addSubview:txView];
    
    textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 345*SCREENW_RATE, 121*SCREENW_RATE)];
    textV.delegate = self;
    textV.backgroundColor = [UIColor clearColor];
    textV.font = [UIFont systemFontOfSize:15];
    self.automaticallyAdjustsScrollViewInsets = NO;
    placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, CGRectGetWidth(txView.frame)-15*SCREENW_RATE, 50*SCREENW_RATE)];
    placeholderL.backgroundColor = [UIColor clearColor];
    placeholderL.textColor = RGB(136, 136, 136);
    placeholderL.font = textV.font;
    placeholderL.text = @"感谢反馈,请填写您的问题或意见...";
    [txView addSubview:textV];
    [txView addSubview:placeholderL];
    
    UIButton *addPBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(textV.frame)*SCREENW_RATE, 50*SCREENW_RATE, 50*SCREENW_RATE);
    [addPBtn setBackgroundImage:[UIImage imageNamed:@"tianjiagengduo@2x"] forState:UIControlStateNormal];
    [txView addSubview:addPBtn];
    
    telNumTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(txView.frame)+10*SCREENW_RATE, 345*SCREENW_RATE, 45*SCREENW_RATE)];
    telNumTF.font  = [UIFont systemFontOfSize:15];
    telNumTF.backgroundColor = [UIColor whiteColor];
    telNumTF.layer.cornerRadius = 5.0f;
    telNumTF.layer.masksToBounds = YES;
    UIView *padView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15*SCREENW_RATE, 15*SCREENW_RATE)];
    telNumTF.leftViewMode = UITextFieldViewModeAlways;
    telNumTF.leftView = padView;
    [telNumTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"填写您的手机号,方便我们更快向您反馈哦!" attributes:@{NSForegroundColorAttributeName:RGB(170, 170, 170)}]];
    [self.view addSubview:telNumTF];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.tag = 100;
    submitBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(telNumTF.frame)+35*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    [submitBtn setBackgroundColor:RGB(220,220,220)];
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submitBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeholderL.text = @"";
   
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
   
    if (textView.text.length == 0)
    {
        placeholderL.text = @"感谢反馈,请填写您的问题或意见...";
     
    }
    else
    {
        placeholderL.text = @"";
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
     UIButton *btn = [self.view viewWithTag:100];
    if (textV.text.length == 1)
    {
       
        btn.backgroundColor = RGB(220, 220,220);
        btn.enabled = NO;
        return YES;

    }else if (textV.text.length > 1)
    {
        btn.backgroundColor = RGB(37, 155, 255);
        btn.enabled = YES;
        return YES;
    }
    return YES;
}

- (void)feedBack
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[Ultitly shareInstance].id forKey:@"id"];
    [paraDic setObject:textV.text forKey:@"content"];
    [paraDic setObject:@"" forKey:@"image"];
    [paraDic setObject:telNumTF.text forKey:@"mobile"];
    [[NetManager shareManager]requestUrlPost:feedBackAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        NSLog(@"%@",data);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"反馈成功,感谢您的建议" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    andFailedBlock:^(NSError *error)
    {
        
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
