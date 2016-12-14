//
//  MapViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BackGroundViewController.h"
#import "ShowPriceViewController.h"
#import "MyJourneyViewController.h"
#import "LeftSliderViewController.h"
#import "InfoViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#import "AppDelegate.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define nearByDiverAPI @"http://115.29.246.88:9999/core/interaction"
#define makeAnOrderAPI @"http://115.29.246.88:9999/core/begin"
#define getTheCoustomAPI @"http://115.29.246.88:9999/core/start"
#define coustomArriveAPI @"http://115.29.246.88:9999/core/reach"


@interface MapViewController ()<AMapLocationManagerDelegate,AMapSearchDelegate,MAMapViewDelegate,UIApplicationDelegate,MAMapViewDelegate>
{
    __weak MapViewController *weakSelf ;
    UIView *getCoustomV;
    UILabel *NumL;
    UIImageView *callImage;
    UIView *menuV;
    UIButton *navButton;
    NSMutableArray *nearCarArray;
    MAPointAnnotation *currentAnnotation;
    UIButton *sureBtn;
    BOOL isOpen;
    BOOL isRob;
    NSTimer *timer;
    NSTimer *robOrderTimer;
}
@property (nonatomic,strong)AMapLocationManager *locationManger;
@property (nonatomic,strong)UIButton *getListBtn;
@property (nonatomic,assign)CLLocationCoordinate2D startCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)AMapRoute *route;
@property (nonatomic,assign)NSInteger currentCourse;
@property (nonatomic,assign)NSInteger totalCourse;
@property (nonatomic,strong)NSArray *pathPolylines;
@property (nonatomic,copy)NSString *diriverLontitude;
@property (nonatomic,copy)NSString *diriverLatitude;
@property (nonatomic,copy)NSString *distanceStr;
@property (nonatomic,copy)NSString *intergralStr;
@property (nonatomic,copy)NSString *estimateCost;

@end

@implementation MapViewController

- (NSArray *)pathPolylines
{
    if (!_pathPolylines)
    {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appdle = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdle.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [appdle.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.mapType = MAMapTypeStandard;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AppDelegate *appdle = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdle.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [appdle.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNav];
    [self uiConfig];
    [self configLocationManager];
    [self.locationManger startUpdatingLocation];
    [self chuanzhi];
    [self reset];
    //[self giveUpOrder];

}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    if ([self.str isEqualToString:@"checkPath"])
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
        [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    }
    else
    {
        UIButton *sliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sliderBtn.frame = CGRectMake(0, 0, 18*SCREENW_RATE, 13*SCREENW_RATE);
        [sliderBtn setBackgroundImage:[UIImage imageNamed:@"xiala_bai"] forState:UIControlStateNormal];
        [sliderBtn addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sliderBtn];
        self.navigationItem.title = @"司机端";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    }
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 22*SCREENW_RATE, 16*SCREENW_RATE);
    [rightBtn addTarget:self action:@selector(systemInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"sound1"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
}

- (void)uiConfig
{
    [AMapServices sharedServices].apiKey = @"02708ec6ac84471c617809939d2a6885";
    weakSelf = self;
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    _getListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getListBtn.frame = CGRectMake(15*SCREENW_RATE, SCREENH - 79*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    _getListBtn.backgroundColor = RGB(255, 71, 79);
    [_getListBtn setTitle:@"开始接单 >" forState:UIControlStateNormal];
    [_getListBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    _getListBtn.titleLabel.font = [UIFont systemFontOfSize:21*SCREENW_RATE];
    _getListBtn.layer.masksToBounds = YES;
    _getListBtn.layer.cornerRadius = 5;
    [_getListBtn addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_getListBtn aboveSubview:_mapView];
    
    UIButton *collpaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40*SCREENW_RATE, 40*SCREENW_RATE)];
    [collpaseBtn setBackgroundImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateNormal];
    collpaseBtn.center = CGPointMake(SCREENW-40*SCREENW_RATE, SCREENH-140*SCREENW_RATE);
    [collpaseBtn addTarget:self action:@selector(locate) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:collpaseBtn aboveSubview:_mapView];
    
    navButton = [UIButton buttonWithType:UIButtonTypeSystem];
    navButton.frame = CGRectMake(collpaseBtn.frame.origin.x, CGRectGetMinY(collpaseBtn.frame) - 60*SCREENW_RATE, 40*SCREENW_RATE, 40*SCREENW_RATE);
    [navButton setBackgroundImage:[UIImage imageNamed:@"collapse_mdi"] forState:UIControlStateNormal];
    navButton.titleLabel.font = [UIFont systemFontOfSize:13*SCREENW_RATE];
    [navButton setTitle:@"导航" forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(navigate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navButton];
    
    isOpen = NO;
    isRob = NO;
    
    self.destinationCoordinate  =  CLLocationCoordinate2DMake(_destinationLat.floatValue, _destinationlng.floatValue);
    
  timer =  [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
}

#pragma mark 设置定位管理
- (void)configLocationManager
{
    self.locationManger = [[AMapLocationManager alloc]init];
    [self.locationManger setDelegate:self];
    [self.locationManger setPausesLocationUpdatesAutomatically:NO];
    [self.locationManger setAllowsBackgroundLocationUpdates:YES];
}
#pragma mark 获取定位位置的经纬度
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{

    self.startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    _diriverLatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    _diriverLontitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
   
}

#pragma mark 设置定位图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifer = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifer];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIndetifer];
        }
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:@"thecar"];
        annotationView.centerOffset = CGPointMake(0, - 18);
        return annotationView;
    }
    return nil;
}

