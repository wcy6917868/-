//
//  MyCenterTableViewCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/27.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MyCenterTableViewCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@implementation MyCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24*SCREENW_RATE, 24*SCREENW_RATE)];
        _imageV.center = CGPointMake(38*SCREENW_RATE, 22*SCREENW_RATE);
        [self.contentView addSubview:_imageV];
        
        _textL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_imageV.frame)+25*SCREENW_RATE, 0, 100*SCREENW_RATE, 45*SCREENW_RATE)];
        _textL.font = [UIFont systemFontOfSize:17];
        _textL.textColor = RGB(255, 255, 255);
        [self.contentView addSubview:_textL];
        
        _integralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _integralBtn.frame = CGRectMake(SCREENW - 164*SCREENW_RATE, 12*SCREENW_RATE, 40*SCREENW_RATE, 22*SCREENW_RATE);
        [_integralBtn setBackgroundImage:[UIImage imageNamed:@"xiaoxishuliang"] forState:UIControlStateNormal];
        [_integralBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *pointNum = [ud objectForKey:@"accountintegral"];
        [_integralBtn setTitle:[NSString stringWithFormat:@"%@",pointNum] forState:UIControlStateNormal];
        _integralBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _integralBtn.hidden = YES;
        [self.contentView addSubview:_integralBtn];
    }
    return  self;
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
