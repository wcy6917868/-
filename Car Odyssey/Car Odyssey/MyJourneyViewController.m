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
#define JourneyAPI @"http://139.196.179.91/carmanl/public/center/order"
#define DeleteAPI @"http://139.196.179.91/carmanl/public/center/delorder"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface MyJourneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isClick ;
    BOOL isPress ;
    NSMutableArray *BoolArray;
    NSMutableDictionary *paraDic;
}
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *timeArr;
@property (nonatomic,strong)JourneyModel *Jmodel;
@end

@implementation MyJourneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:@"1" forKey:@"id"];
    [parameterDic setObject:@"0" forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:JourneyAPI andParameter:parameterDic withSuccessBlock:^(id data)
    {
        NSLog(@"%@",data);
    }
       andFailedBlock:^(NSError *error)
     {
         NSLog(@"%@",error);
    }];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
//    BoolArray = [NSMutableArray arrayWithObjects:@NO,@NO,@NO,@NO,@NO,@NO, nil];
    BoolArray = [NSMutableArray array];
    isClick = YES;
    isPress = NO;
}

- (void)configUI
{
    [self acquireData];
    _timeArr = [NSMutableArray array];
    paraDic = [NSMutableDictionary dictionary];
    [self.view addSubview:self.tableV];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)acquireData
{
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:@"1" forKey:@"id"];
    [parameterDic setObject:@"0" forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:JourneyAPI andParameter:parameterDic withSuccessBlock:^(id data)
     {
         NSLog(@"%@",data);
         NSArray *tempArr = data[@"data"][@"order"];
         for (NSDictionary *dic in tempArr)
         {
             _Jmodel = [[JourneyModel alloc]initWithDictionary:dic error:nil];
             [_timeArr addObject:_Jmodel];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableV reloadData];
         });
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
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(10*SCREENW_RATE, 15*SCREENW_RATE, 355*SCREENW_RATE, SCREENH) style:UITableViewStylePlain];
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
    return _timeArr.count;
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
    cell.layer.cornerRadius = 5;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _timeArr[indexPath.row];
    cell.editBtn.hidden = isClick;
    cell.editBtn.selected = NO;
    cell.editBtn.tag = 1000+indexPath.row;
    [cell.editBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


#pragma mark 删除cell操作

- (void)delete
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
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
        isClick = YES;
        //    for (NSInteger i = BoolArray.count - 1 ; i >= 0; i --)
        //    {
        //        if ([BoolArray[i]boolValue] == YES) {
        //            [_timeArr removeObjectAtIndex:i];
        //        }
        //   }
        [[NetManager shareManager]requestUrlPost:DeleteAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             
         }
         andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
        [self.tableV reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [backGroundV removeFromSuperview];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
        isClick = YES;
        [self.tableV reloadData];
    }];
    [alertC addAction:action1];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
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
//    BoolArray[selectedBtn.tag - 1000] = @(![BoolArray[selectedBtn.tag - 1000]boolValue]);
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
        [BoolArray addObject:[_timeArr[selectedBtn.tag - 1000]number]];
        [paraDic setObject:[_timeArr[selectedBtn.tag - 1000]number] forKey:[NSString stringWithFormat:@"%ld",BoolArray.count]];
    }
    else
    {
        for (NSInteger i = BoolArray.count - 1;i >=  0 ;i -- )
        {
            if ([[_timeArr[selectedBtn.tag - 1000]number] isEqualToString:BoolArray[i]])
            {
                [paraDic removeObjectForKey:[NSString stringWithFormat:@"%ld",i+1]];
                [BoolArray removeObjectAtIndex:i];
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewController *detialVC = [[DetailListViewController alloc]init];
    detialVC.model = _Jmodel;
    [self.navigationController pushViewController:detialVC animated:YES];
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