#pragma mark 设置驾车路线规划参数
- (void)routePlanning
{
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc]init];
  

    request.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    //目的地
    request.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:request];
}
#pragma mark 查看规划路径所使用方法
- (void)checkPath
{
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc]init];

    request.origin = [AMapGeoPoint locationWithLatitude:_startLat.floatValue longitude:_startLng.floatValue];
    //目的地
    request.destination = [AMapGeoPoint locationWithLatitude:_destinationLat.floatValue longitude:_destinationlng.floatValue];
    
    [self.search AMapDrivingRouteSearch:request];
}

#pragma mark 实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
//    NSString *route = [NSString stringWithFormat:@"navi : %@",response.route];
//    NSLog(@"%@",route);
    AMapPath *path = response.route.paths[0];
    AMapStep *step = path.steps[0];
    NSLog(@"%@",step.polyline);
    NSLog(@"%@",response.route.paths[0]);
    
    if (response.count > 0)
    {
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        
        _pathPolylines = [self polinesForPath:response.route.paths[0]];
        NSLog(@"%@",response.route.paths[0]);
        
        [_mapView addOverlays:_pathPolylines];
        
        currentAnnotation = [[MAPointAnnotation alloc]init];
        currentAnnotation.coordinate = _destinationCoordinate;
        MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc]init];
        startAnnotation.coordinate = _startCoordinate;
        [_mapView showAnnotations:@[startAnnotation,currentAnnotation] animated:YES];
        [_mapView addAnnotation:currentAnnotation];
    }
}

#pragma mark 路径的解析
- (NSArray *)polinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString: step.polyline coordinateCount:&count parseToken:@";"];
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        free(coordinates),coordinates = NULL;
    }];
    return polylines;
}

#pragma mark 解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}

#pragma mark 绘制遮盖时执行的代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoin = kCGLineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
    
}

#pragma mark 回调请求失败
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
}

