//
//  FareDetailController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JourneyModel.h"

@interface FareDetailController : UIViewController
@property (nonatomic,copy)NSString *fareStr;
@property (nonatomic,copy)NSString *mileStr;
@property (nonatomic,copy)NSString *timeStr;
@property (nonatomic,copy)NSString *parkStr;
@property (nonatomic,copy)NSString *emptyStr;
@property (nonatomic,copy)NSString *stayStr;
@property (nonatomic,copy)NSString *cateringStr;
@property (nonatomic,strong)JourneyModel *Jmodel;



@end
