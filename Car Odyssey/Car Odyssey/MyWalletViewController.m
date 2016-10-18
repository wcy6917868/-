//
//  MyWalletViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MyWalletViewController.h"
#import "RechargeViewController.h"
#import "WithDrawViewController.h"
#import "NetManager.h"
#define DepositAPI @"http://139.196.179.91/carmanl/public/center/deposit"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface MyWalletViewController ()
{
   NSString *deposit;
    UILabel *walletNumL;
}

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (void)configNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的钱包";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18*SCREENW_RATE],
       NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 151*SCREENW_RATE)];
    headImage.image = [UIImage imageNamed:@"bg_wodeqianbao@2x"];
    [self.view addSubview:headImage];
    
    walletNumL = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 46*SCREENW_RATE)];
    walletNumL.center = CGPointMake(SCREENW/2, 104*SCREENW_RATE);
    walletNumL.textAlignment = NSTextAlignmentCenter;
    walletNumL.textColor = RGB(255, 255, 255);
    walletNumL.text = @"0";
    walletNumL.font = [UIFont systemFontOfSize:31*SCREENW_RATE];
    [self.view addSubview:walletNumL];
    
    UILabel *remainL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(walletNumL.frame), SCREENW, 20*SCREENW_RATE)];
    remainL.text = @"余额 ( 元 )";
    remainL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    remainL.textAlignment = NSTextAlignmentCenter;
    remainL.textColor = RGB(255, 255, 255);
    remainL.alpha = .8;
    [self.view insertSubview:remainL aboveSubview:headImage];
    
    UIView *reChargeBtn = [[UIView alloc]init];
    reChargeBtn.frame = CGRectMake(110*SCREENW_RATE ,CGRectGetMaxY(remainL.frame)+17*SCREENW_RATE, 60 *SCREENW_RATE, 30*SCREENW_RATE);
    reChargeBtn.backgroundColor = [UIColor blackColor];
    reChargeBtn.layer.cornerRadius = 5;
    reChargeBtn.alpha = .2;
    reChargeBtn.layer.masksToBounds = YES;
    [self.view insertSubview:reChargeBtn aboveSubview:headImage];
    
    UILabel *rechargeL = [[UILabel alloc]initWithFrame:CGRectMake(110*SCREENW_RATE ,CGRectGetMaxY(remainL.frame)+17*SCREENW_RATE, 60 *SCREENW_RATE, 30*SCREENW_RATE)];
    rechargeL.text = @"充值";
    rechargeL.textAlignment = NSTextAlignmentCenter;
    rechargeL.textColor = RGB(255, 255, 255);
    rechargeL.font = [UIFont systemFontOfSize:15];
    [self.view insertSubview:rechargeL aboveSubview:reChargeBtn];
    
    UIView *Withdraw = [[UIView alloc]init];
    Withdraw.frame = CGRectMake(CGRectGetMaxX(reChargeBtn.frame)+30*SCREENW_RATE ,CGRectGetMaxY(remainL.frame)+17*SCREENW_RATE, 60*SCREENW_RATE, 30*SCREENW_RATE);
    Withdraw.backgroundColor = [UIColor blackColor];
    Withdraw.layer.cornerRadius = 5;
    Withdraw.alpha = .2;
    Withdraw.layer.masksToBounds = YES;
    [self.view insertSubview:Withdraw aboveSubview:headImage];
    
    UILabel *WithdrawL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reChargeBtn.frame)+30*SCREENW_RATE,CGRectGetMaxY(remainL.frame)+17*SCREENW_RATE, 60 *SCREENW_RATE, 30*SCREENW_RATE)];
    WithdrawL.text = @"提现";
    WithdrawL.textAlignment = NSTextAlignmentCenter;
    WithdrawL.textColor = RGB(255, 255, 255);
    WithdrawL.font = [UIFont systemFontOfSize:15];
    [self.view insertSubview:WithdrawL aboveSubview:Withdraw];
    
    UIView *rechargeV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImage.frame), SCREENW, 50*SCREENW_RATE)];
    rechargeV.backgroundColor = [UIColor whiteColor];
    rechargeV.userInteractionEnabled = YES;
    UITapGestureRecognizer *toRechargeR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toRechageR)];
    [rechargeV addGestureRecognizer:toRechargeR];
    [self.view addSubview:rechargeV];
    
    UIImageView *rechargeI = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*SCREENW_RATE, 30*SCREENW_RATE)];
    rechargeI.center = CGPointMake(30*SCREENW_RATE, 25*SCREENW_RATE);
    rechargeI.image = [UIImage imageNamed:@"chongzhijilu@2x"];
    [rechargeV addSubview:rechargeI];
    
    UILabel *rechageR = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rechargeI.frame)+5*SCREENW_RATE, 0, 70*SCREENW_RATE, 50*SCREENW_RATE)];
    rechageR.text = @"充值记录";
    rechageR.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    rechageR.textColor = RGB(51, 51, 51);
    [rechargeV addSubview:rechageR];
    
    UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
    arrowV.center = CGPointMake(SCREENW - 20*SCREENW_RATE, 25*SCREENW_RATE);
    arrowV.image = [UIImage imageNamed:@"arrow_right@2x"];
    [rechargeV addSubview:arrowV];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rechargeV.frame), SCREENW, 1*SCREENW_RATE)];
    lineV.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:lineV];
    
    UIView *withDrawV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), SCREENW, 50*SCREENW_RATE)];
    withDrawV.backgroundColor = [UIColor whiteColor];
    withDrawV.userInteractionEnabled = YES;
    UITapGestureRecognizer *withDrawTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toWithDrawR)];
    [withDrawV addGestureRecognizer:withDrawTap];
    [self.view addSubview:withDrawV];
    
    UIImageView *withDrawI = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30*SCREENW_RATE, 30*SCREENW_RATE)];
    withDrawI.center = CGPointMake(30*SCREENW_RATE, 25*SCREENW_RATE);
    withDrawI.image = [UIImage imageNamed:@"tixianjilu@2x"];
    [withDrawV addSubview:withDrawI];
    
    UILabel *withDrawR = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(withDrawI.frame)+5*SCREENW_RATE, 0, 70*SCREENW_RATE, 50*SCREENW_RATE)];
    withDrawR.text = @"提现记录";
    withDrawR.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    withDrawR.textColor = RGB(51, 51, 51);
    [withDrawV addSubview:withDrawR];
    
    UIImageView *arrowV1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
    arrowV1.center = CGPointMake(SCREENW - 20*SCREENW_RATE, 25*SCREENW_RATE);
    arrowV1.image = [UIImage imageNamed:@"arrow_right@2x"];
    [withDrawV addSubview:arrowV1];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(withDrawV.frame), SCREENW, 1*SCREENW_RATE)];
    lineV1.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:lineV1];
    [self getNetData];
   
}

- (void)back
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toRechageR
{
    RechargeViewController *REVC = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:REVC animated:YES];
}

- (void)toWithDrawR
{
    WithDrawViewController *WDVC = [[WithDrawViewController alloc]init];
    [self.navigationController pushViewController:WDVC animated:YES];
}

- (void)getNetData
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"0" forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:DepositAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        NSLog(@"%@",data);
       walletNumL.text = data[@"data"][@"deposit"];
        
    }
    andFailedBlock:^(NSError *error)
    {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
