//
//  TotalCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/7.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "TotalCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation TotalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(34*SCREENW_RATE, 0, 80*SCREENW_RATE, 43*SCREENW_RATE)];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = RGB(51, 51, 51);
        [self.contentView addSubview:_titleL];
        
        _moneyTF = [[UITextField alloc]initWithFrame:CGRectMake(222*SCREENW_RATE, 0, 70*SCREENW_RATE, 43*SCREENW_RATE)];
        _moneyTF.font = [UIFont systemFontOfSize:14];
        _moneyTF.userInteractionEnabled = NO;
        _moneyTF.textColor = RGB(254, 71, 80);
        _moneyTF.text = @"0.00 元";
        [self.contentView addSubview:_moneyTF];
        
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
