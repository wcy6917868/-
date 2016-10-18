//
//  PointModel.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/13.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface PointModel : JSONModel
@property (nonatomic,copy)NSString<Optional>*integral;
@property (nonatomic,copy)NSString<Optional>*id;
@property (nonatomic,copy)NSString<Optional>*datetime;
@property (nonatomic,copy)NSString<Optional>*text;
@property (nonatomic,copy)NSString<Optional>*order;
@property (nonatomic,copy)NSString<Optional>*star;


@end
