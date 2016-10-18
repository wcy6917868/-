//
//  BackGroundViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/23.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundViewController : UIViewController
@property (nonatomic,strong) UIButton *qiangdanBtn;
@property (nonatomic,strong)void (^block)(NSString *);

@end
