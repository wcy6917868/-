//
//  FareDetailController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "FareDetailController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface FareDetailController ()

@end

@implementation FareDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.title = @"车费详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
}

- (void)configUI
{
    UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(0, 84*SCREENW_RATE, 220*SCREENW_RATE, 78*SCREENW_RATE)];
    moneyL.font = [UIFont systemFontOfSize:36];
    moneyL.textColor = RGB(254, 71, 80);
    moneyL.text = _Jmodel.cost;
    moneyL.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:moneyL];
    
    UILabel *yuanL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyL.frame), 101*SCREENW_RATE, 40*SCREENW_RATE, 58*SCREENW_RATE)];
    yuanL.font = [UIFont systemFontOfSize:12];
    yuanL.textColor = RGB(102, 102, 102);
    yuanL.text = @"元";
    [self.view addSubview:yuanL];
    
    UILabel *mileL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(yuanL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    mileL.textColor = RGB(51, 51, 51);
    mileL.font = [UIFont systemFontOfSize:14];
    mileL.text  = [NSString stringWithFormat:@"里程"];
    UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, mileL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    priceL.textColor = RGB(51, 51, 51);
    priceL.text = _Jmodel.mileage;
    priceL.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:mileL];
    [self.view addSubview:priceL];
    
    UILabel *parkL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(mileL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    parkL.textColor = RGB(51, 51, 51);
    parkL.font = [UIFont systemFontOfSize:14];
    parkL.text  = @"停车过路费";
    UILabel *priceL1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, parkL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL1.font = [UIFont systemFontOfSize:14];
    priceL1.textColor = RGB(51, 51, 51);
    priceL1.text = _Jmodel.parking_cost;
    priceL1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:parkL];
    [self.view addSubview:priceL1];
    
    UILabel *emptyL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(parkL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    emptyL.textColor = RGB(51, 51, 51);
    emptyL.font = [UIFont systemFontOfSize:14];
    emptyL.text  = @"空驶费";
    UILabel *priceL2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, emptyL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL2.font = [UIFont systemFontOfSize:14];
    priceL2.textColor = RGB(51, 51, 51);
    priceL2.text = _Jmodel.idling_cost;
    priceL2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:emptyL];
    [self.view addSubview:priceL2];
    
    UILabel *stayL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(emptyL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    stayL.textColor = RGB(51, 51, 51);
    stayL.font = [UIFont systemFontOfSize:14];
    stayL.text  = @"住宿费";
    UILabel *priceL3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, stayL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL3.font = [UIFont systemFontOfSize:14];
    priceL3.textColor = RGB(51, 51, 51);
    priceL3.text = _Jmodel.stay_cost;
    priceL3.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:stayL];
    [self.view addSubview:priceL3];
    
    UILabel *cateringL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(stayL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    cateringL.textColor = RGB(51, 51, 51);
    cateringL.font = [UIFont systemFontOfSize:14];
    cateringL.text  = @"餐饮费";
    UILabel *priceL4 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, cateringL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL4.font = [UIFont systemFontOfSize:14];
    priceL4.textColor = RGB(51, 51, 51);
    priceL4.text = _Jmodel.food_cost;
    priceL4.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:cateringL];
    [self.view addSubview:priceL4];
    
    
    UILabel *billL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(cateringL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    billL.textColor = RGB(51, 51, 51);
    billL.font = [UIFont systemFontOfSize:14];
    billL.text  = @"开票金额";
    UILabel *priceL5 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, billL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL5.font = [UIFont systemFontOfSize:14];
    priceL5.textColor = RGB(51, 51, 51);
    priceL5.text = _Jmodel.bill_cost;
    priceL5.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:billL];
    [self.view addSubview:priceL5];
    
    UILabel *faceCostL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(billL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    faceCostL.textColor = RGB(51, 51, 51);
    faceCostL.font = [UIFont systemFontOfSize:14];
    faceCostL.text  = @"面付车费";
    UILabel *priceL6 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, faceCostL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL6.font = [UIFont systemFontOfSize:14];
    priceL6.textColor = RGB(51, 51, 51);
    priceL6.text = _Jmodel.face_cost;
    priceL6.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:faceCostL];
    [self.view addSubview:priceL6];
    
    UILabel *overMileL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(faceCostL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    overMileL.textColor = RGB(51, 51, 51);
    overMileL.font = [UIFont systemFontOfSize:14];
    overMileL.text  = @"超公里费";
    UILabel *priceL7 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, overMileL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL7.font = [UIFont systemFontOfSize:14];
    priceL7.textColor = RGB(51, 51, 51);
    priceL7.text = _Jmodel.over_mileage_cost;
    priceL7.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:overMileL];
    [self.view addSubview:priceL7];
    
    UILabel *overTimeL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(overMileL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    overTimeL.textColor = RGB(51, 51, 51);
    overTimeL.font = [UIFont systemFontOfSize:14];
    overTimeL.text  = @"超时长费";
    UILabel *priceL8 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, overTimeL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL8.font = [UIFont systemFontOfSize:14];
    priceL8.textColor = RGB(51, 51, 51);
    priceL8.text = _Jmodel.over_time_cost;
    priceL8.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:overTimeL];
    [self.view addSubview:priceL8];
    
    UILabel *highRoatL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(overTimeL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    highRoatL.textColor = RGB(51, 51, 51);
    highRoatL.font = [UIFont systemFontOfSize:14];
    highRoatL.text  = @"高速路桥费";
    UILabel *priceL9 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, highRoatL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL9.font = [UIFont systemFontOfSize:14];
    priceL9.textColor = RGB(51, 51, 51);
    priceL9.text = _Jmodel.over_time_cost;
    priceL9.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:highRoatL];
    [self.view addSubview:priceL9];
    
    UILabel *nightServiceL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(highRoatL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    nightServiceL.textColor = RGB(51, 51, 51);
    nightServiceL.font = [UIFont systemFontOfSize:14];
    nightServiceL.text  = @"夜间服务费";
    UILabel *priceL10 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, nightServiceL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL10.font = [UIFont systemFontOfSize:14];
    priceL10.textColor = RGB(51, 51, 51);
    priceL10.text = _Jmodel.night_cost;
    priceL10.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:nightServiceL];
    [self.view addSubview:priceL10];
    
    UILabel *otherCostL = [[UILabel alloc]initWithFrame:CGRectMake(52*SCREENW_RATE, CGRectGetMaxY(nightServiceL.frame), 120*SCREENW_RATE, 29*SCREENW_RATE)];
    otherCostL.textColor = RGB(51, 51, 51);
    otherCostL.font = [UIFont systemFontOfSize:14];
    otherCostL.text  = @"其他费用";
    UILabel *priceL11 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 151*SCREENW_RATE, otherCostL.frame.origin.y, 100*SCREENW_RATE, 29*SCREENW_RATE)];
    priceL11.font = [UIFont systemFontOfSize:14];
    priceL11.textColor = RGB(51, 51, 51);
    priceL11.text = _Jmodel.other_cost;
    priceL11.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:otherCostL];
    [self.view addSubview:priceL11];
    
    UIImageView *jijiaImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    jijiaImage.center = CGPointMake(SCREENW/2-40*SCREENW_RATE, SCREENH - 46*SCREENW_RATE);
    jijiaImage.image = [UIImage imageNamed:@"jijiaguize"];
    [self.view addSubview:jijiaImage];
    
    UILabel *jijiaL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jijiaImage.frame)+10*SCREENW_RATE, SCREENH - 66*SCREENW_RATE, 80*SCREENW_RATE, 40*SCREENW_RATE)];
    jijiaL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    jijiaL.textColor = RGB(102, 102, 102);
    jijiaL.text = @"计价规则";
    [self.view addSubview:jijiaL];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
