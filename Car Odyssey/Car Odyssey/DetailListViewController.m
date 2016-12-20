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
#import "MyJourneyViewController.h"
#import "MapViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define RobListAPI @"http://115.29.246.88:9999/core/struggle"
#define ApplyCancelAPI @"http://115.29.246.88:9999/core/applychange"
#define startOrderAPI @"http://115.29.246.88:9999/core/orderstart"

@interface DetailListViewController ()
{
    UIButton *deleteBtn;
    NSArray *alertArray;
}

@end

@implementation DetailListViewController

- (void)viewDidLoad
{
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
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 40*SCREENW_RATE, 40*SCREENW_RATE);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
//    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
    
}

- (void)configUI
{
    UIView *timeV = [[UIView alloc]initWithFrame:CGRectMake(0, 74*SCREENW_RATE, SCREENW, 42*SCREENW_RATE)];
    timeV.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *statusDic = @{@"0":@"未付款",@"1":@"待抢单",@"2":@"已上车",@"3":@"已到达"};
    UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 7*SCREENW_RATE, 80*SCREENW_RATE, 35*SCREENW_RATE)];
    timeL.font = [UIFont systemFontOfSize:18*SCREENW_RATE];
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.textColor = RGB(170, 170, 170);
    timeL.text = [statusDic objectForKey:[NSString stringWithFormat:@"%@",_orderModel.status]];
    [self.view addSubview:timeV];
    [timeV addSubview:timeL];
    
    UILabel *dateL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 170*SCREENW_RATE, 7*SCREENW_RATE, 160*SCREENW_RATE, 42*SCREENW_RATE)];
    dateL.textColor = RGB(170, 170, 170);
    dateL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    dateL.textAlignment = NSTextAlignmentCenter;
    dateL.text = _orderModel.usetime;
    [timeV addSubview:dateL];
    
    UIView *shangcheV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeV.frame), SCREENW, 45*SCREENW_RATE)];
    shangcheV.backgroundColor = [UIColor whiteColor];
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(20*SCREENW_RATE, 22*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0"];
    UILabel *shangcheL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(blueV.frame)+15*SCREENW_RATE, 0, SCREENW, 45*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = [NSString stringWithFormat:@"上车地点 : %@",_orderModel.odetail];
    [shangcheV addSubview:blueV];
    [shangcheV addSubview:shangcheL];
    [self.view addSubview:shangcheV];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(shangcheL.frame), 320*SCREENW_RATE, 1*SCREENW_RATE)];
    lineV.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:lineV];
    
    UIView *arriveV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shangcheV.frame)+1*SCREENW_RATE, SCREENW, 45*SCREENW_RATE)];
    arriveV.backgroundColor = [UIColor whiteColor];
    UIImageView *redv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redv.center = CGPointMake(20*SCREENW_RATE, 22*SCREENW_RATE);
    redv.image = [UIImage imageNamed:@"red0"];
    UILabel *arriveL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(redv.frame)+15*SCREENW_RATE, 0, SCREENW, 45*SCREENW_RATE)];
    arriveL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    arriveL.textColor = RGB(68, 68, 68);
    arriveL.text = [NSString stringWithFormat:@"到达地点 : %@",_orderModel.fdetail];
    [arriveV addSubview:arriveL];
    [arriveV addSubview:redv];
    [self.view addSubview:arriveV];
    
    if ([[NSString stringWithFormat:@"%@",_orderModel.status] isEqualToString:@"3"])
    {
        NSArray *titleArr = @[@"车费合计",@"车费详情",@"订单详情"];
        
        for (int i = 0; i < titleArr.count; i ++)
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(arriveV.frame)+(10+i*50)*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
            view.tag = 100+i;
            view.layer.borderWidth = .4;
            view.layer.borderColor = RGB(238, 238, 238).CGColor;
            view.backgroundColor = [UIColor whiteColor];
            UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
            textL.textColor = RGB(136, 136, 136);
            textL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            textL.text = titleArr[i];
            UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
            arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
            arrowM.image = [UIImage imageNamed:@"arrow_right"];
            [view addSubview:arrowM];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fareDetail)];
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkListDetail)];
            if (i == 0)
            {
                UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 70*SCREENW_RATE, 0, 60*SCREENW_RATE, 50*SCREENW_RATE)];
                textL.textColor = RGB(68, 68, 68);
                moneyL.font = [UIFont systemFontOfSize:16];
                moneyL.textColor = RGB(68, 68, 68);
                NSString *str = [NSString stringWithFormat:@"%@ 元",_orderModel.mileage];
                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
                NSRange redRange = NSMakeRange([[str1 string]rangeOfString:_orderModel.mileage].location, [[str1 string]rangeOfString:_orderModel.mileage].length);
                [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
                moneyL.attributedText = str1;
                [view addSubview:moneyL];
                [arrowM removeFromSuperview];
            }

            else if (i == 1)
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
    else
    {
        deleteBtn.hidden = YES;
        UIView *incomeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(arriveV.frame)+10*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
        incomeView.backgroundColor = [UIColor whiteColor];
        UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
        textL.textColor = RGB(136, 136, 136);
        textL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        textL.text = @"收入预估";
        [incomeView addSubview:textL];
        UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 80*SCREENW_RATE, 0, 60*SCREENW_RATE, 50*SCREENW_RATE)];
        textL.textColor = RGB(68, 68, 68);
        moneyL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        moneyL.textColor = RGB(68, 68, 68);
        NSString *str = [NSString stringWithFormat:@"%@ 元",_orderModel.mileage];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange redRange = NSMakeRange([[str1 string]rangeOfString:_orderModel.mileage].location, [[str1 string]rangeOfString:_orderModel.mileage].length);
        [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:redRange];
        moneyL.attributedText = str1;
        [incomeView addSubview:moneyL];
        [self.view addSubview:incomeView];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(incomeView.frame) - 1, SCREENW, 1*SCREENW_RATE)];
        lineV.backgroundColor = RGB(238, 238, 238);
        [self.view addSubview:lineV];
        
        UIView *listDetialView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(incomeView.frame), SCREENW, 50*SCREENW_RATE)];
        listDetialView.tag = 110;
        listDetialView.backgroundColor = [UIColor whiteColor];
        listDetialView.userInteractionEnabled = YES;
        UITapGestureRecognizer *listDetailTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkListDetail)];
        [listDetialView addGestureRecognizer:listDetailTap];
        UILabel *detialTextL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
        detialTextL.textColor = RGB(136, 136, 136);
        detialTextL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        detialTextL.text = @"订单详情";
        [listDetialView addSubview:detialTextL];
        [self.view addSubview:listDetialView];
        
        UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(listDetialView.frame) - 1, SCREENW, 1*SCREENW_RATE)];
        lineV1.backgroundColor = RGB(238, 238, 238);
        [self.view addSubview:lineV1];
        
        UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
        arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
        arrowM.image = [UIImage imageNamed:@"arrow_right"];
        [listDetialView addSubview:arrowM];
        
        if ([[NSString stringWithFormat:@"%@",_orderModel.status] isEqualToString:@"1"])
        {
            UIButton *getListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            getListBtn.frame = CGRectMake(0, SCREENH - 50*SCREENW_RATE, SCREENW, 50*SCREENW_RATE);
            getListBtn.backgroundColor = RGB(37, 155, 255);
            [getListBtn setTitle:@"抢 单" forState:UIControlStateNormal];
            [getListBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
            [getListBtn addTarget:self action:@selector(robList:) forControlEvents:UIControlEventTouchUpInside];
            getListBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            [self.view addSubview:getListBtn];
        }
        else if ([[NSString stringWithFormat:@"%@",_orderModel.status] isEqualToString:@"2"])
        {
            deleteBtn.hidden = YES;
            UIView *listDetialView = [self.view viewWithTag:110];
            UIView *checkMapView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(listDetialView.frame), SCREENW, 50*SCREENW_RATE)];
            checkMapView.backgroundColor = [UIColor whiteColor];
            checkMapView.userInteractionEnabled = YES;
            UITapGestureRecognizer *checkMapTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMap)];
            [checkMapView addGestureRecognizer:checkMapTap];
            UILabel *checkMapTextL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 140*SCREENW_RATE, 50*SCREENW_RATE)];
            checkMapTextL.textColor = RGB(136, 136, 136);
            checkMapTextL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            checkMapTextL.text = @"查看地图";
            [checkMapView addSubview:checkMapTextL];
            [self.view addSubview:checkMapView];
            
            UIImageView *arrowM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
            arrowM.center = CGPointMake(SCREENW - 26*SCREENW_RATE, 25*SCREENW_RATE);
            arrowM.image = [UIImage imageNamed:@"arrow_right"];
            [checkMapView addSubview:arrowM];
            
            UIButton *giveUpOrder = [UIButton buttonWithType:UIButtonTypeCustom];
            giveUpOrder.frame = CGRectMake(0, SCREENH - 50*SCREENW_RATE, SCREENW/2, 50*SCREENW_RATE);
            giveUpOrder.backgroundColor = RGB(37, 155, 255);
            [giveUpOrder setTitle:@"放弃订单" forState:UIControlStateNormal];
            [giveUpOrder setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
            [giveUpOrder addTarget:self action:@selector(giveuporder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:giveUpOrder];
            
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame = CGRectMake(CGRectGetMaxX(giveUpOrder.frame), giveUpOrder.frame.origin.y, SCREENW/2, 50*SCREENW_RATE);
            startBtn.backgroundColor = RGB(255, 255, 255);
            [startBtn setTitle:@"开 始" forState:UIControlStateNormal];
            [startBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
            [startBtn addTarget:self action:@selector(startOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:startBtn];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fareDetail
{
    
    FareDetailController *fareVC = [[FareDetailController alloc]init];
    fareVC.Jmodel = _orderModel;
    [self.navigationController pushViewController:fareVC animated:YES];
}

- (void)robList:(UIButton *)robButton
{
    UIAlertController *sureAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确定要抢单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *driverID = [ud objectForKey:@"userid"];
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:driverID forKey:@"id"];
        [paraDic setObject:_orderModel.id forKey:@"oid"];
        
        [[NetManager shareManager]requestUrlPost:RobListAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 NSLog(@"%@",data);
                 alertArray = data[@"data"][@"times"];
                 [self setAlertTime];
                 
                 MyJourneyViewController *journeyVC = [[MyJourneyViewController alloc]init];
                 [self.navigationController pushViewController:journeyVC animated:YES];
                 
             }
             else
             {
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                 [alertC addAction:action];
                 [self presentViewController:alertC animated:YES completion:nil];
             }
             
         }
                andFailedBlock:^(NSError *error)
         {
             
         }];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [sureAlert addAction:sureAction];
    [sureAlert addAction:cancelAction];
    [self presentViewController:sureAlert animated:YES completion:nil];

}

- (void)checkListDetail
{
    DetailListSecondViewController *DesVC = [[DetailListSecondViewController alloc]init];
    DesVC.orderModel = _orderModel;
    [self.navigationController pushViewController:DesVC animated:YES];
}

- (void)giveuporder
{
    UIAlertController *sureAlert = [UIAlertController alertControllerWithTitle:@"确定" message:@"您确定要取消订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userid = [ud objectForKey:@"userid"];
        NSMutableDictionary *paraDic  = [NSMutableDictionary dictionary];
        [paraDic setObject:userid forKey:@"id"];
        [paraDic setObject:_orderModel.id forKey:@"oid"];
        [[NetManager shareManager]requestUrlPost:ApplyCancelAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"申请取消订单成功"];
             }
             else
             {
                 [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"申请取消失败"];
             }
         }
            andFailedBlock:^(NSError *error)
         {
             
         }];

        
    }];
    
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [sureAlert addAction:sureAction];
    [sureAlert addAction:canAction];
    [self presentViewController:sureAlert animated:YES completion:nil];
    
}

