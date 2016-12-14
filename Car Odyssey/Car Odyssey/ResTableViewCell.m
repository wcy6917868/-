//
//  ResTableViewCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/21.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ResTableViewCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface ResTableViewCell ()


@end
@implementation ResTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 148, 50)];
        _label.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        _label.textColor = RGB(51, 51, 51);
        [self.contentView addSubview:_label];
        
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame), 0, SCREENW - CGRectGetMaxX(_label.frame), 50)];
        
        _tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        [_tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"请填写驾驶证所有人姓名" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
        [self.contentView addSubview:_tf];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENW - 33, 20, 10, 18)];
        _imageV.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:_imageV];
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
