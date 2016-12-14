//
//  AppDelegate.h
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>
#import "LeftSliderViewController.h"
#import "MapViewController.h"

static NSString *appKey = @"d1faa4d8e79bb5e2975b03a3";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)MMDrawerController *drawerController;

@end

