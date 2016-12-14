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
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scroView];
    
    UILabel *travelInfoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0*SCREENW_RATE, SCREENW, 44*SCREENW_RATE)];
    travelInfoL.backgroundColor = [UIColor whiteColor];
    travelInfoL.textColor = RGB(51, 51, 51);
    travelInfoL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    travelInfoL.text = @"       行程信息";
    [scroView addSubview:travelInfoL];
    
    NSArray *travelInfoArr = @[@"上车地点",@"下车地点"];
    NSArray *travelInfo1Arr = @[_orderModel.odetail,_orderModel.fdetail];
 
    for (int i = 0; i < travelInfoArr.count; i ++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(travelInfoL.frame)+(1+i*30)*SCREENW_RATE, SCREENW, 30*SCREENW_RATE)];
        label.tag = 100 + i;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        label.text = [NSString stringWithFormat:@"       %@ : %@",travelInfoArr[i],travelInfo1Arr[i]];
        [scroView addSubview:label];
    }
    
    UILabel *lastL = [self.view viewWithTag:101];
    UILabel *listL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastL.frame)+5*SCREENW_RATE, SCREENW, 45*SCREENW_RATE)];
    listL.textColor = RGB(51, 51, 51);
    listL.backgroundColor = [UIColor whiteColor];
    listL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    listL.text = @"       订单详情";
    [scroView addSubview:listL];
    
    NSDictionary *productDic = @{@"1":@"常规单",@"2":@"国内日租",@"3":@"国内送机",@"4":@"国内接机"};
    NSDictionary *orderDic = @{@"1":@"常规单",@"2":@"日租单",@"3":@"预约单"};
    NSDictionary *modelDic = @{@"0":@"不限",@"1":@"经济型",@"2":@"舒适性",@"3":@"商务型",@"4":@"豪华型"};
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[_orderModel.create doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSString *createTime = [dateFormatter stringFromDate:createDate];
    
    NSArray *detailInfoArr = @[@"订单号",@"姓名",@"手机",@"用车时间",@"预定产品",@"车型",@"订单类型",@"乘客数",@"创建日",@"行程备注"];
    NSArray *detailInfoArr1 = @[_orderModel.order_sn,_orderModel.name,_orderModel.mobile,_orderModel.usetime,[productDic objectForKey:[NSString stringWithFormat:@"%@",_orderModel.order_type]],[modelDic objectForKey:[NSString stringWithFormat:@"%@",_orderModel.models]],[orderDic objectForKey:[NSString stringWithFormat:@"%@",_orderModel.order_type]],[NSString stringWithFormat:@"%@ 人",_orderModel.num],createTime,_orderModel.remark];
    
    for (int i = 0; i < detailInfoArr.count; i ++)
    {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(listL.frame)+(1+i*30)*SCREENW_RATE, SCREENW, 30*SCREENW_RATE)];
        label1.backgroundColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
        label1.textColor = RGB(51, 51, 51);
        NSString *str = [NSString stringWithFormat:@"       %@ : %@",detailInfoArr[i],detailInfoArr1[i]];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange grayRange = NSMakeRange([[str1 string]rangeOfString:detailInfoArr1[i]].location, [[str1 string]rangeOfString:detailInfoArr1[i]].length);
        [str1 addAttribute:NSForegroundColorAttributeName value:RGB(136, 136, 136) range:grayRange];
        if (i == detailInfoArr.count - 1)
        {
            label1.numberOfLines = 0;
            CGSize labelSize = [str1 boundingRectWithSize:CGSizeMake(SCREENW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            label1.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
            label1.frame = CGRectMake(0, CGRectGetMaxY(listL.frame)+((detailInfoArr.count - 1)*30)*SCREENW_RATE, SCREENW, labelSize.height+10*SCREENW_RATE);
        }
        label1.attributedText = str1;
        [scroView addSubview:label1];
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