#pragma mark 调用第三方地图进行导航
- (void)navigate
{
    if (_destinationCoordinate.latitude && _destinationCoordinate.longitude)
    {
        NSString *appName = @"chemanxing";
        NSString *UrlScheme = @"chemanxing://";
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择以下地图进行导航" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *autonaviAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
             if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]])
            {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,UrlScheme,_destinationCoordinate.latitude, _destinationCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            else
            {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机里没有安装高德地图,无法调用其导航" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:cancelAction];
            [self presentViewController:alertC animated:YES completion:nil];
            }
            }];
        UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
         if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://"]])
                                          {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",_destinationCoordinate.latitude,_destinationCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
            }
            else
            {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的手机里没有安装百度地图,无法调用其导航" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:cancelAction];
            [self presentViewController:alertC animated:YES completion:nil];
            }
                                          
            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertC addAction:autonaviAction];
        [alertC addAction:baiduAction];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取目的地后才能开始调用导航" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:cancel];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}
#pragma mark 抢单
- (void)getList:(UIButton *)listBtn
{
    if (isRob == NO)
    {
        _getListBtn.backgroundColor = RGB(37, 155, 255);
        [_getListBtn setTitle:@"接单中" forState:UIControlStateNormal];
         robOrderTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(postRobOrder) userInfo:nil repeats:YES];
        isRob = YES;
        
    }
    else
    {
        [robOrderTimer setFireDate:[NSDate distantFuture]];
        _getListBtn.backgroundColor = RGB(255, 71, 79);
        [_getListBtn setTitle:@"开始接单 >" forState:UIControlStateNormal];
        isRob = NO;
    }
    
}

- (void)postRobOrder
{

    //NSLog(@"111222233");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:_diriverLatitude forKey:@"lat"];
    [paraDic setObject:_diriverLontitude forKey:@"lng"];
    [[NetManager shareManager]requestUrlPost:makeAnOrderAPI andParameter:paraDic withSuccessBlock:^(id data)
     {
         //_getListBtn.userInteractionEnabled = YES;
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             NSLog(@"%@",data);
             _outsetStr = data[@"data"][@"odetail"];
             _finishStr = data[@"data"][@"fdetail"];
             _distanceStr = data[@"data"][@"distance"];
             _intergralStr = data[@"data"][@"integral"];
             _coustomNumStr = data[@"data"][@"mobile"];
             [Ultitly shareInstance].mileage = data[@"data"][@"mileage"];
             [Ultitly shareInstance].fareCost = data[@"data"][@"cost"];
             [Ultitly shareInstance].orderID = data[@"data"][@"id"];
             self.destinationCoordinate  =  CLLocationCoordinate2DMake([data[@"data"][@"lat"] floatValue],[data[@"data"][@"lng"] floatValue]);
                        [self delay];
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
         //_getListBtn.userInteractionEnabled = YES;
     }];
}

- (void)delay
{
    
                [robOrderTimer invalidate];
                robOrderTimer = nil;
                BackGroundViewController *BVC = [[BackGroundViewController alloc]init];
                BVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
                BVC.modalPresentationStyle=
                UIModalPresentationOverFullScreen;
                BVC.outsetStr = _outsetStr;
                BVC.finishStr = _finishStr;
                BVC.distanceStr = _distanceStr;
                BVC.intergralStr = _intergralStr;
                BVC.driverLat = _diriverLatitude;
                BVC.driverLng = _diriverLontitude;
                
                
                [BVC uiConfig];
                
                [self presentViewController:BVC animated:YES completion:^{
                    
                                  }];
                
                BVC.block = ^(NSString *BVCstr)
                {
                    self.str = BVCstr;
                    [weakSelf chuanzhi];
                    [weakSelf rest];
                    [weakSelf giveUpOrder];
                };
    
}
#pragma mark 抽屉栏点击策划
- (void)menu:(UIButton *)clickBtn
{
    if (clickBtn.selected == NO)
    {
        AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appdel.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished)
        {
            
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
        [robOrderTimer setFireDate:[NSDate distantFuture]];
        [self configNetStepUI];
    }
    else if ([self.str isEqualToString:@"checkPath"])
    {
        [self checkPathUI];
    }
   
}

