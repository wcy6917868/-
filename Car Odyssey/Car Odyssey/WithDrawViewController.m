//
//  WithDrawViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "WithDrawViewController.h"
#define RechargeAPI @"http://139.196.179.91/carmanl/public/center/withdraw"

@interface WithDrawViewController ()

@end

@implementation WithDrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"提现记录";
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
