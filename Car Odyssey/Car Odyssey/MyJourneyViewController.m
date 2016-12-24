//
//  MyJourneyViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/28.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MyJourneyViewController.h"
#import "JourneyTableViewCell.h"
#import "DetailListViewController.h"
#import "NetManager.h"
#import "JourneyModel.h"
#import "Ultitly.h"
#import <MJRefresh.h>
#define JourneyAPI @"http://115.29.246.88:9999/center/order"
#define DeleteAPI @"http://115.29.246.88:9999/center/delorder"
#define NotStartAPI @"http://115.29.246.88:9999/center/un_order"
#define CancelAPI @"http://115.29.246.88:9999/center/order_cancel"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface MyJourneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isClick;
    BOOL isPress;
    
    int page;
    BOOL isFirstCome;
    int totalPage;
    BOOL isJuHua;
    
    UIView *btnLine;
    UIButton *editBtn;
    NSMutableArray *BoolArray;
}
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)JourneyModel *Jmodel;
@property (nonatomic,copy)NSString *maxtime;
@end

@implementation MyJourneyViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isFirstCome = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableV.mj_header beginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 0;
    isFirstCome = YES;
    isJuHua = NO;
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
    
    self.navigationItem.title = @"我的行程";
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:18],
    NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 40);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
   
    BoolArray = [NSMutableArray array];
    isClick = YES;
    isPress = NO;
    
    //创建点击按钮
    NSArray *btnTitleArr = @[@"我的预约",@"我已完成",@"申请改派"];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *jonuneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jonuneyBtn.frame = CGRectMake(SCREENW/3 * i, 64, SCREENW/3, 40*SCREENW_RATE);
        jonuneyBtn.backgroundColor = [UIColor whiteColor];
        jonuneyBtn.titleLabel.font = [UIFont systemFontOfSize:15*SCREENW_RATE];
        jonuneyBtn.tag = 100 + i;
        [jonuneyBtn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [jonuneyBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [jonuneyBtn setTitleColor:RGB(68, 156, 255) forState:UIControlStateSelected];
        if (i == 0)
        {
            jonuneyBtn.selected = YES;
            
        }
        [jonuneyBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:jonuneyBtn];
    }
    
    UIButton *imediatelyBtn = [self.view viewWithTag:100];
    btnLine = [[UIView alloc]initWithFrame:CGRectMake(10*SCREENW_RATE, CGRectGetMaxY(imediatelyBtn.frame)-2, 90*SCREENW_RATE, 2*SCREENW_RATE)];
    btnLine.backgroundColor = RGB(68, 156, 255);
    [self.view addSubview:btnLine];
    
    UIButton *finishBtn = [self.view viewWithTag:101];
    if (finishBtn.selected == NO)
    {
        editBtn.hidden = YES;
    }
    else
    {
        editBtn.hidden = NO;
    }
}

- (void)configUI
{
   
    _dataArray = [NSMutableArray array];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*SCREENW_RATE, 50*SCREENW_RATE)];
    alertLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    alertLabel.textColor = RGB(51, 51, 51);
    alertLabel.text = @"暂时没有数据信息哟~~~";
    [self.view addSubview:alertLabel];
    
    [self.view addSubview:self.tableV];
    [self acquireData:NotStartAPI andRefresh:YES];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endRefresh
{
    if (page == 0)
    {
        [self.tableV.mj_header endRefreshing];
    }
    [self.tableV.mj_footer endRefreshing];
}

