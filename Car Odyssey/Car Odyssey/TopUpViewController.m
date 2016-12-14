//
//  TopUpViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "TopUpViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define AliPayAPI @"http://115.29.246.88:9999/center/alipay"
#define WXPayAPi @"http://115.29.246.88:9999/center/wctpay"


@interface TopUpViewController ()<UITextFieldDelegate>
{
    UIImageView *chooseZFB;
    UIImageView *chooseWX;
    UITextField *tf;
    BOOL isTherePoint;
    
}

@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"充值";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    UIView *zfbV = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
    zfbV.backgroundColor = [UIColor whiteColor];
    zfbV.userInteractionEnabled = YES;
    UITapGestureRecognizer *zfbPay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(useZFB)];
    [zfbV addGestureRecognizer:zfbPay];
    [self.view addSubview:zfbV];
    
    UIImageView *zfbPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*SCREENW_RATE, 30*SCREENW_RATE)];
    zfbPic.image = [UIImage imageNamed:@"zfb0"];
    zfbPic.center = CGPointMake(30*SCREENW_RATE, CGRectGetMidY(zfbV.bounds));
    [zfbV addSubview:zfbPic];
    
    UILabel *zhifuL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zfbPic.frame)+15*SCREENW_RATE, 0, 100*SCREENW_RATE, 49*SCREENW_RATE)];
    zhifuL.font = [UIFont systemFontOfSize:16];
    zhifuL.textColor = RGB(51, 51, 51);
    zhifuL.textAlignment = NSTextAlignmentLeft;
    zhifuL.text = @"支付宝充值";
    [zfbV addSubview:zhifuL];
    
    chooseZFB = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18*SCREENW_RATE, 13*SCREENW_RATE)];
    chooseZFB.center = CGPointMake(SCREENW - 24*SCREENW_RATE, CGRectGetMidY(zfbV.bounds));
    chooseZFB.image = [UIImage imageNamed:@"gou4"];
    [zfbV addSubview:chooseZFB];
    
    UIView *wxV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zfbV.frame)+1, SCREENW, 50*SCREENW_RATE)];
    wxV.userInteractionEnabled = YES;
    wxV.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *WXPay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(useWX)];
    [wxV addGestureRecognizer:WXPay];
    [self.view addSubview:wxV];
    
    UIImageView *wxPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*SCREENW_RATE, 30*SCREENW_RATE)];
    wxPic.image = [UIImage imageNamed:@"weixin0"];
    wxPic.center = CGPointMake(30*SCREENW_RATE, CGRectGetMidY(zfbV.bounds));
    [wxV addSubview:wxPic];
    
    UILabel *wxL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wxPic.frame)+15*SCREENW_RATE, 0, 100*SCREENW_RATE, 49*SCREENW_RATE)];
    wxL.font = [UIFont systemFontOfSize:16];
    wxL.textColor = RGB(51, 51, 51);
    wxL.textAlignment = NSTextAlignmentLeft;
    wxL.text = @"微信充值";
    [wxV addSubview:wxL];
    
    chooseWX = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18*SCREENW_RATE, 13*SCREENW_RATE)];
    chooseWX.center = CGPointMake(SCREENW - 24*SCREENW_RATE, CGRectGetMidY(zfbV.bounds));
    chooseWX.image = [UIImage imageNamed:@"gou4"];
    chooseWX.hidden = YES;
    [wxV addSubview:chooseWX];
    
    UIView *moneyV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(wxV.frame)+10*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
    moneyV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:moneyV];
    
    UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60*SCREENW_RATE, 50*SCREENW_RATE)];
    moneyL.textAlignment = NSTextAlignmentCenter;
    moneyL.textColor = RGB(51, 51, 51);
    moneyL.font = [UIFont systemFontOfSize:16];
    moneyL.text = @"金额";
    [moneyV addSubview:moneyL];
    
    tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyL.frame)+10*SCREENW_RATE, 0, 280*SCREENW_RATE, 50*SCREENW_RATE)];
    tf.font = [UIFont systemFontOfSize:16];
    tf.delegate = self;
    [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"建议输入整数金额" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    [moneyV addSubview:tf];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(moneyV.frame)+36*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    sureBtn.backgroundColor = RGB(37, 155, 255);
    sureBtn.layer.cornerRadius = 5.0f;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(payMoney:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    
    NSString *str = @"充值完成后可以在";
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
    CGSize labelSize = [str1 boundingRectWithSize:CGSizeMake(SCREENW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(sureBtn.frame.origin.x, CGRectGetMaxY(sureBtn.frame), labelSize.width, 40*SCREENW_RATE)];
    textL.font = [UIFont systemFontOfSize:11];
    textL.textColor = RGB(136, 136, 136);
    textL.attributedText = str1;
    [self.view addSubview:textL];
    
    NSString *str3 = @"充值记录";
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc]initWithString:str3];
    CGSize labelSize1 = [str4 boundingRectWithSize:CGSizeMake(SCREENW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame), textL.frame.origin.y, labelSize1.width, 40*SCREENW_RATE)];
    textL1.textColor = RGB(255, 46, 80);
    textL1.textAlignment = NSTextAlignmentLeft;
    textL1.font = [UIFont systemFontOfSize:11];
    textL1.attributedText = str4;
    [self.view addSubview:textL1];
    
    UILabel *textL2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL1.frame), textL.frame.origin.y, 100*SCREENW_RATE, 40*SCREENW_RATE)];
    textL2.textColor = RGB(136, 136, 136);
    textL2.textAlignment = NSTextAlignmentLeft;
    textL2.font = [UIFont systemFontOfSize:11];
    textL2.textAlignment  = NSTextAlignmentLeft;
    textL2.text = @"中查看充值详情";
    [self.view addSubview:textL2];
}

