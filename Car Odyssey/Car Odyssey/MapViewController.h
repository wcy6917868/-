//
//  MapViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,copy)NSString *str;
@property (nonatomic,copy)NSString *resetStr;
@property (nonatomic,copy)NSString *outsetStr;
@property (nonatomic,copy)NSString *finishStr;
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,copy)NSString *fareStr;
@property (nonatomic,copy)NSString *coustomNumStr;
@property (nonatomic,copy)NSString *destinationLat;
@property (nonatomic,copy)NSString *destinationlng;
@property (nonatomic,copy)NSString *startLat;
@property (nonatomic,copy)NSString *startLng;
@property (nonatomic,copy)NSString *checkUnfinished;

- (void)uiConfig;

@end
