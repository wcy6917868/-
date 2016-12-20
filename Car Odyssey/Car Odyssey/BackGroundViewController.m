//
//  BackGroundViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/23.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "BackGroundViewController.h"
#import "ShowPriceViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define RobListAPI @"http://115.29.246.88:9999/core/struggle"
#define driverSleepAPI @"http://115.29.246.88:9999/core/sleep"
#define driverGiveUpAPI @"http://115.29.246.88:9999/core/nextorder"

@interface BackGroundViewController ()
{
    UILabel *restL;
    UILabel *giveUpL;
    NSTimer *timer;
    dispatch_source_t _timer;
}

@end

@implementation BackGroundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_source_cancel(_timer);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)uiConfig
{

    restL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*SCREENW_RATE ,50*SCREENW_RATE )];
    restL.center = CGPointMake(60*SCREENW_RATE, SCREENH - 59*SCREENW_RATE);
    restL.font = [UIFont systemFontOfSize:15];
    restL.textColor = RGB(68, 68, 68);
    restL.text = @"休息";
    restL.userInteractionEnabled = YES;
    UITapGestureRecognizer *restTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rest)];
    [restL addGestureRecognizer:restTap];
    restL.textAlignment = NSTextAlignmentCenter;
    restL.backgroundColor = [UIColor whiteColor];
    restL.layer.cornerRadius = 25.0*SCREENW_RATE;
    restL.layer.masksToBounds = YES;
    [self.view addSubview:restL];
    
    giveUpL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*SCREENW_RATE ,50*SCREENW_RATE)];
    giveUpL.center = CGPointMake(SCREENW - 60*SCREENW_RATE, SCREENH - 59*SCREENW_RATE);
    giveUpL.userInteractionEnabled = YES;
    UITapGestureRecognizer *giveUpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(giveUp)];
    [giveUpL addGestureRecognizer:giveUpTap];
    giveUpL.font = [UIFont systemFontOfSize:15];
    giveUpL.textColor = RGB(68, 68, 68);
    giveUpL.text = @"放弃";
    giveUpL.textAlignment = NSTextAlignmentCenter;
    giveUpL.backgroundColor = [UIColor whiteColor];
    giveUpL.layer.cornerRadius = 25.0*SCREENW_RATE;
    giveUpL.layer.masksToBounds = YES;
    [self.view addSubview:giveUpL];
    
    _qiangdanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qiangdanBtn.frame = CGRectMake(0,0,135*SCREENW_RATE, 135*SCREENW_RATE);
    _qiangdanBtn.center = CGPointMake(187.5*SCREENW_RATE, SCREENH-90.5*SCREENW_RATE);
    _qiangdanBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [_qiangdanBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    _qiangdanBtn.layer.cornerRadius = 67.0*SCREENW_RATE;
    _qiangdanBtn.layer.masksToBounds = YES;
    _qiangdanBtn.titleLabel.numberOfLines = 2;
    [_qiangdanBtn setTitle:@"抢单" forState:UIControlStateNormal];
    [_qiangdanBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    _qiangdanBtn.backgroundColor = RGB(37, 155, 255);
    [self.view addSubview:_qiangdanBtn];
    
    UIView *addressV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 345*SCREENW_RATE, 360*SCREENW_RATE)];
    addressV.center = CGPointMake(187.5*SCREENW_RATE, 275*SCREENW_RATE);
    addressV.layer.cornerRadius = 12.0*SCREENW_RATE;
    addressV.layer.masksToBounds = YES;
    addressV.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:addressV];
    
    UILabel *kiloL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 345*SCREENW_RATE, 55*SCREENW_RATE)];
    kiloL.backgroundColor = RGB(37, 155, 255);
    kiloL.text = [NSString stringWithFormat:@"距离您%@公里",_distanceStr];
    kiloL.textColor = RGB(255, 255, 255);
    kiloL.font = [UIFont systemFontOfSize:21];
    kiloL.textAlignment = NSTextAlignmentCenter;
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 53*SCREENW_RATE, 47*SCREENW_RATE)];
    carImage.image = [UIImage imageNamed:@"car-"];
    [addressV addSubview:kiloL];
    [addressV addSubview:carImage];
    
    UILabel *integralL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(kiloL.frame), 345*SCREENW_RATE, 24*SCREENW_RATE)];
    integralL.backgroundColor = RGB(37, 155, 255);
    integralL.text = [NSString stringWithFormat:@"奖励%@积分",_intergralStr];
    integralL.textColor = RGB(255, 255, 255);
    integralL.font = [UIFont systemFontOfSize:14];
    integralL.textAlignment = NSTextAlignmentCenter;
    [addressV addSubview:integralL];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(integralL.frame), 345*SCREENW_RATE, 21*SCREENW_RATE)];
    label1.backgroundColor = RGB(35, 155, 255);
    [addressV addSubview:label1];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), 345*SCREENW_RATE, 179*SCREENW_RATE)];
    view1.backgroundColor = [UIColor whiteColor];
    [addressV addSubview:view1];
    
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(30*SCREENW_RATE, 65*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0"];
    [view1 addSubview:blueV];
    
    UILabel *shangcheL  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blueV.frame)+11*SCREENW_RATE, 43*SCREENW_RATE, 300*SCREENW_RATE, 45*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = [NSString stringWithFormat:@"  上车地点 : %@",_outsetStr];
    [view1 addSubview:shangcheL];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shangcheL.frame), 345*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(229, 229, 229);
    [view1 addSubview:lineV];
    
    UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redV.center = CGPointMake(blueV.center.x, CGRectGetMaxY(lineV.frame)+45*SCREENW_RATE);
    redV.image = [UIImage imageNamed:@"red0"];
    [view1 addSubview:redV];
    
    UILabel *daodaL = [[UILabel alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(lineV.frame), 300*SCREENW_RATE, 88*SCREENW_RATE)];
    daodaL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    daodaL.textColor = RGB(68, 68, 68);
    daodaL.text = [NSString stringWithFormat:@"   到达地点 : %@",_finishStr];
    [view1 addSubview:daodaL];
    
    UILabel *estimateL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame)+5*SCREENW_RATE, 250*SCREENW_RATE, 40*SCREENW_RATE)];
    estimateL.backgroundColor = [UIColor whiteColor];
    estimateL.textColor = RGB(51, 51, 51);
    estimateL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    estimateL.textAlignment = NSTextAlignmentRight;
    NSString *costStr = [NSString stringWithFormat:@"这次行程的预计费用为%@元",[Ultitly shareInstance].fareCost];
    
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc]initWithString:costStr];
        NSRange redRange = NSMakeRange([[mutableStr string]rangeOfString:[Ultitly shareInstance].fareCost].location, [[mutableStr string]rangeOfString:[Ultitly shareInstance].fareCost].length);
        [mutableStr addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
        estimateL.attributedText = mutableStr;
        [addressV addSubview:estimateL];
    
    NSDictionary *productDic = @{@"1":@"常规单",@"2":@"国内日租",@"3":@"国内送机",@"4":@"国内接机"};
    
    UILabel *productL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(estimateL.frame), estimateL.frame.origin.y, 95*SCREENW_RATE, 40*SCREENW_RATE)];
    productL.backgroundColor = [UIColor whiteColor];
    productL.textColor = RGB(51, 51, 51);
    productL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    productL.textAlignment = NSTextAlignmentLeft;
    productL.text = [NSString stringWithFormat:@"(%@)",[productDic objectForKey:[NSString stringWithFormat:@"%@",_productType]]];
    [addressV addSubview:productL];
    
    UILabel *useTimeL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(estimateL.frame), 345*SCREENW_RATE, 40*SCREENW_RATE)];
    useTimeL.backgroundColor = [UIColor whiteColor];
    useTimeL.textColor = RGB(51, 51, 51);
    useTimeL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    useTimeL.textAlignment = NSTextAlignmentCenter;
    useTimeL.text = [NSString stringWithFormat:@"用车时间 %@",_useTime];
    [addressV addSubview:useTimeL];
        [self tikTok];
   
}
- (void)start:(UIButton *)robBtn
{
    robBtn.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:[Ultitly shareInstance].orderID forKey:@"oid"];
    [[NetManager shareManager]requestUrlPost:RobListAPI andParameter:paraDic withSuccessBlock:^(id data) {
        robBtn.userInteractionEnabled = YES;
        if ([data[@"status"]isEqualToString:@"9000"])
        {

      [self dismissViewControllerAnimated:YES completion:^{
                    _block(@"1");}
       ];

        }
        else if ([data[@"status"]isEqualToString:@"1000"])
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    }
    andFailedBlock:^(NSError *error) {
        
    }];
    
    }

- (void)rest
{
    restL.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:driverSleepAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        restL.userInteractionEnabled = YES;
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            
            [self dismissViewControllerAnimated:YES completion:^{
                _block(@"rest");
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
        restL.userInteractionEnabled = YES;
    }];
}

- (void)tikTok
{
    
    __block NSInteger time = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak BackGroundViewController *weakSelf = self;
                [weakSelf giveUp];
                
            });
         }else{
            //int seconds = time % 4;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);

}

- (void)giveUp
{
    
    NSString *giveUpOrder = [Ultitly shareInstance].orderID;
    giveUpL.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:giveUpOrder forKey:@"ids"];
    [[NetManager shareManager]requestUrlPost:driverGiveUpAPI andParameter:paraDic withSuccessBlock:^(id data)
     {
         giveUpL.userInteractionEnabled = YES;
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             [self dismissViewControllerAnimated:YES completion:^{
                 
             }];
             _block(@"giveUp");
            
             
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
         giveUpL.userInteractionEnabled = YES;
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