- (void)startOrder
{
    UIAlertController *sureAlert = [UIAlertController alertControllerWithTitle:@"确定" message:@"您确定要开始进行跑单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *driverID = [ud objectForKey:@"userid"];
        [paraDic setObject:driverID forKey:@"id"];
        [paraDic setObject:_orderModel.order_id forKey:@"oid"];
        [paraDic setObject:[Ultitly shareInstance].beginLat forKey:@"lat"];
        [paraDic setObject:[Ultitly shareInstance].beginLng forKey:@"lng"];
        
        [[NetManager shareManager]requestUrlPost:startOrderAPI andParameter:paraDic withSuccessBlock:^(id data)
        {
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                MapViewController *mapVC = [[MapViewController alloc]init];
                mapVC.str = @"1";
                mapVC.outsetStr = _orderModel.odetail;
                mapVC.finishStr = _orderModel.fdetail;
                [Ultitly shareInstance].orderID = _orderModel.order_id;
                [Ultitly shareInstance].fareCost = _orderModel.cost;
                [Ultitly shareInstance].mileage = _orderModel.mileage;
                mapVC.coustomNumStr = _orderModel.mobile;
                mapVC.destinationLat = _orderModel.lat;
                mapVC.destinationlng = _orderModel.lng;
                [self.navigationController pushViewController:mapVC animated:YES];

            }
            else
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];

            }
        }
        andFailedBlock:^(NSError *error)
        {
            
        }];
            }];
    
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [sureAlert addAction:canAction];
    [sureAlert addAction:sureAction];
    [self presentViewController:sureAlert animated:YES completion:nil];
   
}

