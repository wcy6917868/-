//
//  AllOrderViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/12/5.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "AllOrderViewController.h"
#import "DetailListViewController.h"
#import "NetManager.h"
#import "AllOrderCell.h"
#import "OrderModel.h"
#define allOrderAPI @"http://115.29.246.88:9999/core/orderlist/%@"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface AllOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *btnLine;
    UILabel *alertLabel;
}
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)OrderModel *orderModel;

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.view.backgroundColor = RGB(238, 238, 238);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.title = @"全部订单";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    
}

- (void)configUI
{
    self.view.backgroundColor = RGB(238, 238, 238);
    _dataArray = [NSMutableArray array];
    
    //创建点击按钮
    NSArray *btnTitleArr = @[@"即时订单",@"预约订单"];
    for (int i = 0; i < 2; i ++)
    {
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(SCREENW/2 * i, 64, SCREENW/2, 40*SCREENW_RATE);
        orderBtn.backgroundColor = [UIColor whiteColor];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:15*SCREENW_RATE];
        orderBtn.tag = 100 + i;
        [orderBtn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [orderBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [orderBtn setTitleColor:RGB(68, 156, 255) forState:UIControlStateSelected];
        if (i == 0)
        {
            orderBtn.selected = YES;
            
        }
        [orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:orderBtn];
    }
    
    UIButton *imediatelyBtn = [self.view viewWithTag:100];
    btnLine = [[UIView alloc]initWithFrame:CGRectMake(10*SCREENW_RATE, CGRectGetMaxY(imediatelyBtn.frame)-2, 150*SCREENW_RATE, 2*SCREENW_RATE)];
    btnLine.backgroundColor = RGB(68, 156, 255);
    [self.view addSubview:btnLine];
    
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*SCREENW_RATE, 50*SCREENW_RATE)];
    alertLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    alertLabel.textColor = RGB(51, 51, 51);
    alertLabel.text = @"暂时没有数据信息哟~~~";
    [self.view addSubview:alertLabel];
    
    [self getData];
    [self.view addSubview:self.tableV];
    
}

- (void)getData
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *driverID = [ud objectForKey:@"userid"];
    [paraDic setObject:driverID forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:[NSString stringWithFormat:allOrderAPI,@"1"] andParameter:paraDic withSuccessBlock:^(id data)
    {
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             //NSLog(@"%@",data);
             _tableV.hidden = NO;
             NSArray *tempArray = data[@"data"][@"details"];
             NSMutableArray *tempMutableArr = [NSMutableArray array];
             for (NSDictionary *dic in tempArray)
             {
                 _orderModel = [[OrderModel alloc]init];
                 _orderModel.usetime = dic[@"usetime"];
                 _orderModel.status = dic[@"status"];
                 _orderModel.odetail = dic[@"odetail"];
                 _orderModel.fdetail = dic[@"fdetail"];
                 _orderModel.mileage = dic[@"mileage"];
                 _orderModel.order_sn = dic[@"order_sn"];
                 _orderModel.name = dic[@"name"];
                 _orderModel.mobile = dic[@"mobile"];
                 _orderModel.product_type = dic[@"product_type"];
                 _orderModel.order_type = dic[@"order_type"];
                 _orderModel.models = dic[@"models"];
                 _orderModel.num = dic[@"num"];
                 _orderModel.lng = dic[@"lng"];
                 _orderModel.lat = dic[@"lat"];
                 _orderModel.create = dic[@"create"];
                 _orderModel.remark = dic[@"remark"];
                 _orderModel.id = dic[@"id"];
                 _orderModel.lat_end = dic[@"lat_end"];
                 _orderModel.lng_end = dic[@"lng_end"];
                 [tempMutableArr addObject:_orderModel];
                 _dataArray = tempMutableArr;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableV reloadData];
             });
         }
        else
        {
            _tableV.hidden = YES;
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

- (void)getOrderList
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *driverID = [ud objectForKey:@"userid"];
    [paraDic setObject:driverID forKey:@"id"];
    [[NetManager shareManager]requestUrlPost:[NSString stringWithFormat:allOrderAPI,@"2"] andParameter:paraDic withSuccessBlock:^(id data)
     {
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             _tableV.hidden = NO;
             NSArray *tempArray = data[@"data"][@"details"];
             NSMutableArray *tempMutableArr = [NSMutableArray array];
             for (NSDictionary *dic in tempArray)
             {
                 _orderModel = [[OrderModel alloc]init];
                 _orderModel.usetime = dic[@"usetime"];
                 _orderModel.status = dic[@"status"];
                 _orderModel.odetail = dic[@"odetail"];
                 _orderModel.fdetail = dic[@"fdetail"];
                 _orderModel.mileage = dic[@"mileage"];
                 _orderModel.order_sn = dic[@"order_sn"];
                 _orderModel.name = dic[@"name"];
                 _orderModel.mobile = dic[@"mobile"];
                 _orderModel.product_type = dic[@"product_type"];
                 _orderModel.order_type = dic[@"order_type"];
                 _orderModel.models = dic[@"models"];
                 _orderModel.num = dic[@"num"];
                 _orderModel.lng = dic[@"lng"];
                 _orderModel.lat = dic[@"lat"];
                 _orderModel.create = dic[@"create"];
                 _orderModel.remark = dic[@"remark"];
                 _orderModel.id = dic[@"id"];
                 _orderModel.lat_end = dic[@"lat_end"];
                 _orderModel.lng_end = dic[@"lng_end"];
                 [tempMutableArr addObject:_orderModel];
                 _dataArray = tempMutableArr;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableV reloadData];
             });
         }
         else
         {
             _tableV.hidden = YES;
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


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBtn:(UIButton *)selectedBtn
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            if ([btn isEqual:selectedBtn])
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = btnLine.frame;
            frame.origin.x = selectedBtn.frame.origin.x + 15*SCREENW_RATE;
            btnLine.frame = frame;
        }];
    }
    switch (selectedBtn.tag)
    {
        case 100:
        {
            [self getData];
        }
         break;
         case 101:
        {
            [self getOrderList];
        }
         break;
         
        default:
         break;
    }
}

- (UITableView *)tableV
{
    UIButton *imediatelyBtn = [self.view viewWithTag:100];
    if (!_tableV)
    {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(10*SCREENW_RATE, CGRectGetMaxY(imediatelyBtn.frame)+15*SCREENW_RATE, 355*SCREENW_RATE, SCREENH - 120*SCREENW_RATE) style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = RGB(238, 238, 238);
    }
    return _tableV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139*SCREENW_RATE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    AllOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[AllOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0f;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewController *detailVC = [[DetailListViewController alloc]init];
    detailVC.orderModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
