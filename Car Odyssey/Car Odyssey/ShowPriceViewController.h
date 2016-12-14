//
//  ShowPriceViewController.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/26.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPriceViewController : UIViewController
@property (nonatomic,strong)void (^block)(NSString *);
@property (nonatomic,copy)NSString *mileFare;
@property (nonatomic,copy)NSString *orderID;

- (void)configUI;

@end