- (void)useZFB
{
    chooseZFB.hidden = NO;
    chooseWX.hidden = !chooseZFB.hidden;
}

- (void)useWX
{
    chooseWX.hidden = NO;
    chooseZFB.hidden = !chooseWX.hidden;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payMoney:(UIButton *)selectedBtn
{
    selectedBtn.userInteractionEnabled = NO;
    if (chooseZFB.hidden == NO) {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userid = [ud objectForKey:@"userid"];
        NSString *name = [ud objectForKey:@"name"];
        [paraDic setObject:name forKey:@"name"];
        [paraDic setObject:userid forKey:@"id"];
        [paraDic setObject:tf.text forKey:@"money"];
        [[NetManager shareManager]requestUrlPost:AliPayAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             selectedBtn.userInteractionEnabled = NO;
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 NSLog(@"%@",data);
                 [[AlipaySDK defaultService]payOrder:data[@"data"][@"paystring"] fromScheme:@"chemanxing" callback:^(NSDictionary *resultDic)
                 {
                     //NSLog(@"%@",resultDic);
                     [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"充值成功"];
                     [self.navigationController popViewControllerAnimated:YES];
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
//             NSLog(@"%@",error);
         }];
        
    }
    else if (chooseWX.hidden == NO)
    {
        selectedBtn.userInteractionEnabled = NO;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userid = [ud objectForKey:@"userid"];
        NSString *name = [ud objectForKey:@"name"];
        [paraDic setObject:userid forKey:@"id"];
        [paraDic setObject:tf.text forKey:@"money"];
        [paraDic setObject:name forKey:@"name"];
        [[NetManager shareManager]requestUrlPost:WXPayAPi andParameter:paraDic withSuccessBlock:^(id data)
        {
            //NSLog(@"%@",data);
            selectedBtn.userInteractionEnabled = YES;
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                
                PayReq *request = [[PayReq alloc]init];
                request.partnerId = data[@"data"][@"partnerid"];
                request.prepayId = data[@"data"][@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr = data[@"data"][@"noncestr"];
                request.timeStamp = (UInt32)[data[@"data"][@"timestamp"]integerValue];
                request.sign = data[@"data"][@"sign"];
                [WXApi sendReq:request];
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
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isTherePoint = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];
        if ((single > '0' && single <= '9')||single == '.')
        {
            if ([textField.text length] == 0)
            {
                if (single == '.')
                {
                    [[Ultitly shareInstance]showMBProgressHUDup:self.view withShowStr:@"第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0')
                {
                    [[Ultitly shareInstance]showMBProgressHUDup:self.view withShowStr:@"第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single == '.')
            {
                if (!isTherePoint)
                {
                    isTherePoint = YES;
                    return YES;
                }
                else
                {
                    [[Ultitly shareInstance]showMBProgressHUDup:self.view withShowStr:@"只能输入一个小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isTherePoint)
                {
                    NSRange pointRan = [textField.text rangeOfString:@"."];
                    if (range.location - pointRan.location <= 2)
                    {
                        return YES;
                    }
                    else
                    {
                        [[Ultitly shareInstance]showMBProgressHUDup:self.view withShowStr:@"最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {
            [[Ultitly shareInstance]showMBProgressHUDup:self.view withShowStr:@"您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
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