- (void)acquireData:(NSString *)url andRefresh:(BOOL)isRefrsh
{
    if (isRefrsh)
    {
        page = 0;
        isFirstCome = YES;
    }
    else
    {
        page++;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:userid forKey:@"id"];
    [parameterDic setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:url andParameter:parameterDic withSuccessBlock:^(id data)
     {
         [self endRefresh];
         isJuHua = NO;
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             _tableV.hidden = NO;
             NSArray *tempArr = data[@"data"][@"detail"];
             NSMutableArray *tempArray = [NSMutableArray array];
             for (NSDictionary *dic in tempArr)
             {
                 _Jmodel = [[JourneyModel alloc]init];
                 _Jmodel.usetime = dic[@"usetime"];
                 _Jmodel.status = dic[@"status"];
                 _Jmodel.odetail = dic[@"odetail"];
                 _Jmodel.fdetail = dic[@"fdetail"];
                 _Jmodel.mileage = dic[@"mileage"];
                 _Jmodel.order_sn = dic[@"order_sn"];
                 _Jmodel.name = dic[@"name"];
                 _Jmodel.mobile = dic[@"mobile"];
                 _Jmodel.product_type = dic[@"product_type"];
                 _Jmodel.order_type = dic[@"order_type"];
                 _Jmodel.models = dic[@"models"];
                 _Jmodel.num = dic[@"num"];
                 _Jmodel.lng = dic[@"lng"];
                 _Jmodel.lat = dic[@"lat"];
                 _Jmodel.create = dic[@"create"];
                 _Jmodel.remark = dic[@"remark"];
                 _Jmodel.id = dic[@"id"];
                 _Jmodel.iscancel = dic[@"iscancel"];
                 _Jmodel.cost = dic[@"cost"];
                 _Jmodel.idling_cost = dic[@"idling_cost"];
                 _Jmodel.stay_cost = dic[@"stay_cost"];
                 _Jmodel.parking_cost = dic[@"parking_cost"];
                 _Jmodel.food_cost = dic[@"food_cost"];
                 _Jmodel.bill_cost = dic[@"bill_cost"];
                 _Jmodel.face_cost = dic[@"face_cost"];
                 _Jmodel.over_mileage_cost = dic[@"over_mileage_cost"];
                 _Jmodel.over_time_cost = dic[@"over_time_cost"];
                 _Jmodel.highroad_cost = dic[@"highroad_cost"];
                 _Jmodel.night_cost = dic[@"night_cost"];
                 _Jmodel.other_cost = dic[@"oter_cost"];
                 _Jmodel.trip_id = dic[@"trip_id"];
                 _Jmodel.order_id = dic[@"id"];
                 _Jmodel.lat_end = dic[@"lat_end"];
                 _Jmodel.lng_end = dic[@"lng_end"];
                 
                 [tempArray addObject:_Jmodel];
                 _dataArray = tempArray;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableV reloadData];
             });
             isFirstCome = NO;
         }
         else if ([data[@"status"]isEqualToString:@"1000"])
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
         NSLog(@"%@",error);
     }];
}

