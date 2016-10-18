//
//  CarIDRegisViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/21.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "CarIDRegisViewController.h"
#import "ResTableViewCell.h"
#import "ResOverViewController.h"
#import "PostGuaranteeViewController.h"
#import "PostDrivingLicenceViewController.h"
#import "WalkLienceViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define RegisterAPI @"http://139.196.179.91/carmanl/public/account/register"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface CarIDRegisViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableV;
@property (nonatomic,strong)UIView *headV;
@property (nonatomic,strong)UIView *FootV;
@property (nonatomic,strong)UIButton *overBtn;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)void (^block)(NSString *);

@end

@implementation CarIDRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}

- (void)configNav
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 56*SCREENW_RATE, 20*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"chemanxingx2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(135, 135, 135)} forState:UIControlStateNormal];
}

- (void)configUI
{
    //提示图标
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *promptView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 44*SCREENW_RATE)];
    promptView.tag = 100;
    promptView.backgroundColor = RGB(37, 155, 255);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21*SCREENW_RATE, 21*SCREENW_RATE)];
    imageV.center = CGPointMake(36*SCREENW_RATE, 22*SCREENW_RATE);
    imageV.image = [UIImage imageNamed:@"zhuyi0@2x"];
    [promptView addSubview:imageV];
    
    UILabel *zhuyiText = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+8*SCREENW_RATE, 11*SCREENW_RATE, 280*SCREENW_RATE, 22*SCREENW_RATE)];
    zhuyiText.text = @"注意过程中需要用到驾驶证、行驶证和保单";
    zhuyiText.textColor = RGB(255, 255, 255);
    zhuyiText.font = [UIFont systemFontOfSize:14*SCREENW_RATE];
    [promptView addSubview:zhuyiText];
    
    UIButton *chaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chaBtn.frame = CGRectMake(0, 0, 16*SCREENW_RATE, 16*SCREENW_RATE);
    chaBtn.center = CGPointMake(CGRectGetMaxX(zhuyiText.frame)+20*SCREENW_RATE, 22*SCREENW_RATE);
    [chaBtn setBackgroundImage:[UIImage imageNamed:@"cha@2x"] forState:UIControlStateNormal];
    [chaBtn addTarget:self action:@selector(cha) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:chaBtn];
    
    UILabel *zhuyiL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 79*SCREENW_RATE, SCREENW, 15*SCREENW_RATE)];
    zhuyiL.text =  @"准确填写车辆信息,享受120万元意外险保障";
    zhuyiL.textColor  = RGB(170, 170, 170);
    zhuyiL.textAlignment = NSTextAlignmentLeft;
    zhuyiL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.myTableV];
    [self.view addSubview:zhuyiL];
    [self.view addSubview:promptView];
    
    UITableViewHeaderFooterView *view = [_myTableV headerViewForSection:1];
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 44*SCREENW_RATE)];
    UILabel *headL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150*SCREENW_RATE, 44*SCREENW_RATE)];
    headL.text = @"请上传证件照";
    headL.font = [UIFont systemFontOfSize:14];
    headL.textColor = RGB(136, 136, 136);
    [headV addSubview:headL];
    [view addSubview:headV];
    
}

