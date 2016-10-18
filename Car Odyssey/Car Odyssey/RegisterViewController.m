//
//  RegisterViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/19.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "RegisterViewController.h"
#import "CarRegisViewController.h"
#import "ExplainViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define testAPI @"http://139.196.179.91/carmanl/public/account/regcode"
#define joinAPI @"http://139.196.179.91/carmanl/public/account/codecheck"


@interface RegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *kongjianArr;
    UIButton *getNumBtn;
}
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UILabel *addressL;
@property (nonatomic,strong)UILabel *textL;
@property (nonatomic,assign)BOOL isAddInvite;
@property (nonatomic,strong)UITextField *scanfTF;
@property (nonatomic,strong)UITextField *telNumTF;
@property (nonatomic,strong)UITextField *testTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self createProvinceDataSource];
    [self configNav];
    [self configUI];
    
}

- (void)createProvinceDataSource
{
    _provinceArray = @[@"北京市",@"天津市",@"上海市",@"重庆市",@"河北省",@"河南省",@"云南省",@"辽宁省",@"黑龙江省",@"湖南省",@"安徽省",@"山东省",@"新疆维吾尔自治区",@"江苏省",@"浙江省",@"江西省",@"湖北省",@"广西省",@"甘肃省",@"山西省",@"内蒙古",@"陕西省",@"吉林省",@"福建省",@"贵州省",@"广东省",@"青海省",@"西藏",@"四川省",@"宁夏回族",@"海南省",@"台湾省",@"香港特别行政区",@"澳门特别行政区"];
}

