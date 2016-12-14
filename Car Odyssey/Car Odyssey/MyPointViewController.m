//
//  MyPointViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "MyPointViewController.h"
#import "PointCell.h"
#import "NetManager.h"
#import "PointModel.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define allPointAPI @"http://115.29.246.88:9999/center/allint"
#define getPointAPI @"http://115.29.246.88:9999/center/inint"
#define outPointAPI @"http://115.29.246.88:9999/center/outint"
#define deletePointAPI @"http://115.29.246.88:9999/center/delint"
@interface MyPointViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isSelected;
    BOOL isHidden;
    BOOL isDelete;
    NSMutableArray *suibianArr;
    NSMutableArray *boolArr;
    NSMutableArray *BoolArray;
    UILabel *pointL;
}
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,copy)NSString *btnStatus;


@end

@implementation MyPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    BoolArray = [NSMutableArray array];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的积分";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)configUI
{
    _btnStatus = @"1";
    
    UIView *blueV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 120*SCREENW_RATE)];
    blueV.backgroundColor = RGB(37, 155, 255);
    [self.view addSubview:blueV];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 11*SCREENW_RATE, 12*SCREENW_RATE)];
    iconImage.center = CGPointMake(21*SCREENW_RATE, 86*SCREENW_RATE);
    iconImage.image = [UIImage imageNamed:@"sheriff-badge-2"];
    [self.view insertSubview:iconImage aboveSubview:blueV];
    
    UILabel *iconL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+4*SCREENW_RATE, 64*SCREENW_RATE, 100*SCREENW_RATE, 44*SCREENW_RATE)];
    iconL.text = @"车漫行积分";
    iconL.textColor = RGB(255, 255, 255);
    iconL.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    [self.view insertSubview:iconL aboveSubview:blueV];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *integralStr = [ud objectForKey:@"accountintegral"];
    
    pointL = [[UILabel alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, 120*SCREENW_RATE)];
    pointL.textColor = RGB(255, 255, 255);
    pointL.font = [UIFont systemFontOfSize:50];
    pointL.textAlignment = NSTextAlignmentCenter;
    pointL.text = [NSString stringWithFormat:@"%@",integralStr];
    [self.view insertSubview:pointL aboveSubview:blueV];
    
    UILabel *fenL = [[UILabel alloc]initWithFrame:CGRectMake(260*SCREENW_RATE, 115*SCREENW_RATE, 40*SCREENW_RATE, 40*SCREENW_RATE)];
    fenL.text = @"分";
    fenL.font = [UIFont systemFontOfSize:12*SCREENW_RATE];
    fenL.textColor = RGB(255, 255, 255);
    [self.view insertSubview:fenL belowSubview:pointL];
    
    NSArray *btnTitle = @[@"全部",@"收入",@"支出",@"编辑"];
    for (int i = 0; i < 4; i ++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i *SCREENW/4, CGRectGetMaxY(pointL.frame), SCREENW/4, 44*SCREENW_RATE)];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(68, 68, 68) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:RGB(37, 155, 255) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(isClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 3)
        {
            btn.layer.borderWidth = 1.0;
            btn.layer.borderColor = RGB(238, 238, 238).CGColor;
            [btn setTitle:@"删除" forState:UIControlStateSelected];
            [btn setTitleColor:RGB(254, 71, 80) forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = NO;
        }
        [self.view addSubview:btn];
        UIButton *allBtn = [self.view viewWithTag:100];
        [allBtn addTarget:self action:@selector(getAllData:) forControlEvents:UIControlEventTouchUpInside];
        allBtn.selected = YES;
        UIButton *getBtn = [self.view viewWithTag:101];
        [getBtn addTarget:self action:@selector(getData:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *outBtn = [self.view viewWithTag:102];
        [outBtn addTarget:self action:@selector(outData:) forControlEvents:UIControlEventTouchUpInside];
    }
    isSelected = YES;
    isHidden = NO;
    isDelete = NO;
    [self getAllNetData:allPointAPI];
    [self configTableView];
}

- (void)configTableView
{
    [self.view addSubview:self.tableV];
}

- (UITableView *)tableV
{
    UIButton *btn = [self.view viewWithTag:100];
    if (!_tableV)
    {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10*SCREENW_RATE, SCREENW, SCREENH-CGRectGetMaxY(btn.frame)+10*SCREENW_RATE) style:UITableViewStylePlain];
        _tableV.delegate  = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = RGB(238, 238, 238);
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

- (void)back
{
     self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 编辑方法
- (void)edit:(UIButton *)editBtn
{
    if (_dataArr.count != 0)
    {
        if (isDelete == NO)
        {
            isSelected = NO;
            isHidden = YES;
            editBtn.selected =YES;
            isDelete = YES;
           [self.tableV reloadData];
        }
        else
        {
            UIView *backGroundV = [[UIView alloc]initWithFrame:self.view.bounds];
            backGroundV.backgroundColor = [UIColor blackColor];
            backGroundV.alpha = 0.5;
            [self.view addSubview:backGroundV];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    [backGroundV removeFromSuperview];
                    isSelected = YES;
                    isHidden = NO;
                    isDelete = NO;
                    editBtn.selected = NO;
                if (BoolArray.count != 0)
                {
                    NSString *deleteIDS;
                    deleteIDS = [NSString stringWithFormat:@"%@",BoolArray[0]];
                    for (int i = 1; i < BoolArray.count; i++)
                    {
                        NSString  *str =   [deleteIDS stringByAppendingString:[NSString stringWithFormat:@",%@",BoolArray[i]]];
                        deleteIDS = str;
                        NSLog(@"%@",deleteIDS);
                    }
                    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
                    [paraDic setObject:deleteIDS forKey:@"ids"];
                    [[NetManager shareManager]requestUrlPost:deletePointAPI andParameter:paraDic withSuccessBlock:^(id data)
                     {
                         if ([data[@"status"]isEqualToString:@"9000"])
                         {
                             [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"删除成功"];
                             [BoolArray removeAllObjects];
                             if ([_btnStatus isEqualToString:@"1"])
                             {
                                 [self getAllNetData:allPointAPI];
                             }
                             else if ([_btnStatus isEqualToString:@"2"])
                             {
                                 [self getAllNetData:getPointAPI];
                             }
                             else
                             {
                                 [self getAllNetData:outPointAPI];
                             }
                             
                             
                         }
                         else if ([data[@"status"]isEqualToString:@"1000"])
                         {
                             [BoolArray removeAllObjects];
                             [self.tableV reloadData];
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
                else
                {
                    [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"您没有选中任何数据删除"];
                    editBtn.selected = NO;
                    
                }
                
                
                
                            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [backGroundV removeFromSuperview];
                [self.tableV reloadData];
                isDelete = NO;
                editBtn.selected = NO;
            }];
            [alertC addAction: action];
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:nil];
        }

    }else
    {
        [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"没有数据,无法进行编辑"];
        editBtn.selected = NO;

    }
    
}

- (void)isClick:(UIButton *)selectBtn
{
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
    }
    selectBtn.selected = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139*SCREENW_RATE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cell";
    PointCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[PointCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    cell.editBtn.hidden = isSelected;
    cell.editBtn.selected = NO;
    cell.pointL.hidden = isHidden;
    [cell.editBtn addTarget:self action:@selector(isPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = 10000 + indexPath.row;
    return cell;
}
#pragma mark cell点击方法
- (void)isPress:(UIButton *)selectBtn
{
    if (selectBtn.selected == NO)
    {
        selectBtn.selected = YES;
    }
    else
    {
        selectBtn.selected = NO;
    }
    
    if (selectBtn.selected == YES)
    {
      [BoolArray addObject:[_dataArr[selectBtn.tag - 10000] id]];
        
    }
    else
    {
        for (NSInteger i = BoolArray.count - 1; i >= 0; i --)
        {
            if ([[NSString stringWithFormat:@"%@",[_dataArr[selectBtn.tag - 10000]id]] isEqualToString:[NSString stringWithFormat:@"%@",BoolArray[i]]])
            {
                
                [BoolArray removeObjectAtIndex:i];
            }
        }
    }
}
#pragma mark 获取全部数据
- (void)getAllData:(UIButton *)selectBtn
{
    [self getAllNetData:allPointAPI];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
    }
    selectBtn.selected = YES;
    _btnStatus = @"1";
}
#pragma mark 获取收入积分
- (void)getData:(UIButton *)selectBtn
{
    [self getAllNetData:getPointAPI];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
    }
    selectBtn.selected = YES;
    
    _btnStatus = @"2";
}
#pragma mark 获取支出积分
- (void)outData:(UIButton *)selectBtn
{
    [self getAllNetData:outPointAPI];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.selected = NO;
    }
    selectBtn.selected = YES;
    _btnStatus = @"3";
}

- (void)getAllNetData:(NSString *)dataApi
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:@"0" forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:dataApi andParameter:paraDic withSuccessBlock:^(id data)
     {
         NSMutableArray *tempArray = [NSMutableArray array];
         if ([data[@"status"]isEqualToString:@"9000"])
         {
             _tableV.hidden = NO;
             NSArray *tempArr = data[@"data"][@"detail"];
             for (NSDictionary *dic in tempArr)
             {
                 PointModel *model = [[PointModel alloc]initWithDictionary:dic error:nil];
                
                 [tempArray addObject:model];
                 _dataArr = tempArray;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableV reloadData];
             });
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
