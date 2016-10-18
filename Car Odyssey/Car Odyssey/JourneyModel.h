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
@property (nonatomic,copy)NSString<Optional>*id;
@property (nonatomic,copy)NSString<Optional>*datetime;
@property (nonatomic,copy)NSString<Optional>*status;
@property (nonatomic,copy)NSString<Optional>*outset;
@property (nonatomic,copy)NSString<Optional>*odetail;
@property (nonatomic,copy)NSString<Optional>*finish;
@property (nonatomic,copy)NSString<Optional>*fdetail;
@property (nonatomic,copy)NSString<Optional>*city;
@property (nonatomic,copy)NSString<Optional>*cost;
@property (nonatomic,copy)NSString<Optional>*star;
@property (nonatomic,copy)NSString<Optional>*text;
@property (nonatomic,copy)NSString<Optional>*mileage;
@property (nonatomic,copy)NSString<Optional>*parking;
@property (nonatomic,copy)NSString<Optional>*idling;
@property (nonatomic,copy)NSString<Optional>*stay;
@property (nonatomic,copy)NSString<Optional>*food;
@property (nonatomic,copy)NSString<Optional>*distance;
@property (nonatomic,copy)NSString<Optional>*number;
@property (nonatomic,copy)NSString<Optional>*reserve;
@property (nonatomic,copy)NSString<Optional>*name;
@property (nonatomic,copy)NSString<Optional>*mobile;
@property (nonatomic,copy)NSString<Optional>*usetime;
@property (nonatomic,copy)NSString<Optional>*product;
@property (nonatomic,copy)NSString<Optional>*models;
@property (nonatomic,copy)NSString<Optional>*term;
@property (nonatomic,copy)NSString<Optional>*price;
@property (nonatomic,copy)NSString<Optional>*type;
@property (nonatomic,copy)NSString<Optional>*ptype;
@property (nonatomic,copy)NSString<Optional>*remark;
@end
