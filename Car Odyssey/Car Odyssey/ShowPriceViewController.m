//
//  ShowPriceViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/26.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ShowPriceViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface ShowPriceViewController ()
{
    UIView *popV;
     UILabel *blueL;
    UILabel *textL;
    UIView *lineV;
    NSArray *controlArr;
   
}

@end

@implementation ShowPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI
{
    popV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 340*SCREENW_RATE, 215*SCREENW_RATE)];
    popV.center = CGPointMake(SCREENW/2, SCREENH/2);
    popV.backgroundColor = [UIColor whiteColor];
    popV.layer.cornerRadius = 5;
    popV.layer.masksToBounds = YES;
    [self.view addSubview:popV];
    
    blueL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 340*SCREENW_RATE, 45*SCREENW_RATE)];
    blueL.backgroundColor = RGB(37, 155, 255);
    blueL.text = @"订单详情";
    blueL.textColor = RGB(255, 255, 255);
    blueL.textAlignment = NSTextAlignmentCenter;
    blueL.font = [UIFont systemFontOfSize:18];
    [popV addSubview:blueL];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(popV.frame)-46*SCREENW_RATE, 0, 31*SCREENW_RATE, 31*SCREENW_RATE)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ddxq_gb@2x"] forState:UIControlStateNormal];
    [popV insertSubview:cancelBtn aboveSubview:blueL];
    
    textL = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, CGRectGetMaxY(blueL.frame), 266*SCREENW_RATE, 120*SCREENW_RATE)];
    textL.font = [UIFont systemFontOfSize:14];
    textL.textColor = RGB(68, 68, 68);
    textL.numberOfLines = 3;
    NSString *str = @"21.0";
    NSString *str1 = [NSString stringWithFormat:@"您与乘客陈先生的订单已被记录在我的行程中,本次输入%@元,想要了解更多,请查看我的行程",str];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str1];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    NSRange redRange = NSMakeRange([[str2 string]rangeOfString:str].location, [[str2 string]rangeOfString:str].length);
    [str2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str2 length])];
    [str2 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
    textL.attributedText = str2;
    [popV addSubview:textL];
    
    lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textL.frame)+5*SCREENW_RATE, 340*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(238, 238, 238);
    [popV addSubview:lineV];
    
    UIButton *sureAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureAddBtn.frame = CGRectMake(0, CGRectGetMaxY(lineV.frame), 170*SCREENW_RATE, popV.frame.size.height - CGRectGetMaxY(lineV.frame));
    sureAddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureAddBtn setTitle:@"确认加钱" forState:UIControlStateNormal];
    [sureAddBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
    [sureAddBtn addTarget:self action:@selector(sureAdd) forControlEvents:UIControlEventTouchUpInside];
    [popV addSubview:sureAddBtn];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sureAddBtn.frame), lineV.frame.origin.y, 1*SCREENW_RATE, popV.frame.size.height - CGRectGetMaxY(lineV.frame))];
    lineV1.backgroundColor = RGB(238, 238, 238);
    [popV addSubview:lineV1];
    //创建继续听单按钮
    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    continueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [continueBtn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
    continueBtn.frame = CGRectMake(lineV1.frame.origin.x, lineV1.frame.origin.y, 169*SCREENW_RATE, lineV1.frame.size.height);
    [continueBtn setTitle:@"继续听单" forState:UIControlStateNormal];
    [popV addSubview:continueBtn];
    
    controlArr = @[lineV,sureAddBtn,lineV1,continueBtn];
}

- (void)sureAdd
{
    popV.frame = CGRectMake(0, 0, 340*SCREENW_RATE, 346*SCREENW_RATE);
    popV.center = CGPointMake(SCREENW/2, SCREENH/2);
    [textL removeFromSuperview];
    [self setTextField];
    
}

- (void)setTextField
{
    NSArray *array = @[@"停车过路费",@"空驶费",@"住宿费",@"餐饮费",@"总计"];
    
    for (int i = 0; i <5; i++) {
        UIView *tfV = [[UIView alloc]initWithFrame:CGRectMake(20*SCREENW_RATE, CGRectGetMaxY(blueL.frame)+(17+i*43)*SCREENW_RATE, 300*SCREENW_RATE, 43*SCREENW_RATE)];
        tfV.layer.borderColor = RGB(237, 237, 237).CGColor;
        tfV.layer.borderWidth = 0.5;
        [popV addSubview:tfV];
        UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(17*SCREENW_RATE, tfV.bounds.origin.y, 100*SCREENW_RATE, 43*SCREENW_RATE)];
        textL1.textColor = RGB(51, 51, 51);
        textL1.textAlignment = NSTextAlignmentLeft;
        textL1.font = [UIFont systemFontOfSize:14];
        textL1.text = array[i];
        [tfV addSubview:textL1];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(tfV.frame.size.width - 115*SCREENW_RATE, tfV.bounds.origin.y, 100*SCREENW_RATE, 43*SCREENW_RATE)];
        tf.font = [UIFont systemFontOfSize:14];
        [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"输入金额" attributes:@{NSForegroundColorAttributeName:RGB(204, 204, 204)}]];
        [tfV addSubview:tf];
        if (i == 4)
        {
            tf.enabled = NO;
            tf.text = @"0.00元";
            tf.textColor = RGB(254, 71, 80);
            tf.tag = 100;
        }
        [self changeFrame:controlArr];
    }
}

- (void)changeFrame:(NSArray *)changArr
{
    for (UIView *view in changArr) {
        CGRect frame = view.frame;
        frame.origin.y += 26*SCREENW_RATE;
        view.frame = frame;
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
