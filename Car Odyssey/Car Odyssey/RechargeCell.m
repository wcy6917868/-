//
//  RechargeCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _moneyL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*SCREENW_RATE, 69*SCREENW_RATE)];
        _moneyL.center = CGPointMake(SCREENW - 35*SCREENW_RATE ,35*SCREENW_RATE);
        _moneyL.textColor = RGB(255, 46, 80);
        _moneyL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_moneyL];
        
       
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
