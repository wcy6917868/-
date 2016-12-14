//
//  AllOrderCell.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/5.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface AllOrderCell : UITableViewCell

@property (nonatomic,strong)UILabel *timeL;
@property (nonatomic,strong)UILabel *status;
@property (nonatomic,strong)UILabel *shangCheL;
@property (nonatomic,strong)UILabel *xiaCheL;
@property (nonatomic,strong)OrderModel *model;

@end
