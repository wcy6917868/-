//
//  ViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#import "JPUSHService.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define SCREENW_RATE SCREENW/375
#define LoginAPI @"http://115.29.246.88:9999/account/login"
#define LaunchPicAPI @"http://115.29.246.88:9999/openapp/ad"

@interface ViewController ()
@property (nonatomic,copy)NSString *lauchStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initUI
{
    [self getNetPicture];
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backgroundImage sd_setImageWithURL:[NSURL URLWithString:_lauchStr] placeholderImage:[UIImage imageNamed:@"startPage.jpg"]];
    [self.view addSubview:backgroundImage];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    
}

- (void)delayMethod
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * isLog = [ud objectForKey:@"isLogin"];
    if ([isLog isEqualToString:@"isLog"])
    {
        [self autoMaticLog];
    }
    else
    {
        [self pushLog];
    }
}

- (void)autoMaticLog
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [ud objectForKey:@"mobile"];
    NSString *password = [ud objectForKey:@"passWord"];
    
    NSMutableDictionary *paramterDic = [NSMutableDictionary dictionary];
    [paramterDic setObject:mobile forKey:@"mobile"];
    [paramterDic setObject:password forKey:@"passwd"];
    [[NetManager shareManager]requestUrlPost:LoginAPI andParameter:paramterDic withSuccessBlock:^(id data)
     {
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             [Ultitly shareInstance].id = data[@"data"][@"id"];
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:@"isLog" forKey:@"isLogin"];
             [ud setObject:data[@"data"][@"id"] forKey:@"userid"];
             [ud setObject:data[@"data"][@"realname"] forKey:@"name"];
             [ud setObject:data[@"data"][@"age"] forKey:@"age"];
             [ud setObject:data[@"data"][@"license"] forKey:@"license"];
             [ud setObject:data[@"data"][@"gender"] forKey:@"gender"];
             [ud setObject:data[@"data"][@"account_money"] forKey:@"accountmoney"];
             [ud setObject:data[@"data"][@"account_integral"] forKey:@"accountintegral"];
             [ud setObject:data[@"data"][@"portrait"] forKey:@"headportrait"];
             [ud setObject:data[@"data"][@"portraitname"] forKey:@"portraitname"];
             [ud setObject:data[@"data"][@"locid"] forKey:@"city"];
             [ud synchronize];
             
             [JPUSHService setAlias:data[@"data"][@"jg_alias"] callbackSelector:nil object:nil];
             [self goMap];
         }
         else if ([data[@"status"]isEqualToString:@"1000"])
         {
             UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
             [alertC addAction:action];
             [self presentViewController:alertC animated:YES completion:nil];
         }
     }
             andFailedBlock:^(NSError *error)
     {
         
     }];
}

- (void)getNetPicture
{
    [[NetManager shareManager]requestUrlGet:LaunchPicAPI withSuccessBlock:^(id data)
    {
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             _lauchStr = [NSString stringWithFormat:@"http://115.29.246.88:9999/%@",data[@"data"][@"adpicname"]];
             //NSLog(@"%@",_lauchStr);
         }
        else
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
    andFailedBlock:^(NSError *error)
    {
        
    }];
}

- (void)goMap
{
     AppDelegate *appdel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    MapViewController *mapVC = [[MapViewController alloc]init];
//     UINavigationController *nav = (UINavigationController *)appdel.drawerController.centerViewController;
//    NSLog(@"-----%@",nav.viewControllers);
//    mapVC = nav.viewControllers[0];
//    mapVC.checkUnfinished = @"isCheck";
    //[self.navigationController pushViewController:mapVC animated:YES];
    mapVC.checkUnfinished = @"isCheck";
    appdel.mapViewController = mapVC;
    [appdel setDrawwer];
    appdel.window.tintColor = [UIColor blueColor];
    appdel.window.rootViewController = appdel.drawerController;
}

- (void)pushLog
{
    LoginViewController *LoginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

- (void)callBack
{
    
}

//- (void)pushJoin
//{
//    RegisterViewController *regisVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:regisVC animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
