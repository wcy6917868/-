//
//  ResOverViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/22.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ResOverViewController.h"
#import "LoginViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface ResOverViewController ()

@end

@implementation ResOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    [self configNav];
    [self configUI];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"车漫行";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(37, 155, 255)}];
}

- (void)configUI
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(100*SCREENW_RATE, 94*SCREENW_RATE, 21, 21)];
    imageV.image = [UIImage imageNamed:@"check-transparent@2x"];
    [self.view addSubview:imageV];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetMaxX(imageV.frame)+8)*SCREENW_RATE, 82*SCREENW_RATE, 170*SCREENW_RATE, 46*SCREENW_RATE)];
    textL.text = @"恭喜您,资料填写成功!";
    textL.textColor = RGB(34, 34, 34);
    textL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textL];
    
    UILabel *textL1 = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, CGRectGetMaxY(textL.frame)*SCREENW_RATE, 301*SCREENW_RATE, 21*SCREENW_RATE)];
    textL1.text = @"您的资料已经成功提交,请耐心等待审核。审核结果会";
    textL1.textColor = RGB(136, 136, 136);
    textL1.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:textL1];
    
    UILabel *textL2 = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, CGRectGetMaxY(textL1.frame)*SCREENW_RATE, 301*SCREENW_RATE, 21*SCREENW_RATE)];
    textL2.text = @"发送到您的手机";
    textL2.textAlignment = NSTextAlignmentCenter;
    textL2.textColor = RGB(136, 136, 136);
    textL2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:textL2];
    
    UILabel *textL3 = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, (CGRectGetMaxY(textL2.frame)+20)*SCREENW_RATE, 301*SCREENW_RATE, 21*SCREENW_RATE)];
    textL3.textColor = RGB(136, 136, 136);
    NSString *contenStr = @"3秒后将返回至登录界面";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contenStr];
     [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 71, 81) range:NSMakeRange(0,1)];
    [textL3 setAttributedText:str];
    textL3.textAlignment = NSTextAlignmentCenter;
    textL3.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:textL3];
    [self daojishi:textL3];

}

- (void)daojishi:(UILabel *)label
{
    __block NSInteger time = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
                [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 255, 255)}];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            });
        }else{
            int seconds = time % 4;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                NSString *contenStr = [NSString stringWithFormat:@"%d秒后将返回至登录界面", seconds];;
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contenStr];
                [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 71, 81) range:NSMakeRange(0,1)];
                label.attributedText = str;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
