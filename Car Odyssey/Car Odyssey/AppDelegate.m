//
//  AppDelegate.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <IQKeyboardManager.h>
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
@interface AppDelegate ()
@property (nonatomic,strong)LeftSliderViewController *leftViewController;
@property (nonatomic,strong)MapViewController *mapViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpNav];
    [self configDrawer];
    [self configKeyBoard];
    [AMapServices sharedServices].apiKey = @"f2096b79438e8f37cf043e62c90cee14";
    return YES;
}

- (void)configDrawer
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
    //[self.window setRootViewController:_drawerController];
}

- (void)configKeyBoard
{
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.shouldResignOnTouchOutside = YES;
    keyManager.enableAutoToolbar = NO;
}

- (void)setUpNav
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    ViewController *mainVC = [[ViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    self.window.rootViewController = nav;
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