- (void)configNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"加入车漫行";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)configUI
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREENW, 160*SCREENW_RATE)];
    imageV.image = [UIImage imageNamed:@"zc_banner@2x"];
    [self.view addSubview:imageV];
    
    _textL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(imageV.frame)+5*SCREENW_RATE, 140*SCREENW_RATE, 56*SCREENW_RATE)];
    _textL.text = @"注册车漫行车主";
    if (SCREENW >= 375)
    {
        _textL.font = [UIFont systemFontOfSize:17];

    }else
    {
        _textL.font = [UIFont systemFontOfSize:15];
    }
        _textL.textColor = RGB(51, 51, 51);
    [self.view addSubview:_textL];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteBtn.frame = CGRectMake(SCREENW - 130*SCREENW_RATE, CGRectGetMaxY(imageV.frame)+5*SCREENW_RATE, 125*SCREENW_RATE, 56*SCREENW_RATE);
    [inviteBtn setTitle:@"  添加邀请码" forState:UIControlStateNormal];
    inviteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [inviteBtn setTitleColor:RGB(68, 156, 255) forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(addInvite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteBtn];
    
    _addressL = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(_textL.frame), 345*SCREENW_RATE, 50*SCREENW_RATE)];
    _addressL.backgroundColor = [UIColor whiteColor];
    _addressL.text = @"     上海";
    _addressL.font = [UIFont systemFontOfSize:16];
    _addressL.textColor = RGB(51, 51, 51);
    _addressL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCity)];
    [_addressL addGestureRecognizer:tap];
    [self.view addSubview:_addressL];
    
    UIImageView *arrowDownM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 9*SCREENW_RATE, 5*SCREENW_RATE)];
    arrowDownM.center = CGPointMake(CGRectGetMaxX(_addressL.frame)-26*SCREENW_RATE, CGRectGetMidY(_addressL.frame));
    arrowDownM.image = [UIImage imageNamed:@"arrow_down0@2x"];
    [self.view insertSubview:arrowDownM aboveSubview:_addressL];
    
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(CGRectGetMaxX(_addressL.frame)-40*SCREENW_RATE, _addressL.frame.origin.y*+23.5*SCREENW_RATE, 9*SCREENW_RATE, 5*SCREENW_RATE);
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"arrow_down1@2x"] forState:UIControlStateNormal];
    [self.view addSubview:arrowBtn];
    
    _telNumTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(_addressL.frame)+14.5*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    _telNumTF.backgroundColor = [UIColor whiteColor];
    [_telNumTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    _telNumTF.clearsOnBeginEditing = YES;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
    paddingView.backgroundColor = [UIColor whiteColor];
    _telNumTF.leftView = paddingView;
    _telNumTF.leftViewMode = UITextFieldViewModeAlways;
    _telNumTF.font = [UIFont systemFontOfSize:16];
    //添加获取按钮
    getNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getNumBtn.frame = CGRectMake(SCREENW - 115*SCREENW_RATE, _telNumTF.frame.origin.y, 100*SCREENW_RATE, 50*SCREENW_RATE);
    getNumBtn.backgroundColor = RGB(37, 155, 255);
    [getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getNumBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    getNumBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [getNumBtn addTarget:self action:@selector(getTestNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_telNumTF];
    [self.view addSubview:getNumBtn];
    
    _testTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(_telNumTF.frame)+1*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    _testTF.backgroundColor = [UIColor whiteColor];
    [_testTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    _testTF.clearsOnBeginEditing = YES;
    UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 15*SCREENW_RATE)];
    paddingView1.backgroundColor = [UIColor whiteColor];
    _testTF.leftView = paddingView1;
    _testTF.leftViewMode = UITextFieldViewModeAlways;
    _testTF.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_testTF];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(_testTF.frame)+13.5*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE);
    joinBtn.backgroundColor = RGB(37, 155, 255);
    [joinBtn setTitle:@"加入车漫行" forState:UIControlStateNormal];
    [joinBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [joinBtn addTarget:self action:@selector(joinCarWalk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    
    NSString *contentStr = @"注册即代表我们同意隐私政策, 并理解车漫行是一个叫车";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    UILabel *infoL = [[UILabel alloc]initWithFrame:CGRectMake(25*SCREENW_RATE, CGRectGetMaxY(joinBtn.frame)+80*SCREENW_RATE, 331*SCREENW_RATE, 20*SCREENW_RATE)];
    if (SCREENW >= 375)
    {
        infoL.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        infoL.font = [UIFont systemFontOfSize:11];
    }
    infoL.textColor = RGB(136, 136, 136);
    infoL.userInteractionEnabled = YES;
    UITapGestureRecognizer *privacyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(privacy)];
    [infoL addGestureRecognizer:privacyTap];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(37, 155, 255) range:NSMakeRange(9,4)];
    [infoL setAttributedText:str];
    [self.view addSubview:infoL];
    
    UILabel *infoL1 = [[UILabel alloc]initWithFrame:CGRectMake(37*SCREENW_RATE, CGRectGetMaxY(infoL.frame), 301*SCREENW_RATE, 20*SCREENW_RATE)];
    if (SCREENW >= 375)
    {
        infoL1.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        infoL1.font = [UIFont systemFontOfSize:11];
    }
    infoL1.textColor = RGB(136, 136, 136);
    infoL1.text = @"工具,并非交通运输承运人";
    infoL1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoL1];
    _isAddInvite = NO;
    kongjianArr  = @[_addressL,_telNumTF,_testTF,joinBtn,getNumBtn];
    
}

