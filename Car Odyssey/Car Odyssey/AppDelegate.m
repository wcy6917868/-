//
//  AppDelegate.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <IQKeyboardManager.h>
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "WXApi.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375

@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpNav];
    [self configDrawer];
    //[self configKeyBoard];
//注册高德地图
    [AMapServices sharedServices].apiKey = @"02708ec6ac84471c617809939d2a6885";
//注册微信支付
    [WXApi registerApp:@"wx63dee56d5f21e6e5" withDescription:@"chemanxing"];
//通知图标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//    NSString *advertisngId = [[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
//登录判定
    
//极光推送部分
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    }
    else
    {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0)
        {
            NSLog(@"registrationID获取成功 : %@",registrationID);
        }
        else
        {
            NSLog(@"registrationID获取失败,code:%d",resCode);
        }
    }];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error:%@",error);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    
    NSLog(@"%@",content);
    NSLog(@"%ld",badge);
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode)
        {
            case WXSuccess:
                NSLog(@"支付成功");
                break;
                
            default:
                NSLog(@"支付失败,retcode = %d",resp.errCode);
                break;
        }
    }
}

- (void)configDrawer
{
//    _leftViewController = [[LeftSliderViewController alloc]init];
//    _mapViewController = [[MapViewController alloc]init];
//    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:_leftViewController];
//    UINavigationController *centerNav = [[UINavigationController alloc]initWithRootViewController:_mapViewController];
//    [leftNav setRestorationIdentifier:@"leftNavgationControllerRestorationKey"];
//    [centerNav setRestorationIdentifier:@"centerNavgationControllerRestorationKey"];
//    _drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
//    
//    [self.drawerController setShowsShadow:NO];
//    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
//    [self.drawerController setMaximumLeftDrawerWidth:300*SCREENW_RATE];
//    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
        [self setDrawwer];
    
        ViewController *vc = [[ViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        self.window.rootViewController = nav;;
    
}

//- (void)configKeyBoard
//{
//    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
//    keyManager.shouldResignOnTouchOutside = YES;
//    keyManager.enableAutoToolbar = NO;
//}

- (void)setDrawwer
{
    _leftViewController = [[LeftSliderViewController alloc]init];
    _mapViewController = [[MapViewController alloc]init];
    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:_leftViewController];
    UINavigationController *centerNav = [[UINavigationController alloc]initWithRootViewController:_mapViewController];
    [leftNav setRestorationIdentifier:@"leftNavgationControllerRestorationKey"];
    [centerNav setRestorationIdentifier:@"centerNavgationControllerRestorationKey"];
    _drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
    
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:300*SCREENW_RATE];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)setUpNav
{
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