- (UITableView *)myTableV
{
    if (!_myTableV) {
        _myTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 9*SCREENW_RATE, SCREENW, SCREENH) style:UITableViewStyleGrouped];
        _myTableV.delegate = self;
        _myTableV.dataSource = self;
        UITableViewHeaderFooterView *view = [_myTableV headerViewForSection:1];
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 50*SCREENW_RATE)];
        _myTableV.separatorColor = RGB(238, 238, 238);
        [view addSubview:headV];
    }
    return _myTableV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 50)];
        UILabel *headL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, -25*SCREENW_RATE, 120*SCREENW_RATE, 50*SCREENW_RATE)];
                headL.text = @"请上传证件照";
                headL.font = [UIFont systemFontOfSize:14];
                headL.textColor = RGB(170, 170, 170);
        [_headV addSubview:headL];
    }
    return _headV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        _FootV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 300*SCREENW_RATE)];
        _overBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 46*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
        [_overBtn setTitle:@"完成" forState:UIControlStateNormal];
        _overBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _overBtn.backgroundColor = RGB(37, 155, 255);
        [_overBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_overBtn addTarget:self action:@selector(over1) forControlEvents:UIControlEventTouchUpInside];
        [_FootV addSubview:_overBtn];
    }
     return _FootV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 300;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            if (indexPath.section == 0 && indexPath.row == 1)
        {
            ResTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell1) {
                cell1 = [[ResTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell1.label.text = @"车辆所有人";
                [Ultitly shareInstance].holder = cell1.tf.text;
                [cell1.imageV removeFromSuperview];
            }
            return cell1;
            
        }else if (indexPath.section == 0 && indexPath.row == 2)
                  {
                      ResTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                      if (!cell2) {
                          cell2 = [[ResTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                      cell2.label.text = @"车辆注册日期";
                      cell2.tf.textColor = [UIColor blackColor];
                      cell2.tf.enabled = NO;
                      cell2.tf.placeholder = @"请选择日期";
                      cell2.tag = 999;
                      
                      [cell2.imageV removeFromSuperview];
                  }
                      return cell2;
                  }
        else if (indexPath.section == 1 && indexPath.row == 0)
        {
            ResTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell3) {
                cell3 = [[ResTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                cell3.label.text = @"上传驾驶证照片";
                cell3.tag = 1000;
                [cell3.tf removeFromSuperview];
        }
            return cell3;
        }
        else
        {
            ResTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[ResTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                if (indexPath.section == 0 && indexPath.row == 0) {
                     cell.label.text = @"车型";
                    [cell.tf removeFromSuperview];
                }
                else if (indexPath.section == 1 && indexPath.row == 1)
                {
                    cell.label.text = @"上传行驶证照片";
                    cell.tag = 1001;
                    [cell.tf removeFromSuperview];
                }
                else if (indexPath.section == 1 && indexPath.row == 2)
                {
                    cell.label.text = @"上传保单照片";
                    cell.tag = 1002;
                    [cell.tf removeFromSuperview];                }
        }
         return cell;
    }
   
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cha
{
    UIView *view = [self.view viewWithTag:100];
    [view removeFromSuperview];
}

- (void)over1
{
    if ([Ultitly shareInstance].holder != nil)
    {
        if ([Ultitly shareInstance].date != nil)
        {
            NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
            [parameterDic setObject:@"2333" forKey:@"locid"];
            [parameterDic setObject:[Ultitly shareInstance].mobile forKey:@"mobile"];
            [parameterDic setObject:[Ultitly shareInstance].realname forKey:@"realname"];
            [parameterDic setObject:[Ultitly shareInstance].idcard forKey:@"idcard"];
            [parameterDic setObject:@"123" forKey:@"carid"];
            [parameterDic setObject:[Ultitly shareInstance].holder forKey:@"holder"];
            [parameterDic setObject:[Ultitly shareInstance].date forKey:@"date"];
            [parameterDic setObject:[Ultitly shareInstance].driver_a forKey:@"driver_a"];
            [parameterDic setObject:[Ultitly shareInstance].driver_b forKey:@"driver_b"];
            [parameterDic setObject:[Ultitly shareInstance].travel_a forKey:@"travel_a"];
            [parameterDic setObject:[Ultitly shareInstance].travel_b forKey:@"travel_b"];
            [parameterDic setObject:[Ultitly shareInstance].policy forKey:@"policy"];
            [parameterDic setObject:@"laowang" forKey:@"prophet"];
            [parameterDic setObject:[Ultitly shareInstance].protrait forKey:@"protrait"];
            
            [[NetManager shareManager]requestUrlPost:RegisterAPI andParameter:parameterDic withSuccessBlock:^(id data)
            {
                if ([data[@"status"]isEqualToString:@"9000"])
                {
                    NSLog(@"%@",data);
                    ResOverViewController *OVC = [[ResOverViewController alloc]init];
                    [self.navigationController pushViewController:OVC animated:YES];
                }
                else if ([data[@"status"]isEqualToString:@"0000"])
                {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器响应失败,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alertC addAction:action];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
                else if ([data[@"status"]isEqualToString:@"1000"])
                {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alertC addAction:action];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
                else if ([data[@"status"]isEqualToString:@"2000"])
                {
                    [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:data[@"msg"]];
                    
//                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2];
                }
            }
            andFailedBlock:^(NSError *error)
            {
                NSLog(@"%@",error);
            }];
        }
        else
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入车辆注册日期" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入车辆所有人姓名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        PostDrivingLicenceViewController *PDVC = [[PostDrivingLicenceViewController alloc]init];
        [self.navigationController pushViewController:PDVC animated:YES];
        PDVC.block = ^(NSString * str)
        {
            ResTableViewCell *cell = [self.myTableV viewWithTag:1000];
            cell.imageV.frame = CGRectMake(SCREENW - 33*SCREENW_RATE, 20*SCREENW_RATE, 16*SCREENW_RATE, 11*SCREENW_RATE);
            cell.imageV.image = [UIImage imageNamed:str];
        };
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        
        WalkLienceViewController *WLVC = [[WalkLienceViewController alloc]init];
        [self.navigationController pushViewController:WLVC animated:YES];
        WLVC.block = ^(NSString *str)
        {
            ResTableViewCell *cell = [self.myTableV viewWithTag:1001];
            cell.imageV.frame = CGRectMake(SCREENW - 33*SCREENW_RATE, 20*SCREENW_RATE, 16*SCREENW_RATE, 11*SCREENW_RATE);
            cell.imageV.image = [UIImage imageNamed:str];
        };
        
    }else if (indexPath.section == 1 && indexPath.row == 2)
    {
        PostGuaranteeViewController *PGVC = [[PostGuaranteeViewController alloc]init];
        [self.navigationController pushViewController:PGVC animated:YES];
        PGVC.block = ^(NSString *str)
        {
            ResTableViewCell *cell = [self.myTableV viewWithTag:1002];
            cell.imageV.frame = CGRectMake(SCREENW - 33*SCREENW_RATE, 20*SCREENW_RATE, 16*SCREENW_RATE, 11*SCREENW_RATE);
            cell.imageV.image = [UIImage imageNamed:str];
        };
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 320*SCREENW_RATE, SCREENW, 400*SCREENW_RATE)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
         [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        [_datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_datePicker];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 340*SCREENW_RATE, 60*SCREENW_RATE, 50*SCREENW_RATE);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:btn aboveSubview:_datePicker];
    }
}

- (void)changeDate
{
    NSDateFormatter *outPutFormatter = [[NSDateFormatter alloc]init];
    [outPutFormatter setDateFormat:@"yyyy - MM - dd"];
    NSString *str = [outPutFormatter stringFromDate:self.datePicker.date];
    ResTableViewCell *cell = [self.myTableV viewWithTag:999];
    cell.tf.text = str;
    [Ultitly shareInstance].date = str;
    
}

- (void)sure:(UIButton *)sureBtn
{
    [self changeDate];
    [sureBtn removeFromSuperview];
    [self.datePicker removeFromSuperview];
}

- (void)delayMethod
{
    ResOverViewController *OVC = [[ResOverViewController alloc]init];
    [self.navigationController pushViewController:OVC animated:YES];
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