- (void)rest
{
    if ([self.str isEqualToString:@"rest"])
    {
        [self resetRest];
    }
}

- (void)giveUpOrder
{
    if ([self.str isEqualToString:@"giveUp"])
    {
        isRob = NO;
        [self getList:nil];
    }
}

#pragma mark 抢单界面
- (void)configNetStepUI
{
    [_getListBtn setTitle:@"开始接单 >" forState:UIControlStateNormal];
    [_getListBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    _getListBtn.hidden = YES;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 100*SCREENW_RATE)];
    view1.tag = 500;
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [RGB(195, 193, 190)CGColor];
    view1.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:view1];
    
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(20*SCREENW_RATE, 25*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0"];
    [view1 addSubview:blueV];
    
    UILabel *shangcheL  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blueV.frame)+5*SCREENW_RATE, 0,300*SCREENW_RATE, 50*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = [NSString stringWithFormat:@"  上车地点 : %@",_outsetStr];
    [view1 addSubview:shangcheL];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(shangcheL.frame), 210*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(229, 229, 229);
    [view1 addSubview:lineV];
    
    UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redV.center = CGPointMake(blueV.center.x, CGRectGetMaxY(lineV.frame)+26*SCREENW_RATE);
    redV.image = [UIImage imageNamed:@"red0"];
    [view1 addSubview:redV];
    
    UILabel *daodaL = [[UILabel alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(lineV.frame), 300*SCREENW_RATE, 50*SCREENW_RATE)];
    daodaL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    daodaL.textColor = RGB(68, 68, 68);
    daodaL.text = [NSString stringWithFormat:@"  到达地点 : %@",_finishStr];
    [view1 addSubview:daodaL];
    
    callImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64*SCREENW_RATE, 64*SCREENW_RATE)];
    callImage.image = [UIImage imageNamed:@"dianhua1"];
    callImage.center = CGPointMake(SCREENW - 42*SCREENW_RATE, 60*SCREENW_RATE);
    callImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callCustom)];
    [callImage addGestureRecognizer:callTap];
    [view1 addSubview:callImage];

    UIView *distanceV = [[UIView alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, SCREENH - 80*SCREENW_RATE, 345*SCREENW_RATE, 60*SCREENW_RATE)];
    distanceV.tag = 300;
    distanceV.backgroundColor = [UIColor whiteColor];
    distanceV.layer.masksToBounds = YES;
    distanceV.layer.cornerRadius = 5;
    [_mapView addSubview:distanceV];
    
    UIImageView *soundImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18*SCREENW_RATE, 12*SCREENW_RATE)];
    soundImageV.center = CGPointMake(24*SCREENW_RATE, 30*SCREENW_RATE);
    soundImageV.image = [UIImage imageNamed:@"sound2"];
    [distanceV addSubview:soundImageV];
    
    NumL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(soundImageV.frame)+10*SCREENW_RATE, 0, 130*SCREENW_RATE, 60*SCREENW_RATE)];
    NumL.textColor = RGB(68, 68, 68);
    NSString *str = @"距离 3.0公里";
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
    [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:NSMakeRange(3, 3)];
    NumL.font = [UIFont systemFontOfSize:16];
    NumL.attributedText = str1;
    [distanceV addSubview:NumL];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(NumL.frame), 0, 187.5*SCREENW_RATE, 60*SCREENW_RATE);
    sureBtn.backgroundColor = RGB(255, 70, 79);
    [sureBtn setTitle:@"接到乘客 >" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(getCoustom:) forControlEvents:UIControlEventTouchUpInside];
    [distanceV addSubview:sureBtn];
    
    double delayInSeconds = 1.0;
    __block MapViewController* mapself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [mapself routePlanning]; });
    
}

