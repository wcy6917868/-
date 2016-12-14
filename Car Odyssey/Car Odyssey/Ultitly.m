//
//  Ultitly.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "Ultitly.h"

@implementation Ultitly

+ (Ultitly *)shareInstance
{
    static Ultitly *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        user = [[Ultitly alloc]init];
    });
    return user;
}

- (void)showMBProgressHUD:(UIView *)view withShowStr:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.labelColor = [UIColor whiteColor];
    hud.margin = 10.f;
    hud.yOffset = 160.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showMBProgressHUDup:(UIView *)view withShowStr:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.labelColor = [UIColor whiteColor];
    hud.margin = 10.f;
    hud.yOffset = -3.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}



@end
