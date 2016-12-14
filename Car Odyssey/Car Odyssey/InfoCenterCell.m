//
//  InfoCenterCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/18.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "InfoCenterCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation InfoCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 355*SCREENW_RATE, 129*SCREENW_RATE)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.contentView addSubview:view];
        
        UIImageView *blueV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
        blueV.center  = CGPointMake(20*SCREENW_RATE, 25*SCREENW_RATE);
        blueV.image = [UIImage imageNamed:@"blue0"];
        [self.contentView addSubview:blueV];
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blueV.frame)+8*SCREENW_RATE, 0, 200*SCREENW_RATE, 50*SCREENW_RATE)];
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = RGB(34, 34, 34);
        [self.contentView addSubview:_titleL];
        
        _dateL = [[UILabel alloc]initWithFrame:CGRectMake(210*SCREENW_RATE, 0, 120*SCREENW_RATE, 50*SCREENW_RATE)];
        _dateL.textColor = RGB(136, 136, 136);
        _dateL.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
        [self.contentView addSubview:_dateL];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(8*SCREENW_RATE, CGRectGetMaxY(_dateL.frame), 340*SCREENW_RATE, 1*SCREENW_RATE)];
        lineV.backgroundColor = RGB(238, 238, 238);
        [self.contentView addSubview:lineV];
        
        _conmentL = [[UILabel alloc]initWithFrame:CGRectMake(blueV.frame.origin.x, CGRectGetMaxY(lineV.frame)+11*SCREENW_RATE, 319*SCREENW_RATE, 48*SCREENW_RATE)];
        _conmentL.textColor = RGB(68, 68, 68);
        _conmentL.font = [UIFont systemFontOfSize:14];
        _conmentL.numberOfLines = 0;
        [self.contentView addSubview:_conmentL];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
