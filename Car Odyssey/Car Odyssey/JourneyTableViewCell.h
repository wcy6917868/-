//
//  JourneyTableViewCell.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JourneyModel.h"

@interface JourneyTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *dateL;
@property (nonatomic,strong)UILabel *getL;
@property (nonatomic,strong)UILabel *arriveL;
@property (nonatomic,strong)UIButton *editBtn;
@property (nonatomic,strong)JourneyModel *model;

@end