- (void)checkPathUI
{
    _getListBtn.hidden = YES;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 100*SCREENW_RATE)];
    view1.tag = 500;
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [RGB(195, 193, 190)CGColor];
    view1.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:view1];
    
    UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    blueV.center = CGPointMake(20*SCREENW_RATE, 25*SCREENW_RATE);
    blueV.image = [UIImage imageNamed:@"blue0"];
    [view1 addSubview:blueV];
    
    UILabel *shangcheL  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blueV.frame)+5*SCREENW_RATE, 0,300*SCREENW_RATE, 50*SCREENW_RATE)];
    shangcheL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    shangcheL.textColor = RGB(68, 68, 68);
    shangcheL.text = [NSString stringWithFormat:@"  上车地点 : %@",_outsetStr];
    [view1 addSubview:shangcheL];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(shangcheL.frame), 210*SCREENW_RATE, 1)];
    lineV.backgroundColor = RGB(229, 229, 229);
    [view1 addSubview:lineV];
    
    UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
    redV.center = CGPointMake(blueV.center.x, CGRectGetMaxY(lineV.frame)+26*SCREENW_RATE);
    redV.image = [UIImage imageNamed:@"red0"];
    [view1 addSubview:redV];
    
    UILabel *daodaL = [[UILabel alloc]initWithFrame:CGRectMake(shangcheL.frame.origin.x, CGRectGetMaxY(lineV.frame), 300*SCREENW_RATE, 50*SCREENW_RATE)];
    daodaL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    daodaL.textColor = RGB(68, 68, 68);
    daodaL.text = [NSString stringWithFormat:@"  到达地点 : %@",_finishStr];
    [view1 addSubview:daodaL];
    
    callImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64*SCREENW_RATE, 64*SCREENW_RATE)];
    callImage.image = [UIImage imageNamed:@"dianhua1"];
    callImage.center = CGPointMake(SCREENW - 42*SCREENW_RATE, 60*SCREENW_RATE);
    callImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callCustom)];
    [callImage addGestureRecognizer:callTap];
    [view1 addSubview:callImage];
    [self checkPath];
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
    [self.locationManger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
{
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

- (void)getCoustom:(UIButton *)arriveBtn
{
    arriveBtn.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:getTheCoustomAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        arriveBtn.userInteractionEnabled = YES;
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            UIView *view = [_mapView viewWithTag:500];
            //NSLog(@"%@",data);
            arriveBtn.backgroundColor = RGB(37, 155, 255);
            [arriveBtn addTarget:self action:@selector(arrive:) forControlEvents:UIControlEventTouchUpInside];
            [arriveBtn setTitle:@"到达目的地 >" forState:UIControlStateNormal];
            NSString *str = @"已行 2.2公里";
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
            [str1 addAttribute:NSForegroundColorAttributeName value:RGB(254, 71, 80) range:NSMakeRange(3, 3)];
            NumL.font = [UIFont systemFontOfSize:16];
            NumL.attributedText = str1;
            callImage.image = [UIImage imageNamed:@"jianbian0"];
            UILabel *mileageCost = [[UILabel alloc]init];
            mileageCost.frame = callImage.frame;
            mileageCost.textColor = RGB(255, 255, 255);
            mileageCost.numberOfLines = 2;
            mileageCost.font = [UIFont systemFontOfSize:16*SCREENW_RATE];NSString *mileageCostStr = [NSString stringWithFormat:@"%@\n元",[Ultitly shareInstance].fareCost];
            mileageCost.text = mileageCostStr;
            NSLog(@"%@",mileageCost.text);
            mileageCost.textAlignment = NSTextAlignmentCenter;
            [view addSubview:mileageCost];
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
        arriveBtn.userInteractionEnabled = YES;
    }];
   
}

