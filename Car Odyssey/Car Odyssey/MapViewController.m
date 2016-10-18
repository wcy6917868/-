//
//  MapViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "BackGroundViewController.h"
#import "ShowPriceViewController.h"
#import "MyJourneyViewController.h"
#import "LeftSliderViewController.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface MapViewController ()<AMapLocationManagerDelegate,UIApplicationDelegate>
{
    UIView *getCoustomV;
    UILabel *NumL;
    UIImageView *callImage;
    UIView *menuV;
    BOOL isOpen;
}
@property (nonatomic,strong)AMapLocationManager *locationManger;
@property (nonatomic,strong)UIButton *getListBtn;


@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNav];
    [self uiConfig];
    [self configLocationManager];
    [self.locationManger startUpdatingLocation];
    [self chuanzhi];
}
- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    UIButton *sliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sliderBtn.frame = CGRectMake(0, 0, 18*SCREENW_RATE, 13*SCREENW_RATE);
    [sliderBtn setBackgroundImage:[UIImage imageNamed:@"xiala_bai@2x"] forState:UIControlStateNormal];
    [sliderBtn addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sliderBtn];
    self.navigationItem.title = @"司机端";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 22*SCREENW_RATE, 16*SCREENW_RATE);
    [rightBtn addTarget:self action:@selector(systemInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"sound1@2x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}

- (void)uiConfig
{
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];

    _getListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getListBtn.frame = CGRectMake(15*SCREENW_RATE, SCREENH - 79*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    _getListBtn.backgroundColor = RGB(255, 71, 79);
    [_getListBtn setTitle:@"开始接单 >" forState:UIControlStateNormal];
    [_getListBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    _getListBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    _getListBtn.layer.masksToBounds = YES;
    _getListBtn.layer.cornerRadius = 5;
    [_getListBtn addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_getListBtn aboveSubview:_mapView];
    
    UIButton *collpaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40*SCREENW_RATE, 40*SCREENW_RATE)];
    [collpaseBtn setBackgroundImage:[UIImage imageNamed:@"collapse@2x"] forState:UIControlStateNormal];
    collpaseBtn.center = CGPointMake(SCREENW-40*SCREENW_RATE, SCREENH-140*SCREENW_RATE);
    [self.view insertSubview:collpaseBtn aboveSubview:_mapView];
    isOpen = NO;
    
}

- (void)configLocationManager
{
    self.locationManger = [[AMapLocationManager alloc]init];
    [self.locationManger setDelegate:self];
    [self.locationManger setPausesLocationUpdatesAutomatically:NO];
    [self.locationManger setAllowsBackgroundLocationUpdates:YES];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01) ;
    
    MACoordinateRegion region = MACoordinateRegionMake(location.coordinate , span) ;
    
    [_mapView setRegion:region];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.mapType = MAMapTypeStandard;
}

- (void)getList:(UIButton *)listBtn
{
    listBtn.backgroundColor = RGB(37, 155, 255);
    [listBtn setTitle:@"接单中" forState:UIControlStateNormal];
    [self delay];
}

- (void)delay
{
    __block NSInteger time = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                BackGroundViewController *BVC = [[BackGroundViewController alloc]init];
                BVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
                BVC.modalPresentationStyle=
                UIModalPresentationOverFullScreen;
                [self presentViewController:BVC animated:YES completion:nil];
                BVC.block = ^(NSString *BVCstr)
                {
                    self.str = BVCstr;
                    [self chuanzhi];
                };
                
            });
        }else{
            //int seconds = time % 4;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)menu:(UIButton *)clickBtn
{
    if (clickBtn.selected == NO) {
        AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [appdel.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        isOpen = YES;
    }
    else if (clickBtn.selected == YES)
    {
        AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdel.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
        }];
        isOpen = NO;
    }
}

- (void)chuanzhi
{
    if ([self.str isEqualToString:@"1"])
    {
        [self configNetStepUI];
    }
}

