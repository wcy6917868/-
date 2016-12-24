//
//  ConmentViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/18.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "ConmentViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#import "InfoCenterCell.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define ActivityInfoAPI @"http://115.29.246.88:9999/msgbox/actmsg"

@interface ConmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ConmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"消息";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)getNetData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:@"0" forKey:@"page"];
    [[NetManager shareManager]requestUrlPost:ActivityInfoAPI andParameter:paraDic withSuccessBlock:^(id data)
    {
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            NSArray *tempArr = data[@"data"][@"msg"];
            for (NSDictionary *dic in tempArr)
            {
                [_dataArray addObject:dic];
            }
        }
        else if ([data[@"status"]isEqualToString:@"1000"])
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV reloadData];
        });
    }
      andFailedBlock:^(NSError *error)
    {
        
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

- (void)configUI
{
    _dataArray = [NSMutableArray array];
    [self getNetData];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self.view addSubview:self.tableV];
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
    InfoCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[InfoCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0f;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleL.text = _dataArray[indexPath.row][@"title"];
    cell.dateL.text = _dataArray[indexPath.row][@"datetime"];
    NSMutableAttributedString *str  = [[NSMutableAttributedString alloc]initWithString:_dataArray[indexPath.row][@"content"]];
    CGSize labelSize = [str boundingRectWithSize:CGSizeMake(SCREENW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    cell.conmentL.frame  = CGRectMake(16*SCREENW_RATE, 63*SCREENW_RATE, 319*SCREENW_RATE, labelSize.height);
    cell.conmentL.text = [NSString stringWithFormat:@"评论 : %@",_dataArray[indexPath.row][@"content"]];
    return cell;
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
