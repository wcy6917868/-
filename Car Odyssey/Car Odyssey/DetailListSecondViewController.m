//
//  DetailListSecondViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/12.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "DetailListSecondViewController.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface DetailListSecondViewController ()

@end

@implementation DetailListSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.view.backgroundColor = RGB(238, 238, 238);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
}

- (void)configUI
{
    UILabel *travelInfoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, 44*SCREENW_RATE)];
    travelInfoL.backgroundColor = [UIColor whiteColor];
    travelInfoL.textColor = RGB(51, 51, 51);
    travelInfoL.font = [UIFont systemFontOfSize:14];
    travelInfoL.text = @"       行程信息";
    [self.view addSubview:travelInfoL];
    
    NSArray *travelInfoArr = @[@"上车地点",@"详细地址",@"到达城市",@"下车地点",@"详细地址"];
    NSArray *travelInfo1Arr = @[_Jmodel.outset,_Jmodel.fdetail,_Jmodel.city,_Jmodel.finish,_Jmodel.fdetail];
    
    for (int i = 0; i < 5; i ++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(travelInfoL.frame)+(1+i*30)*SCREENW_RATE, SCREENW, 30*SCREENW_RATE)];
        label.tag = 100 + i;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        label.text = [NSString stringWithFormat:@"       %@ : %@",travelInfoArr[i],travelInfo1Arr[i]];
        if (i == 2)
        {
            NSString *str =[NSString stringWithFormat:@"       %@ : %@",travelInfoArr[2],travelInfo1Arr[2]];
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange blueRange = NSMakeRange([[str1 string]rangeOfString:travelInfo1Arr[2]].location,[[str1 string]rangeOfString:travelInfo1Arr[2]].length);
            [str1 addAttribute:NSForegroundColorAttributeName value:RGB(37, 155, 255) range:blueRange];
            label.attributedText = str1;
        }
        [self.view addSubview:label];
    }
    UILabel *lastL = [self.view viewWithTag:104];
    
    UILabel *listL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastL.frame)+5*SCREENW_RATE, SCREENW, 45*SCREENW_RATE)];
    listL.textColor = RGB(51, 51, 51);
    listL.backgroundColor = [UIColor whiteColor];
    listL.font = [UIFont systemFontOfSize:14];
    listL.text = @"       订单详情";
    [self.view addSubview:listL];
    
    NSArray *detailInfoArr = @[@"订单号",@"预定信息",@"姓名",@"手机",@"用车时间",@"预定产品",@"产品类型",@"车型",@"租期",@"价格",@"包车类型",@"行程备注"];
    NSArray *detailInfoArr1 = @[_Jmodel.id,_Jmodel.reserve,_Jmodel.name,_Jmodel.mobile,_Jmodel.usetime,_Jmodel.product,_Jmodel.ptype,_Jmodel.models,_Jmodel.term,_Jmodel.price,_Jmodel.type,_Jmodel.remark];
    
    for (int i = 0; i < 12; i ++)
    {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(listL.frame)+(1+i*30)*SCREENW_RATE, SCREENW, 30*SCREENW_RATE)];
        label1.backgroundColor = [UIColor whiteColor];
       
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = RGB(51, 51, 51);
        NSString *str = [NSString stringWithFormat:@"       %@ : %@",detailInfoArr[i],detailInfoArr1[i]];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange grayRange = NSMakeRange([[str1 string]rangeOfString:detailInfoArr1[i]].location, [[str1 string]rangeOfString:detailInfoArr1[i]].length);
        [str1 addAttribute:NSForegroundColorAttributeName value:RGB(136, 136, 136) range:grayRange];
        if (i == 11)
        {
            label1.numberOfLines = 0;
            CGSize labelSize = [str1 boundingRectWithSize:CGSizeMake(SCREENW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            label1.frame = CGRectMake(0, CGRectGetMaxY(listL.frame)+(1+11*30)*SCREENW_RATE, SCREENW, labelSize.height+10);
            
        }
        label1.attributedText = str1;
        [self.view addSubview:label1];
    }
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
