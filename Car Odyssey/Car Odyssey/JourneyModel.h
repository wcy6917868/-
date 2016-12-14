//
//  JourneyModel.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/12.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface JourneyModel : JSONModel

@property (nonatomic,copy)NSString<Optional> *usetime;
@property (nonatomic,copy)NSString<Optional> *status;
@property (nonatomic,copy)NSString<Optional> *odetail;
@property (nonatomic,copy)NSString<Optional> *fdetail;
@property (nonatomic,copy)NSString<Optional> *mileage;
@property (nonatomic,copy)NSString<Optional> *order_sn;
@property (nonatomic,copy)NSString<Optional> *name;
@property (nonatomic,copy)NSString<Optional> *mobile;
@property (nonatomic,copy)NSString<Optional> *product_type;
@property (nonatomic,copy)NSString<Optional> *order_type;
@property (nonatomic,copy)NSString<Optional> *models;
@property (nonatomic,copy)NSString<Optional> *num;
@property (nonatomic,copy)NSString<Optional> *lng;
@property (nonatomic,copy)NSString<Optional> *lat;
@property (nonatomic,copy)NSString<Optional> *create;
@property (nonatomic,copy)NSString<Optional> *remark;
@property (nonatomic,copy)NSString<Optional> *id;
@property (nonatomic,copy)NSString<Optional> *iscancel;
@property (nonatomic,copy)NSString<Optional> *cost;
@property (nonatomic,copy)NSString<Optional> *parking_cost;
@property (nonatomic,copy)NSString<Optional> *stay_cost;
@property (nonatomic,copy)NSString<Optional> *idling_cost;
@property (nonatomic,copy)NSString<Optional> *food_cost;
@property (nonatomic,copy)NSString<Optional> *bill_cost;
@property (nonatomic,copy)NSString<Optional> *face_cost;
@property (nonatomic,copy)NSString<Optional> *over_mileage_cost;
@property (nonatomic,copy)NSString<Optional> *over_time_cost;
@property (nonatomic,copy)NSString<Optional> *highroad_cost;
@property (nonatomic,copy)NSString<Optional> *night_cost;
@property (nonatomic,copy)NSString<Optional> *other_cost;
@property (nonatomic,copy)NSString<Optional> *trip_id;
@property (nonatomic,copy)NSString<Optional> *order_id;
@property (nonatomic,copy)NSString<Optional> *lng_end;
@property (nonatomic,copy)NSString<Optional> *lat_end;


@end