- (void)systemInfo
{
    InfoViewController *infoVC = [[InfoViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma net step
- (void)configNetStepUI
{
    [_getListBtn removeFromSuperview];
    //创建接送位置,以及司机联系方式
    getCoustomV = [[UIView alloc]initWithFrame:self.view.bounds];
    getCoustomV.backgroundColor = [UIColor clearColor];
    [_mapView addSubview: getCoustomV];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 100*SCREENW_RATE)];
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [RGB(195, 193, 190)CGColor];
    view1.backgroundColor = [UIColor whiteColor];
    [getCoustomV addSubview:view1];
    
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(39*SCREENW_RATE, 25*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0@2x"];
    [view1 addSubview:blueV];
    
    UILabel *shangcheL  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blueV.frame)+11*SCREENW_RATE, 0,210*SCREENW_RATE, 50*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = @"  上车地点 : 陆家嘴";
    [view1 addSubview:shangcheL];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(shangcheL.frame), 210*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(229, 229, 229);
    [view1 addSubview:lineV];
    
    UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    redV.center = CGPointMake(blueV.center.x, CGRectGetMaxY(lineV.frame)+26*SCREENW_RATE);
    redV.image = [UIImage imageNamed:@"red0@2x"];
    [view1 addSubview:redV];
    
    UILabel *daodaL = [[UILabel alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(lineV.frame), 300*SCREENW_RATE, 50*SCREENW_RATE)];
    daodaL.font = [UIFont systemFontOfSize:16];
    daodaL.textColor = RGB(68, 68, 68);
    daodaL.text = @"  到达地点 : 虹桥火车站";
    [view1 addSubview:daodaL];
    
    callImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64*SCREENW_RATE, 64*SCREENW_RATE)];
    callImage.image = [UIImage imageNamed:@"dianhua1@2x"];
    callImage.center = CGPointMake(SCREENW - 48*SCREENW_RATE, 51*SCREENW_RATE);
    [view1 addSubview:callImage];
    
    UIView *distanceV = [[UIView alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, SCREENH - 80*SCREENW_RATE, 345*SCREENW_RATE, 60*SCREENW_RATE)];
    distanceV.backgroundColor = [UIColor whiteColor];
    distanceV.layer.masksToBounds = YES;
    distanceV.layer.cornerRadius = 5;
    [_mapView addSubview:distanceV];
    
    UIImageView *soundImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18*SCREENW_RATE, 12*SCREENW_RATE)];
    soundImageV.center = CGPointMake(24*SCREENW_RATE, 30*SCREENW_RATE);
    soundImageV.image = [UIImage imageNamed:@"sound2@2x"];
    [distanceV addSubview:soundImageV];
    
    NumL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(soundImageV.frame)+10*SCREENW_RATE, 0, 130*SCREENW_RATE, 60*SCREENW_RATE)];
    NumL.textColor = RGB(68, 68, 68);
    NSString *str = @"距离 3.0公里";
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
    [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:NSMakeRange(3, 3)];
    NumL.font = [UIFont systemFontOfSize:16];
    NumL.attributedText = str1;
    [distanceV addSubview:NumL];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(NumL.frame), 0, 187.5*SCREENW_RATE, 60*SCREENW_RATE);
    sureBtn.backgroundColor = RGB(255, 70, 79);
    [sureBtn setTitle:@"接到乘客 >" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [distanceV addSubview:sureBtn];
    
}

- (void)changefFrame:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x += 300*SCREENW_RATE;
    view.frame = frame;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

- (void)sure:(UIButton *)arriveBtn
{
    arriveBtn.backgroundColor = RGB(37, 155, 255);
    [arriveBtn addTarget:self action:@selector(arrive) forControlEvents:UIControlEventTouchUpInside];
    [arriveBtn setTitle:@"到达目的地 >" forState:UIControlStateNormal];
    NSString *str = @"已行 2.2公里";
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
    [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:NSMakeRange(3, 3)];
    NumL.font = [UIFont systemFontOfSize:16];
    NumL.attributedText = str1;
    callImage.image = [UIImage imageNamed:@"jianbian0@2x"];
    
}

- (void)arrive
{
    ShowPriceViewController *SVC = [[ShowPriceViewController alloc]init];
    SVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    SVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:SVC animated:YES completion:nil];
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
