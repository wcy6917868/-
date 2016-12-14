//
//  PriceCell.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/7.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "PriceCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface PriceCell ()<UITextFieldDelegate>

@end

@implementation PriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(34*SCREENW_RATE, 0, 80*SCREENW_RATE, 43*SCREENW_RATE)];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = RGB(51, 51, 51);
        [self.contentView addSubview:_titleL];
        
        _moneyTF = [[UITextField alloc]initWithFrame:CGRectMake(222*SCREENW_RATE, 0, 70*SCREENW_RATE, 43*SCREENW_RATE)];
        _moneyTF.delegate = self;
        _moneyTF.font = [UIFont systemFontOfSize:14];
        _moneyTF.textColor = RGB(51, 51, 51);
        [_moneyTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [_moneyTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"输入金额" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
        [self.contentView addSubview:_moneyTF];
    }
    return self;
}

- (void)valueChange:(UITextField *)textField
{
    _addMoneyBlock(textField.text);
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    _addMoneyBlock(textField.text);
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _addMoneyBlock(textField.text);
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
