//
//  PriceCell.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/7.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleL;
@property (nonatomic,strong)UITextField *moneyTF;
@property (nonatomic,strong)void(^addMoneyBlock)(NSString *);

@end
