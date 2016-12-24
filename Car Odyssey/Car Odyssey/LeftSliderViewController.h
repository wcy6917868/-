//
//  LeftSliderViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/27.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSliderViewController : UIViewController
@property (nonatomic,strong)void (^block)(NSString *);
@property (nonatomic,strong)UITableView *tableV;

@end
