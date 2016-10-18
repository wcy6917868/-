//
//  LeftSliderViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/27.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "LeftSliderViewController.h"
#import "MyCenterTableViewCell.h"
#import "MyJourneyViewController.h"
#import "MyWalletViewController.h"
#import "MyPointViewController.h"
#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "AppDelegate.h"
#
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface LeftSliderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation LeftSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
   
}

- (void)configUI
{
    self.view.backgroundColor = RGB(36, 30, 61);
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *headimage = [[UIImageView alloc]initWithFrame:CGRectMake(0*SCREENW_RATE, 0, 80*SCREENW_RATE, 80*SCREENW_RATE)];
    headimage.center = CGPointMake(60*SCREENW_RATE, 92*SCREENW_RATE);
    headimage.image = [UIImage imageNamed:@"touxiang2@2x"];
    [self.view addSubview:headimage];
    UIImageView *headimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0*SCREENW_RATE, 0, 80*SCREENW_RATE, 80*SCREENW_RATE)];
    headimage1.userInteractionEnabled = YES;
    headimage1.center = CGPointMake(60*SCREENW_RATE, 92*SCREENW_RATE);
    headimage1.image = [UIImage imageNamed:@"touxiang0@2x"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personInfo)];
    [headimage1 addGestureRecognizer:tap];
    [self.view addSubview:headimage1];
    
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headimage.frame)+15*SCREENW_RATE, 72*SCREENW_RATE, 100*SCREENW_RATE, 26*SCREENW_RATE)];
    driverName.text = @"彭师傅";
    driverName.textColor = RGB(255, 255, 255);
    driverName.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:driverName];
    
    UILabel *driverNum = [[UILabel alloc]initWithFrame:CGRectMake(driverName.frame.origin.x, CGRectGetMaxY(driverName.frame), 160*SCREENW_RATE, 21*SCREENW_RATE)];
    driverNum.text = @"沪A88888 黄埔司机";
    driverNum.textColor = RGB(255, 255, 255);
    driverNum.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:driverNum];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(driverNum.frame)+50*SCREENW_RATE, SCREENW, 1*SCREENW_RATE)];
    lineV.backgroundColor = RGB(56, 52, 77);
    [self.view addSubview:lineV];
    
    _imageArr = @[@"brief-case@2x",@"piggy@2x",@"handset@2x",@"info-2@2x",@"settings@2x",@"box-closed-2@2x"];
    
    _titleArr = @[@"我的行程",@"我的钱包",@"联系客服",@"我的积分",@"个人设置",@"推荐有奖"];
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame)+20*SCREENW_RATE, SCREENW, 270*SCREENW_RATE) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableV.frame)+54*SCREENW_RATE, SCREENW, 8*SCREENW_RATE)];
    lineV1.backgroundColor = RGB(56, 52, 77);
    [self.view addSubview:lineV1];
    
    NSArray *bigImArr = @[@"car1@2x",@"shipping@2x",@"tools@2x"];
    NSArray *bigTiL = @[@"车友",@"商城",@"社区"];
    
    for (int i = 0; i < 3; i ++)
    {
        UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(20+(99*i)*SCREENW_RATE, CGRectGetMaxY(lineV1.frame)+32*SCREENW_RATE, 56*SCREENW_RATE, 56*SCREENW_RATE)];
        [imageBtn setBackgroundImage:[UIImage imageNamed:bigImArr[i]] forState:UIControlStateNormal];
        [self.view addSubview:imageBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageBtn.frame)+12*SCREENW_RATE, CGRectGetMaxY(imageBtn.frame), 40*SCREENW_RATE, 36*SCREENW_RATE)];
        label.text = bigTiL[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB(255, 255, 255);
        [self.view addSubview:label];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*SCREENW_RATE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    MyCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
     cell = [[MyCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
    cell.backgroundColor = RGB(36, 30, 61);
    
    cell.imageV.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    cell.textL.text = _titleArr[indexPath.row];
    if (indexPath.row == 3)
    {
        cell.integralBtn.hidden = NO;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MyJourneyViewController *vc = [[MyJourneyViewController alloc]init];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UINavigationController *center = (UINavigationController *)tempAppDelegate.drawerController.centerViewController;
            [center pushViewController:vc animated:YES];
            [tempAppDelegate.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 1:
        {
            MyWalletViewController *walletVC = [[MyWalletViewController alloc]init];
            AppDelegate *appldel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *center = (UINavigationController *)appldel.drawerController.centerViewController;
            [center pushViewController:walletVC animated:YES];
            [appldel.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            MyPointViewController *MPVC = [[MyPointViewController alloc]init];
            AppDelegate *appldel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *center = (UINavigationController *)appldel.drawerController.centerViewController;
            [center pushViewController:MPVC animated:YES];
            [appldel.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
        }
            break;
        case 4:
        {
            SettingViewController *SetVC = [[SettingViewController alloc]init];
            AppDelegate *appldel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *center = (UINavigationController *)appldel.drawerController.centerViewController;
            [center pushViewController:SetVC animated:YES];
            [appldel.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];

        }
            break;
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }

}

- (void)personInfo
{
    PersonInfoViewController *infoVC = [[PersonInfoViewController alloc]init];
    AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *center = (UINavigationController *)appdel.drawerController.centerViewController;
    [center pushViewController:infoVC animated:YES];
    [appdel.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
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
