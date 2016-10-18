//
//  DetailListViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "DetailListViewController.h"
#import "FareDetailController.h"
#import "DetailListSecondViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]


@interface DetailListViewController ()

@end

@implementation DetailListViewController

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
    
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
    
}

- (void)configUI
{
    UIView *timeV = [[UIView alloc]initWithFrame:CGRectMake(0, 74*SCREENW_RATE, SCREENW, 42*SCREENW_RATE)];
    timeV.backgroundColor = [UIColor whiteColor];
    UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 7*SCREENW_RATE, 120*SCREENW_RATE, 35*SCREENW_RATE)];
    timeL.font = [UIFont systemFontOfSize:18];
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.textColor = RGB(170, 170, 170);
    timeL.text = @"订单已完成";
    [self.view addSubview:timeV];
    [timeV addSubview:timeL];
    
    UILabel *dateL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 130*SCREENW_RATE, 7*SCREENW_RATE, 120, 42*SCREENW_RATE)];
    dateL.textColor = RGB(170, 170, 170);
    dateL.font = [UIFont systemFontOfSize:16];
    dateL.textAlignment = NSTextAlignmentCenter;
    dateL.text = _model.datetime;
    [timeV addSubview:dateL];
    
    UIView *shangcheV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeV.frame), SCREENW, 45*SCREENW_RATE)];
    shangcheV.backgroundColor = [UIColor whiteColor];
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(20*SCREENW_RATE, 22*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0@2x"];
    UILabel *shangcheL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(blueV.frame)+15*SCREENW_RATE, 0, SCREENW, 45*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = [NSString stringWithFormat:@"上车地点 : %@",_model.outset];
    [shangcheV addSubview:blueV];
    [shangcheV addSubview:shangcheL];
    [self.view addSubview:shangcheV];
    
//    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x*SCREENW_RATE, CGRectGetMaxY(shangcheL.frame)*SCREENW_RATE, 320*SCREENW_RATE, 1*SCREENW_RATE)];
//    lineV.backgroundColor = RGB(238, 238, 238);
//    [self.view addSubview:lineV];
    
    UIView *arriveV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shangcheV.frame)+1*SCREENW_RATE, SCREENW, 45*SCREENW_RATE)];
    arriveV.backgroundColor = [UIColor whiteColor];
    UIImageView *redv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redv.center = CGPointMake(20*SCREENW_RATE, 22*SCREENW_RATE);
    redv.image = [UIImage imageNamed:@"red0@2x"];
    UILabel *arriveL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(redv.frame)+15*SCREENW_RATE, 0, SCREENW, 45*SCREENW_RATE)];
    arriveL.font = [UIFont systemFontOfSize:16];
    arriveL.textColor = RGB(68, 68, 68);
    arriveL.text = [NSString stringWithFormat:@"到达地点 : %@",_model.finish];
    [arriveV addSubview:arriveL];
    [arriveV addSubview:redv];
    [self.view addSubview:arriveV];
    NSArray *titleArr = @[@"车费合计",@"车费详情",@"订单详情",@"乘客评价"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(arriveV.frame)+(10+i*50)*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
        
        view.tag = 100+i;
        view.layer.borderWidth = .4;
        view.layer.borderColor = RGB(238, 238, 238).CGColor;
        view.backgroundColor = [UIColor whiteColor];
        UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
        textL.textColor = RGB(136, 136, 136);
        textL.font = [UIFont systemFontOfSize:16];
        textL.text = titleArr[i];
        UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
        arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
        arrowM.image = [UIImage imageNamed:@"arrow_right@2x"];
        [view addSubview:arrowM];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fareDetail)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(listDetail)];
        if (i == 0)
        {
            self.fareStr = @"1566";
            UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 80*SCREENW_RATE, 0, 60*SCREENW_RATE, 50*SCREENW_RATE)];
            textL.textColor = RGB(68, 68, 68);
            moneyL.font = [UIFont systemFontOfSize:16];
            moneyL.textColor = RGB(68, 68, 68);
            NSString *str = [NSString stringWithFormat:@"%@ 元",_model.cost];
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange redRange = NSMakeRange([[str1 string]rangeOfString:_fareStr].location, [[str1 string]rangeOfString:_fareStr].length);
            [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
            moneyL.attributedText = str1;
            [view addSubview:moneyL];
            [arrowM removeFromSuperview];
        }
        else if (i == 3)
        {
            for (int i = 0; i < 5; i ++) {
                UIImageView *starImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16*SCREENW_RATE, 15*SCREENW_RATE)];
                starImage.image = [UIImage imageNamed:@"wujiaoxing1@2x"];
                starImage.center = CGPointMake(SCREENW - 115*SCREENW_RATE+(i*21*SCREENW_RATE),25*SCREENW_RATE);
                [view addSubview:starImage];
                [arrowM removeFromSuperview];
            }
            
            for (int i = 0; i < _model.star.intValue; i ++) {
                UIImageView *starImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16*SCREENW_RATE, 15*SCREENW_RATE)];
                starImage.image = [UIImage imageNamed:@"wujiaoxing0@2x"];
                starImage.center = CGPointMake(SCREENW - 115*SCREENW_RATE+(i*21*SCREENW_RATE),25*SCREENW_RATE);
                [view addSubview:starImage];
                [arrowM removeFromSuperview];
            }
            
        }else if (i == 1)
        {
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap];
            
        }
        else if (i == 2)
        {
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap1];
        }
        
        [view addSubview:textL];
        [self.view addSubview:view];
    }
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fareDetail
{
    FareDetailController *fareVC = [[FareDetailController alloc]init];
    fareVC.Jmodel = _model;
    [self.navigationController pushViewController:fareVC animated:YES];
}

- (void)listDetail
{
    DetailListSecondViewController *DesVC = [[DetailListSecondViewController alloc]init];
    DesVC.Jmodel = _model;
    [self.navigationController pushViewController:DesVC animated:YES];
}

- (void)delete
{
    
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
