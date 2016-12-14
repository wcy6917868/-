//
//  ShowPriceViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/26.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ShowPriceViewController.h"
#import "NetManager.h"
#import "PriceCell.h"
#import "TotalCell.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define arriveDestinationAPI @"http://115.29.246.88:9999/core/reach"
#define addMoneyAPI @"http://115.29.246.88:9999/core/correct"

@interface ShowPriceViewController ()<UITextFieldDelegate>
{
    UIView *popV;
    UILabel *blueL;
    UILabel *textL;
    UIView *lineV;
    UIView *tfV;
    UIButton *sureAddBtn;
    UIScrollView *costScrollerView;
    NSArray *controlArr;
    CGFloat totalMoney;
    CGFloat parkMoney;
    CGFloat idlingMoney;
    CGFloat stayMoney;
    CGFloat foodMoney;
    BOOL isAdd;
}
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *tfArray;

@end

@implementation ShowPriceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    popV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 340*SCREENW_RATE, 215*SCREENW_RATE)];
    popV.center = CGPointMake(SCREENW/2, SCREENH/2);
    popV.backgroundColor = [UIColor whiteColor];
    popV.layer.cornerRadius = 5.0f;
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
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ddxq_gb"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    [popV insertSubview:cancelBtn aboveSubview:blueL];
    
    textL = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, CGRectGetMaxY(blueL.frame), 266*SCREENW_RATE, 120*SCREENW_RATE)];
    textL.font = [UIFont systemFontOfSize:14];
    textL.textColor = RGB(68, 68, 68);
    textL.numberOfLines = 3;
//    NSString *str = _mileFare;
    NSString *str1 = [NSString stringWithFormat:@"您与乘客陈先生的订单已被记录在我的行程中,本次输入%@元,想要了解更多,请查看我的行程",[Ultitly shareInstance].fareCost];
    
    if ([Ultitly shareInstance].fareCost.length > 0)
    {
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:str1];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];
        NSRange redRange = NSMakeRange([[str2 string]rangeOfString:[Ultitly shareInstance].fareCost].location, [[str2 string]rangeOfString:[Ultitly shareInstance].fareCost].length);
        [str2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str2 length])];
        [str2 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
        textL.attributedText = str2;
        [popV addSubview:textL];
    }
    
    lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textL.frame)+5*SCREENW_RATE, 340*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(238, 238, 238);
    [popV addSubview:lineV];
    
    sureAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureAddBtn.frame = CGRectMake(0, CGRectGetMaxY(lineV.frame), 170*SCREENW_RATE, popV.frame.size.height - CGRectGetMaxY(lineV.frame));
    sureAddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureAddBtn setTitle:@"确认加钱" forState:UIControlStateNormal];
    [sureAddBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
    [sureAddBtn addTarget:self action:@selector(sureAdd:) forControlEvents:UIControlEventTouchUpInside];
    isAdd = NO;
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
    [continueBtn addTarget:self action:@selector(continueGetList) forControlEvents:UIControlEventTouchUpInside];
    [popV addSubview:continueBtn];
    controlArr = @[lineV,sureAddBtn,lineV1,continueBtn];
}

