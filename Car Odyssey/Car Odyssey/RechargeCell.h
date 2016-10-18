//
//  RechargeCell.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface RechargeCell : UITableViewCell
@property (nonatomic,strong)UILabel *moneyL;
@property (nonatomic,strong)UILabel *timeL;
@property (nonatomic,strong)UILabel *chargeL;

@end
