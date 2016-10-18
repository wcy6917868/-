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

@interface MapViewController : UIViewController<MAMapViewDelegate>
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,copy)NSString *str;

//- (void)returnAction;

//- (NSString *)getApplicationName;
//- (NSString *)getApplicationScheme;

@end
