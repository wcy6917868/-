//
//  AllOrderCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/5.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "AllOrderCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation AllOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 355*SCREENW_RATE, 129*SCREENW_RATE)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.contentView addSubview:view];
        
        UIImageView *redV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 10*SCREENW_RATE)];
        redV.center  = CGPointMake(20*SCREENW_RATE, 25*SCREENW_RATE);
        redV.image = [UIImage imageNamed:@"red0"];
        [self.contentView addSubview:redV];
        
        _timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redV.frame)+8*SCREENW_RATE, 0, 150*SCREENW_RATE, 50*SCREENW_RATE)];
        _timeL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        _timeL.textColor = RGB(34, 34, 34);
        [self.contentView addSubview:_timeL];
        
        _status = [[UILabel alloc]initWithFrame:CGRectMake(300*SCREENW_RATE, 0, 50*SCREENW_RATE, 50*SCREENW_RATE)];
        _status.textColor = RGB(254, 71, 80);
        _status.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        [self.contentView addSubview:_status];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(8*SCREENW_RATE, CGRectGetMaxY(_timeL.frame), 340*SCREENW_RATE, 1)];
        lineV.backgroundColor = RGB(238, 238, 238);
        [self.contentView addSubview:lineV];
        
        _shangCheL = [[UILabel alloc]initWithFrame:CGRectMake(20*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+11*SCREENW_RATE, 300*SCREENW_RATE, 28*SCREENW_RATE)];
        _shangCheL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        _shangCheL.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_shangCheL];
        
        _xiaCheL = [[UILabel alloc]initWithFrame:CGRectMake(_shangCheL.frame.origin.x, CGRectGetMaxY(_shangCheL.frame), 300*SCREENW_RATE, 28*SCREENW_RATE)];
        _xiaCheL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        _xiaCheL.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:_xiaCheL];
        
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
        arrowImage.center = CGPointMake(313*SCREENW_RATE, CGRectGetMaxY(lineV.frame)+39*SCREENW_RATE) ;
        arrowImage.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:arrowImage];
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
    NSDictionary *statusDic = @{@"0":@"未付款",@"1":@"待抢单",@"2":@"已上车",@"3":@"已到达"};
    _timeL.text = model.usetime;
    _status.text = [statusDic objectForKey:[NSString stringWithFormat:@"%@",model.status]];
    _shangCheL.text = [NSString stringWithFormat:@"上车地点 : %@",model.odetail];
    _xiaCheL.text = [NSString stringWithFormat:@"下车地点 : %@",model.fdetail];
    
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