- (UITableView *)tableV
{
    if (!_tableV)
    {
        UIButton *statusBtn = [self.view viewWithTag:100];
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(10*SCREENW_RATE, CGRectGetMaxY(statusBtn.frame)+15*SCREENW_RATE, 355*SCREENW_RATE, SCREENH - 120*SCREENW_RATE) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = RGB(238, 238, 238);
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139*SCREENW_RATE;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    JourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell  = [[JourneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0f;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    cell.editBtn.hidden = isClick;
    cell.editBtn.selected = NO;
    cell.editBtn.tag = 1000+indexPath.row;
    [cell.editBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    }


- (void)checkBtnStatus
{
    UIButton *finishBtn = [self.view viewWithTag:101];
    if (finishBtn.selected == NO)
    {
        editBtn.hidden = YES;
    }
    else
    {
        editBtn.hidden = NO;
    }
}

#pragma mark 删除cell操作

- (void)delete
{
    if (BoolArray.count != 0)
    {
        UIView *backGroundV = [[UIView alloc]initWithFrame:self.view.bounds];
        backGroundV.backgroundColor = [UIColor blackColor];
        backGroundV.alpha = 0.5;
        [self.view addSubview:backGroundV];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确认要删除吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [backGroundV removeFromSuperview];
                                      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
                                      [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
                                      isClick = YES;
                                      NSString *deleteIDS;
                                      deleteIDS = [NSString stringWithFormat:@"%@",BoolArray[0]];
                                      for (int i = 1; i < BoolArray.count; i ++)
                                      {
                                   NSString  *str =   [deleteIDS stringByAppendingString:[NSString stringWithFormat:@",%@",BoolArray[i]]];
                                          deleteIDS = str;
                                          NSLog(@"%@",deleteIDS);
                                      }
                                      NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                                      [paraDic setObject:deleteIDS forKey:@"ids"];
                                      [[NetManager shareManager]requestUrlPost:DeleteAPI andParameter:paraDic withSuccessBlock:^(id data)
                                       {
            if ([data[@"status"]isEqualToString:@"9000"])
            {
                    [BoolArray removeAllObjects];
                    [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"删除成功"];
                    [self acquireData:JourneyAPI andRefresh:YES];
                                           }
                                           else
                                           {
                                               [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:data[@"msg"]];
                                               [self.tableV reloadData];
                                           }
            }
                                                                andFailedBlock:^(NSError *error)
                                       {
                                           NSLog(@"%@",error);
                                       }];
                                     
                                  }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [BoolArray removeAllObjects];
            [backGroundV removeFromSuperview];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
            isClick = YES;
            [self.tableV reloadData];
        }];
        [alertC addAction:cancel];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else
    {
        [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"没有任何数据,无法删除"];
    }
   
}

- (void)edit
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
     [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
    isClick = NO;
    [self.tableV reloadData];
}

- (void)press:(UIButton *)selectedBtn
{

    if (selectedBtn.selected == NO)
    {
        selectedBtn.selected = YES;
    }
    else
    {
        selectedBtn.selected = NO;
    }
    
    if (selectedBtn.selected == YES)
    {
        [BoolArray addObject:[_dataArray[selectedBtn.tag - 1000]trip_id]];
//        [paraDic setObject:[_dataArray[selectedBtn.tag - 1000]trip_id] forKey:[NSString stringWithFormat:@"%ld",BoolArray.count]];
        NSLog(@"%@",BoolArray);
    }
    else
    {
        for (NSInteger i = BoolArray.count - 1;i >=  0 ;i -- )
        {
            if ([[NSString stringWithFormat:@"%@",[_dataArray[selectedBtn.tag - 1000]trip_id]] isEqualToString:[NSString stringWithFormat:@"%@",BoolArray[i]]])
            {
                [BoolArray removeObjectAtIndex:i];
            }
        }
        NSLog(@"%@",BoolArray);
    }
}

- (void)clickBtn:(UIButton *)clickButton
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            if ([btn isEqual:clickButton])
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
        
        [self checkBtnStatus];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            CGRect frame = btnLine.frame;
            
            frame.origin.x = clickButton.frame.origin.x + 15*SCREENW_RATE;
            
            btnLine.frame = frame;
            
        }];
    }
    switch (clickButton.tag)
    {
        case 100:
        {
            [self acquireData:NotStartAPI andRefresh:YES];
        }
            break;
        case 101:
        {
            [self acquireData:JourneyAPI andRefresh:YES];
        }
            break;
        case 102:
        {
            [self acquireData:CancelAPI andRefresh:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *yuYueBtn = [self.view viewWithTag:100];
    UIButton *finishBtn = [self.view viewWithTag:101];
    UIButton *cancelBtn = [self.view viewWithTag:102];
    if (yuYueBtn.selected == YES)
    {
        DetailListViewController *detialVC = [[DetailListViewController alloc]init];
        detialVC.orderModel = _dataArray[indexPath.row];
        if ([[NSString stringWithFormat:@"%@",[_dataArray[indexPath.row]iscancel]]isEqualToString:@"1"])
        {
            detialVC.orderModel.status = @"";
            [self.navigationController pushViewController:detialVC animated:YES];
        }
        else
        {
            detialVC.orderModel.status = @"2";
            [self.navigationController pushViewController:detialVC animated:YES];
        }
        
    }
    else if (finishBtn.selected == YES)
    {
        DetailListViewController *detialVC = [[DetailListViewController alloc]init];
        detialVC.orderModel = _dataArray[indexPath.row];
        detialVC.orderModel.status = @"3";
        [self.navigationController pushViewController:detialVC animated:YES];
    }
    else if (cancelBtn.selected == YES)
    {
        
         DetailListViewController *detialVC = [[DetailListViewController alloc]init];
        detialVC.orderModel = _dataArray[indexPath.row];
        detialVC.orderModel.status = @"";
        [self.navigationController pushViewController:detialVC animated:YES];
    }
    
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
