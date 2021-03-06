//
//  JourneyTableViewCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "JourneyTableViewCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation JourneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 355*SCREENW_RATE, 129*SCREENW_RATE)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:view];
        
        UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
        redV.center  = CGPointMake(20*SCREENW_RATE, 25*SCREENW_RATE);
        redV.image = [UIImage imageNamed:@"red0"];
        [self.contentView addSubview:redV];
        
        _dateL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redV.frame)+8*SCREENW_RATE, 0, 150*SCREENW_RATE, 50*SCREENW_RATE)];
        _dateL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        _dateL.textColor = RGB(34, 34, 34);
        [self.contentView addSubview:_dateL];
        
        _status = [[UILabel alloc]initWithFrame:CGRectMake(270*SCREENW_RATE, 0, 80*SCREENW_RATE, 50*SCREENW_RATE)];
        _status.textColor = RGB(254, 71, 80);
        _status.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        _status.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_status];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(8*SCREENW_RATE, CGRectGetMaxY(_dateL.frame), 340*SCREENW_RATE, 1)];
        lineV.backgroundColor = RGB(238, 238, 238);
        [self.contentView addSubview:lineV];
        
        _getL = [[UILabel alloc]initWithFrame:CGRectMake(20*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+11*SCREENW_RATE, 270*SCREENW_RATE, 28*SCREENW_RATE)];
        _getL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        _getL.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_getL];
        
        _arriveL = [[UILabel alloc]initWithFrame:CGRectMake(_getL.frame.origin.x, CGRectGetMaxY(_getL.frame), 270*SCREENW_RATE, 28*SCREENW_RATE)];
        _arriveL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        _arriveL.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_arriveL];
        
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
        arrowImage.center = CGPointMake(313*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+39*SCREENW_RATE) ;
        arrowImage.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:arrowImage];
        
        _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21*SCREENW_RATE, 20*SCREENW_RATE)];
        _editBtn.center = CGPointMake(313*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+39*SCREENW_RATE);
        _editBtn.backgroundColor = [UIColor whiteColor];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhognzhuangtai"] forState:UIControlStateNormal];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhongzhuangtai"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.editBtn];
    }
    return self;
}

- (void)setModel:(JourneyModel *)model
{
     NSDictionary *statusDic = @{@"0":@"待出行",@"1":@"取消申请中"};
    _dateL.text = model.usetime;
    _status.text = [statusDic objectForKey:[NSString stringWithFormat:@"%@",model.iscancel]];
    _getL.text = [NSString stringWithFormat:@"上车地点  : %@",model.odetail];
    _arriveL.text = [NSString stringWithFormat:@"下车地点 : %@",model.fdetail];
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