- (void)goBack
{
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)addInvite
{
    if (_isAddInvite == NO)
    {
        _scanfTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(_textL.frame)+14.5*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
        _scanfTF.backgroundColor = [UIColor whiteColor];
        _scanfTF.clearsOnBeginEditing = YES;
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
        paddingView.backgroundColor = [UIColor whiteColor];
        _scanfTF.leftView = paddingView;
        _scanfTF.leftViewMode = UITextFieldViewModeAlways;
        _scanfTF.font = [UIFont systemFontOfSize:16];
       [_scanfTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"邀请码或者邀请人电话号码" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
        [self.view addSubview:_scanfTF];
        [self changeFrameAdd:kongjianArr];
        _isAddInvite = YES;
      }
    else
    {
        [_scanfTF removeFromSuperview];
        [self changeFrameDes:kongjianArr];
        _isAddInvite = NO;
    }
}

- (void)getTestNum
{
    if (_telNumTF.text.length == 0)
    {
        [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"请输入手机号码"];
    }
    else
    {
        NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
        [parameterDic setObject:_telNumTF.text forKey:@"mobile"];
        NSLog(@"parameterDic = %@",parameterDic);
        
        [[NetManager shareManager]requestUrlPost:testAPI andParameter:parameterDic withSuccessBlock:^(id data)
         {
             NSLog(@"%@",data);
         }
            andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
        __block NSInteger time = 59; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    getNumBtn.backgroundColor = RGB(37, 155, 255);
                    [getNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    getNumBtn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = time % 2333;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置按钮显示读秒效果
                    getNumBtn.backgroundColor = RGB(204, 204, 204);
                    [getNumBtn setTitle:[NSString stringWithFormat:@"%d 秒",seconds] forState:UIControlStateNormal];
                    getNumBtn.userInteractionEnabled = NO;
                });
                time--;
            }
        });
        dispatch_resume(_timer);
    }
    
}

- (UIPickerView *)pickerView
{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 348*SCREENW_RATE, SCREENW, 367*SCREENW_RATE)];
    _pickerView.tag = 1000;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.userInteractionEnabled = YES;
    _pickerView.showsSelectionIndicator = NO;
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provinceArray.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 150;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 60;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provinceArray[row];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSLog(@"%@",self.provinceArray[row]);
        [pickerView selectedRowInComponent:0];
    }
}

- (UIButton *)btn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 360*SCREENW_RATE, 60*SCREENW_RATE, 50*SCREENW_RATE);
    [btn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    return btn;
}

- (void)sure:(UIButton *)sureBtn
{
    NSInteger result = [_pickerView selectedRowInComponent:0];
    _addressL.text = [NSString stringWithFormat:@"   %@",self.provinceArray[result]];
    [_pickerView removeFromSuperview];
    [sureBtn removeFromSuperview];
}

- (void)selectCity
{
    [self.view addSubview:[self pickerView]];
    [self.view insertSubview:[self btn] aboveSubview:_pickerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGB(255, 255, 255)}];
}

- (void)changeFrameAdd:(NSArray *)arr
{
    for (UIView *view in arr) {
        CGRect frame = view.frame;
        frame.origin.y += 65.5;
        view.frame = frame;
    }
}

- (void)changeFrameDes:(NSArray *)arr
{
    for (UIView *view in arr) {
        CGRect frame = view.frame;
        frame.origin.y -= 65.5;
        view.frame = frame;
    }
}

- (void)joinCarWalk
{
    if (_testTF.text.length == NO)
    {
        [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"请输入验证码"];
    }else
    {
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:_telNumTF.text forKey:@"mobile"];
        [[NetManager shareManager]requestUrlPost:joinAPI andParameter:paraDic withSuccessBlock:^(id data)
         {
             NSLog(@"%@",data);
             if ([data[@"status"]isEqualToString:@"9000"])
             {
                 [Ultitly shareInstance].mobile = _telNumTF.text;
                 CarRegisViewController *CarVC = [[CarRegisViewController alloc]init];
                 [self.navigationController pushViewController:CarVC animated:YES];
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
                 [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2];
             }
             
         }
                                  andFailedBlock:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
    
    
}

- (void)privacy
{
    ExplainViewController *explainVC = [[ExplainViewController alloc]init];
    NSString *titleStr = @"隐私政策";
    NSString *APIStr = @"http://139.196.179.91/carmanl/public/account/privacy";
    explainVC.titleStr = titleStr;
    explainVC.APIStr = APIStr;
    [self.navigationController pushViewController:explainVC animated:YES];
}

- (void)delayMethod
{
    [Ultitly shareInstance].mobile = _telNumTF.text;
    CarRegisViewController *CarVC = [[CarRegisViewController alloc]init];
    [self.navigationController pushViewController:CarVC animated:YES];
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
