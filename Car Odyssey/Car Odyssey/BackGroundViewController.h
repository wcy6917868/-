//
//  BackGroundViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/23.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundViewController : UIViewController
@property (nonatomic,strong) UIButton *qiangdanBtn;
@property (nonatomic,strong)void (^block)(NSString *);
@property (nonatomic,copy)NSString *outsetStr;
@property (nonatomic,copy)NSString *finishStr;
@property (nonatomic,copy)NSString *distanceStr;
@property (nonatomic,copy)NSString *intergralStr;
@property (nonatomic,copy)NSString *estimateCost;
@property (nonatomic,copy)NSString *driverLat;
@property (nonatomic,copy)NSString *driverLng;
@property (nonatomic,copy)NSString *productType;
@property (nonatomic,copy)NSString *useTime;
- (void)uiConfig;
@end
