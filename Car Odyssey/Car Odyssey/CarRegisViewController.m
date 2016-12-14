//
//  CarRegisViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/9/21.
//  Copyright © 2016年 Henry. All rights reserved.
//

#import "CarRegisViewController.h"
#import "CarIDRegisViewController.h"
#import "Ultitly.h"
#import "NetManager.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
//#define postImageAPI @"http://115.29.246.88:9999/common/upload"
#define postImageAPI @"http://172.16.3.127/app/portal.htm/app/upload.htm"
@interface CarRegisViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField *tureNameTF;
    UITextField *tureNameIDTF;
    UITextField *carIDTF;
    UIImageView *headImage;
}
@property (nonatomic,strong)UILabel *cityL;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)UIPickerView *pickerView;

@end

@implementation CarRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createProvinceDataSource];
    [self configNav];
    [self configUI];
    self.view.backgroundColor = RGB(238, 238, 238);
}

- (void)createProvinceDataSource
{
    _provinceArray = @[@"京",@"津",@"沪",@"渝",@"冀",@"豫",@"云",@"辽",@"黑",@"湘",@"徽",@"鲁",@"新",@"苏",@"浙",@"赣",@"鄂",@"桂",@"甘",@"晋",@"蒙",@"陕",@"吉",@"闽",@"贵",@"粤",@"青",@"藏",@"川",@"宁",@"琼"];
}

- (void)configNav
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 56*SCREENW_RATE, 20*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"chemanxingx2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(135, 135, 135)} forState:UIControlStateNormal];
}

- (void)configUI
{
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180*SCREENW_RATE, 60.5*SCREENW_RATE)];
    textL.center = CGPointMake(187.5*SCREENW_RATE, 133*SCREENW_RATE);
    textL.text = @"请提供您的真实信息";
    if (SCREENW >= 375) {
        textL.font = [UIFont systemFontOfSize:18];
    }
    else
    {
        textL.font = [UIFont systemFontOfSize:16];
    }
    textL.textColor = RGB(51, 51, 51);
    [self.view addSubview:textL];
    
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59*SCREENW_RATE, 59*SCREENW_RATE)];
    headImage.center = CGPointMake(187.5*SCREENW_RATE, 192*SCREENW_RATE);
    headImage.image = [UIImage imageNamed:@"zc_touxiang"];
    headImage.userInteractionEnabled = NO;
    [self.view addSubview:headImage];
    
    tureNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(headImage.frame)+31*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    tureNameTF.backgroundColor = [UIColor whiteColor];
    tureNameTF.clearsOnBeginEditing = YES;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
    [tureNameTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"真实姓名" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    paddingView.backgroundColor = [UIColor whiteColor];
    tureNameTF.leftView = paddingView;
    tureNameTF.leftViewMode = UITextFieldViewModeAlways;
    tureNameTF.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:tureNameTF];
    
    tureNameIDTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(tureNameTF.frame)+1*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    tureNameIDTF.backgroundColor = [UIColor whiteColor];
    [tureNameIDTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"身份证号" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    tureNameIDTF.clearsOnBeginEditing = YES;
    UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23*SCREENW_RATE, 13*SCREENW_RATE)];
    paddingView1.backgroundColor = [UIColor whiteColor];
    tureNameIDTF.leftView = paddingView1;
    tureNameIDTF.leftViewMode = UITextFieldViewModeAlways;
    tureNameIDTF.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:tureNameIDTF];
    
    UIImageView *carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 134.5*SCREENW_RATE, 45.5*SCREENW_RATE)];
    carImage.center  = CGPointMake(187.5*SCREENW_RATE, CGRectGetMaxY(tureNameIDTF.frame) + 55*SCREENW_RATE);
    carImage.image = [UIImage imageNamed:@"car0"];
    [self.view addSubview:carImage];
    
    carIDTF = [[UITextField alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(carImage.frame)+22*SCREENW_RATE, 345*SCREENW_RATE, 50*SCREENW_RATE)];
    carIDTF.backgroundColor = [UIColor whiteColor];
    [carIDTF setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"6位车牌号" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
    carIDTF.font = [UIFont systemFontOfSize:16];
    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65*SCREENW_RATE, 50*SCREENW_RATE)];
    _cityL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15*SCREENW_RATE, 10*SCREENW_RATE)];
    _cityL.center = CGPointMake(28*SCREENW_RATE, 25*SCREENW_RATE);
    _cityL.text = @"沪";
    _cityL.userInteractionEnabled  = YES;
    _cityL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choose)];
    [_cityL addGestureRecognizer:tap];
    [paddingView2 addSubview:_cityL];
    
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn.frame = CGRectMake(0, 0, 9*SCREENW_RATE, 5*SCREENW_RATE) ;
    arrowBtn.center = CGPointMake(50*SCREENW_RATE, 25*SCREENW_RATE);
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"arrow_down0"] forState:UIControlStateNormal];
    [carIDTF addSubview:arrowBtn];
    carIDTF.leftView = paddingView2;
    carIDTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:carIDTF];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(15*SCREENW_RATE, CGRectGetMaxY(carIDTF.frame)+25, 345*SCREENW_RATE, 50*SCREENW_RATE);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:RGB(37, 155, 255)];
    [nextBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [nextBtn addTarget:self action:@selector(goNext1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

- (void)pick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片获取方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])return;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)back1
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goNext1
{
        if (tureNameTF.text.length != 0)
        {
            if (carIDTF.text.length == 6 && (tureNameIDTF.text.length == 15 || tureNameIDTF.text.length == 18))
            {
                [Ultitly shareInstance].idcard = tureNameIDTF.text;
                [Ultitly shareInstance].license = carIDTF.text;
                [Ultitly shareInstance].realname = tureNameTF.text;
                CarIDRegisViewController *CarIDVC = [[CarIDRegisViewController alloc]init];
                [self.navigationController pushViewController:CarIDVC animated:YES];
            }else
            {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证或者车牌号码输入位数有误, 请检查" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
                [alertC addAction:cancel];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }
        else
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您的真实姓名" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            [alertC addAction:cancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
      
    

    
}

- (void)choose
{
    [self.view addSubview:[self pickerView]];
    [self.view insertSubview:[self btn] aboveSubview:_pickerView];
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

- (void)sure:(UIButton *)sureBtn
{
    NSInteger result = [_pickerView selectedRowInComponent:0];
    _cityL.text = [NSString stringWithFormat:@"%@",self.provinceArray[result]];
    _cityL.font = [UIFont systemFontOfSize:16];
    [_pickerView removeFromSuperview];
    [sureBtn removeFromSuperview];
}

- (UIButton *)btn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 360*SCREENW_RATE, 60*SCREENW_RATE, 50*SCREENW_RATE);
    [btn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    return btn;
}

- (void)delayMethod
{
   

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
