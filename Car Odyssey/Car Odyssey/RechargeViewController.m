//
//  RechargeViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/29.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeCell.h"
#import "NetManager.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define RechargeAPI @"http://139.196.179.91/carmanl/public/center/recharge"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *chargeArr;
@property (nonatomic,strong)NSMutableArray *timeArr;
@property (nonatomic,strong)NSMutableArray *moneyArr;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation RechargeViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"充值记录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(51, 51, 51)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI
{
    _dataArr = [NSMutableArray array];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:@"1" forKey:@"id"];
    [paraDic setObject:@"0" forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:RechargeAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        NSLog(@"%@",data);
        NSArray *tempArr = data[@"data"][@"record"];
        for (NSDictionary *dic in tempArr)
        {
            [_dataArr addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV reloadData];
        });
    }
    andFailedBlock:^(NSError *error)
    {
        NSLog(@"%@",error);
    }];
    [self.view addSubview:self.tableV];
}

- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        self.tableV.separatorInset = UIEdgeInsetsZero;
        self.tableV.layoutMargins = UIEdgeInsetsZero;
        self.tableV.tableFooterView = [UIView new];
        self.tableV.separatorColor = RGB(238, 238, 238);
    }
    return _tableV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69*SCREENW_RATE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell  = [[RechargeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArr[indexPath.row][@"title"];
    cell.detailTextLabel.text = _dataArr[indexPath.row][@"datetime"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.textColor = RGB(136, 136, 136);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.moneyL.text = _dataArr[indexPath.row][@"money"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 10*SCREENW_RATE)];
    view.backgroundColor = RGB(238, 238, 238);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*SCREENW_RATE;
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