- (void)sureAdd:(UIButton *)selectedBtn
{
    if (isAdd == NO)
    {
        popV.frame = CGRectMake(0, 0, 340*SCREENW_RATE, 346*SCREENW_RATE);
        popV.center = CGPointMake(SCREENW/2, SCREENH/2);
        [textL removeFromSuperview];
        [self setTextField];
        isAdd = YES;
    }
    else
    {
        selectedBtn.userInteractionEnabled = NO;
        UITextField *parkCost  = [costScrollerView viewWithTag:200];
        UITextField *emptyCost = [costScrollerView viewWithTag:201];
        UITextField *stayCost = [costScrollerView viewWithTag:202];
        UITextField *foodCost = [costScrollerView viewWithTag:203];
        UITextField *over_mileage = [costScrollerView viewWithTag:204];
        UITextField *over_time = [costScrollerView viewWithTag:205];
        UITextField *highroad = [costScrollerView viewWithTag:206];
        UITextField *night = [costScrollerView viewWithTag:207];
        UITextField *others = [costScrollerView viewWithTag:208];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userid = [ud objectForKey:@"userid"];
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:userid forKey:@"id"];
        [paraDic setObject:[Ultitly shareInstance].orderID forKey:@"oid"];
        [paraDic setObject:parkCost.text forKey:@"parking"];
        [paraDic setObject:emptyCost.text forKey:@"idling"];
        [paraDic setObject:stayCost.text forKey:@"stay"];
        [paraDic setObject:foodCost.text forKey:@"food"];
        [paraDic setObject:[Ultitly shareInstance].mileage forKey:@"mileage"];
        [paraDic setObject:over_mileage.text forKey:@"over_mileage"];
        [paraDic setObject:over_time.text forKey:@"over_time"];
        [paraDic setObject:highroad.text forKey:@"highroad"];
        [paraDic setObject:night.text forKey:@"night"];
        [paraDic setObject:others.text forKey:@"others"];
        
        [[NetManager shareManager]requestUrlPost:addMoneyAPI andParameter:paraDic withSuccessBlock:^(id data)
        {
            selectedBtn.userInteractionEnabled = YES;
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                _block(@"reset");
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
}

- (void)continueGetList
{
    [self dismissViewControllerAnimated:YES completion:^{
        _block(@"stillRob");
    }];
}

- (void)reStart
{
    [self dismissViewControllerAnimated:YES completion:^{
        _block(@"restart");
    }];
}

- (void)setTextField
{
    NSArray *costArray = @[@"停车过路费",@"空驶费",@"住宿费",@"餐饮费",@"超公里费",@"超时长费",@"高速路桥费",@"夜间服务",@"其他费用",@"总计"];

    costScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(20*SCREENW_RATE, CGRectGetMaxY(blueL.frame)+17*SCREENW_RATE, 300*SCREENW_RATE, 217*SCREENW_RATE)];
    costScrollerView.layer.borderColor = RGB(237, 237, 237).CGColor;
    costScrollerView.layer.borderWidth = 0.5f;
    [popV addSubview:costScrollerView];
    
    for (int i = 0; i < costArray.count; i++)
    {
        tfV = [[UIView alloc]initWithFrame:CGRectMake(0, i*43*SCREENW_RATE, 300*SCREENW_RATE, 1*SCREENW_RATE)];
        tfV.tag = 300 + i;
        tfV.backgroundColor = RGB(237, 237, 237);
        [costScrollerView addSubview:tfV];
        UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(17*SCREENW_RATE, i*43*SCREENW_RATE, 100*SCREENW_RATE, 43*SCREENW_RATE)];
        textL1.textColor = RGB(51, 51, 51);
        textL1.textAlignment = NSTextAlignmentLeft;
        textL1.font = [UIFont systemFontOfSize:14];
        textL1.text = costArray[i];
        [costScrollerView addSubview:textL1];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(tfV.frame.size.width - 115*SCREENW_RATE, i*43*SCREENW_RATE, 100*SCREENW_RATE, 43*SCREENW_RATE)];
        tf.font = [UIFont systemFontOfSize:14];
        tf.tag = 200+i;
        [tf addTarget:self action:@selector(editing:) forControlEvents:UIControlEventEditingChanged];
        [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"输入金额" attributes:@{NSForegroundColorAttributeName:RGB(204, 204, 204)}]];
        if (i == costArray.count - 1)
        {
            tf.text = @"0.00 元";
            tf.textColor = RGB(254, 71, 80);
        }
        [costScrollerView addSubview:tf];
        
    }
    
    [self changeFrame:controlArr];
    
    UIView *allCostV = [self.view viewWithTag:309];
    costScrollerView.contentSize = CGSizeMake(0,CGRectGetMaxY(allCostV.frame)+43*SCREENW_RATE);
    
}

- (void)editing:(UITextField *)textfiled
{
    totalMoney = 0;
    for (UIView *view in costScrollerView.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *tf = (UITextField *)view;
            if (tf.tag < 209) {
                totalMoney += tf.text.floatValue;
               // NSLog(@"%f",tf.text.floatValue);
            }
            
        }
    }
    
    //NSLog(@"%.2f",totalMoney);
    UITextField *costTF = [costScrollerView viewWithTag:209];
    costTF.text = [NSString stringWithFormat:@"%.2f",totalMoney];
}

- (void)changeFrame:(NSArray *)changArr
{
    for (UIView *view in changArr)
    {
        CGRect frame = view.frame;
        frame.origin.y = frame.origin.y + 130*SCREENW_RATE;
        view.frame = frame;
    }
//    CGRect popFrame = popV.frame;
//    popFrame.size.height = CGRectGetMaxY(sureAddBtn.frame);
//    popV.frame = popFrame;
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
