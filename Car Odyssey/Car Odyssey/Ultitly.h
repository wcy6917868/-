//
//  Ultitly.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import <UIKit/UIKit.h>

@interface Ultitly : NSObject
@property (nonatomic,copy)NSString *locid;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,copy)NSString *idcard;
@property (nonatomic,copy)NSString *license;
@property (nonatomic,copy)NSString *carid;
@property (nonatomic,copy)NSString *holder;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *driver_a;
@property (nonatomic,copy)NSString *driver_b;
@property (nonatomic,copy)NSString *travel_a;
@property (nonatomic,copy)NSString *travel_b;
@property (nonatomic,copy)NSString *protrait;
@property (nonatomic,copy)NSString *policy;
@property (nonatomic,copy)NSString *prophet;
@property (nonatomic,copy)NSString *prophet_id;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,copy)NSString *fareCost;
@property (nonatomic,copy)NSString *mileage;
@property (nonatomic,copy)NSString *beginLat;
@property (nonatomic,copy)NSString *beginLng;
@property (nonatomic,copy)NSString *myOrder;
@property (nonatomic,copy)NSString *allOrder;
@property (nonatomic,strong)UIImage *driverA;
@property (nonatomic,strong)UIImage *driverB;
@property (nonatomic,strong)UIImage *travelA;
@property (nonatomic,strong)UIImage *travelB;
@property (nonatomic,strong)UIImage *policyImg;



+ (Ultitly *)shareInstance;

- (void)showMBProgressHUD:(UIView *)view withShowStr:(NSString *)str;

- (void)showMBProgressHUDup:(UIView *)view withShowStr:(NSString *)str;

- (void)showWaitCircle:(BOOL)showCircle inTheView:(UIView *)view;

@end
