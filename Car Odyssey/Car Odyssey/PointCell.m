//
//  PointCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "PointCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation PointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 129*SCREENW_RATE)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.contentView addSubview:view];
        
        _dateL = [[UILabel alloc]initWithFrame:CGRectMake(16*SCREENW_RATE, 0, 150*SCREENW_RATE, 50*SCREENW_RATE)];
        _dateL.font = [UIFont systemFontOfSize:16];
        _dateL.textColor = RGB(34, 34, 34);
        [self.contentView addSubview:_dateL];
        
        UILabel *overL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50*SCREENW_RATE, 50*SCREENW_RATE)];
        overL.center = CGPointMake(SCREENW - 56*SCREENW_RATE, 25*SCREENW_RATE);
        overL.text = @"已完成";
        overL.textColor = RGB(136, 136, 136);
        overL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        [self.contentView addSubview:overL];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(8*SCREENW_RATE, CGRectGetMaxY(_dateL.frame), 340*SCREENW_RATE, 1*SCREENW_RATE)];
        lineV.backgroundColor = RGB(238, 238, 238);
        [self.contentView addSubview:lineV];
        
        _overListL = [[UILabel alloc]initWithFrame:CGRectMake(16*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+9*SCREENW_RATE, 200*SCREENW_RATE, 34*SCREENW_RATE)];
        _overListL.font = [UIFont systemFontOfSize:15];
        _overListL.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_overListL];
        
        for (int i = 0; i < 5; i ++)
        {
            _starImage = [[UIImageView alloc]initWithFrame:CGRectMake(16+(i*21)*SCREENW_RATE, CGRectGetMaxY(_overListL.frame), 16*SCREENW_RATE, 15*SCREENW_RATE)];
            _starImage.image = [UIImage imageNamed:@"wujiaoxing1@2x"];
            [self.contentView addSubview:_starImage];
        }
        
            _blueImage = [[UIImageView alloc]init];
            _blueImage.image = [UIImage imageNamed:@"wujiaoxing0@2x"];
            [self.contentView addSubview:_blueImage];
        
        _pointL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50*SCREENW_RATE,50*SCREENW_RATE)];
        _pointL.center = CGPointMake(SCREENW - 55*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+50*SCREENW_RATE);
        _pointL.backgroundColor = [UIColor clearColor];
        _pointL.font = [UIFont systemFontOfSize:18];
        _pointL.textColor = RGB(51, 51, 51);
        [self.contentView addSubview:_pointL];
        
        _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20*SCREENW_RATE, 20*SCREENW_RATE)];
        _editBtn.center = CGPointMake(SCREENW - 55*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+50*SCREENW_RATE);
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhognzhuangtai@2x"] forState:UIControlStateNormal];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhongzhuangtai@2x"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.editBtn];
    }
    return self;
}

- (void)setModel:(PointModel *)model
{
    _dateL.text = model.datetime;
    _overListL.text = [NSString stringWithFormat:@"完成订单 %@",model.order];
    _blueImage.frame = CGRectMake(16+(_model.star.intValue*21)*SCREENW_RATE, CGRectGetMaxY(_overListL.frame), 16*SCREENW_RATE, 15*SCREENW_RATE);
    _pointL.text = model.integral;
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