- (void)checkMap
{
    MapViewController *mapVC = [[MapViewController alloc]init];
    mapVC.str = @"checkPath";
    mapVC.outsetStr = _orderModel.odetail;
    mapVC.finishStr = _orderModel.fdetail;
    mapVC.coustomNumStr = _orderModel.mobile;
    mapVC.startLat = _orderModel.lat;
    mapVC.startLng = _orderModel.lng;
    mapVC.destinationLat = _orderModel.lat_end;
    mapVC.destinationlng = _orderModel.lng_end;
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

- (void)setAlertTime
{
    for (int i = 0; i < alertArray.count; i ++)
    {
        NSDate *alertDate = [NSDate dateWithTimeIntervalSince1970:[alertArray[i] doubleValue]];
        NSTimeInterval time = [alertDate timeIntervalSinceNow];
        NSLog(@"%f",time);
        [self registerLocalNotification:time];
    }
}

- (void)registerLocalNotification:(CGFloat)alertTime
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    notification.fireDate = fireDate;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.repeatInterval = 0;
    
    notification.alertBody = @"马上要上车接乘客了";
    
    notification.applicationIconBadgeNumber = 1;
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *userDic = [NSDictionary dictionaryWithObject:@"les's go go go" forKey:@"key"];
    notification.userInfo = userDic;
    
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
        notification.repeatInterval = 0;
    }
    else
    {
        notification.repeatInterval = 0;
    }
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
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