#pragma mark 到达目的地
- (void)arrive:(UIButton *)selectedBtn
{
    selectedBtn.userInteractionEnabled = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userID = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userID forKey:@"did"];
    [paraDic setObject:[Ultitly shareInstance].orderID forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:coustomArriveAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        selectedBtn.userInteractionEnabled = YES;
        ShowPriceViewController *SVC = [[ShowPriceViewController alloc]init];
        SVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
//        SVC.mileFare = _fareStr;
//        SVC.orderID = _orderID;
        SVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [SVC configUI];
        [self presentViewController:SVC animated:YES completion:nil];
        SVC.block = ^(NSString *Str)
        {
            self.resetStr = Str;
            [weakSelf reset];
            [weakSelf continueRobList];
            [weakSelf restart];
        };
    }
    andFailedBlock:^(NSError *error)
    {
        selectedBtn.userInteractionEnabled = YES;
    }];
}

- (void)continueRobList
{
    UIView *addressV = [_mapView viewWithTag:500];
    UIView *distanceV = [_mapView viewWithTag:300];
    if ([self.resetStr isEqualToString:@"stillRob"])
    {
        [_getListBtn setTitle:@"接单中" forState:UIControlStateNormal];
        _getListBtn.hidden = NO;
        [getCoustomV removeFromSuperview];
        [addressV removeFromSuperview];
        [distanceV removeFromSuperview];
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotation:currentAnnotation];
        
    }
}

#pragma mark 重置界面

- (void)reset
{
    UIView *addressV = [_mapView viewWithTag:500];
    UIView *distanceV = [_mapView viewWithTag:300];
    if ([self.resetStr isEqualToString:@"reset"])
    {
        _getListBtn.backgroundColor = RGB(255, 71, 79);
        _getListBtn.hidden = NO;
        [distanceV removeFromSuperview];
        [getCoustomV removeFromSuperview];
        [addressV removeFromSuperview];
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotation:currentAnnotation];
        self.destinationCoordinate = CLLocationCoordinate2DMake(0, 0);
        
    }
}

- (void)restart
{
    UIView *addressV = [_mapView viewWithTag:500];
    UIView *distanceV = [_mapView viewWithTag:300];
    if ([self.resetStr isEqualToString:@"restart"])
    {
        _getListBtn.backgroundColor = RGB(255, 71, 79);
        _getListBtn.hidden = NO;
        [distanceV removeFromSuperview];
        [getCoustomV removeFromSuperview];
        [addressV removeFromSuperview];
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotation:currentAnnotation];
    }
}

#pragma mark 司机休息重设
- (void)resetRest
{
    isRob = NO;
    _getListBtn.backgroundColor = RGB(255, 71, 79);
    [_getListBtn setTitle:@"开始接单 >" forState:UIControlStateNormal];
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotation:currentAnnotation];
}

#pragma mark 获取其他司机位置
- (void)getNetData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:[NSString stringWithFormat:@"%f",self.startCoordinate.longitude] forKey:@"longitude"];
    [paraDic setObject:[NSString stringWithFormat:@"%f",self.startCoordinate.latitude] forKey:@"latitude"];
    [[NetManager shareManager]requestUrlPost:nearByDiverAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        //NSLog(@"%@",data);
        nearCarArray = [NSMutableArray array];
        nearCarArray = data[@"data"][@"car"];
        for (int i = 0; i < nearCarArray.count; i ++)
        {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([nearCarArray[i][@"longitude"] floatValue],[nearCarArray[i][@"latitude"] floatValue] );
            [_mapView addAnnotation:pointAnnotation];
        }
        
    }
    andFailedBlock:^(NSError *error)
    {
        NSLog(@"%@",error);
    }];
}

- (void)delayMethod
{
    [self getNetData];
}

- (void)systemInfo
{
    InfoViewController *infoVC = [[InfoViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark 地图返回原点
- (void)locate
{
    [_mapView setCenterCoordinate:_startCoordinate animated:YES];
    
    //恢复缩放比例和角度
    [_mapView setZoomLevel:13 animated:YES];
    
}

- (void)callCustom
{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",_coustomNumStr];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebView];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
