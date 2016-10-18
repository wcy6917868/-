//
//  PointCell.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"

@interface PointCell : UITableViewCell
@property (nonatomic,strong)UILabel *dateL;
@property (nonatomic,strong)UILabel *overListL;
@property (nonatomic,strong)UIImageView *starImage;
@property (nonatomic,strong)UIImageView *blueImage;
@property (nonatomic,strong)UIButton *editBtn;
@property (nonatomic,strong)UILabel *pointL;
@property (nonatomic,strong)PointModel *model;

@end
