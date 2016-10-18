//
//  DetailListViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/30.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JourneyModel.h"

@interface DetailListViewController : UIViewController
@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,copy)NSString *shangcheStr;
@property (nonatomic,copy)NSString *arriveStr;
@property (nonatomic,copy)NSString *fareStr;
@property (nonatomic,strong)JourneyModel *model;
@end
