//
//  PersonInfoViewController.m
//  Car Odyssey
//
//  Created by 王澄宇 on 16/10/17.
//  Copyright © 2016年 Henry. All rights reserved.
// 性别: 1:女 2:男

#import "PersonInfoViewController.h"
#import "NetManager.h"
#import "Ultitly.h"
#import <UIImageView+WebCache.h>
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW_RATE SCREENW/375
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define postImageAPI @"http://115.29.246.88:9999/common/upload"
#define personUpdateAPI @"http://115.29.246.88:9999/center/update"
@interface PersonInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    UIImageView *imageV;
    UILabel *cityLabel;
    NSDictionary *areaDic;
    BOOL ChooseCity;
    BOOL ChooseSex;
}
@property (nonatomic,strong)UIImagePickerController *pickerC;
@property (nonatomic,strong)NSArray *provinceArray;
@property (nonatomic,strong)UIPickerView *pickView;
@property (nonatomic,copy)NSString *urlStr;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createProvinceDataSource];
    [self configNav];
    [self configUI];
    
}

- (void)createProvinceDataSource
{
    _provinceArray = @[@"北京",@"天津",@"上海",@"重庆",@"河北省",@"河南省",@"云南省",@"辽宁省",@"黑龙江省",@"湖南省",@"安徽省",@"山东省",@"新疆维吾尔自治区",@"江苏省",@"浙江省",@"江西省",@"湖北省",@"广西壮族自治区",@"甘肃省",@"山西省",@"内蒙古",@"陕西省",@"吉林省",@"福建省",@"贵州省",@"广东省",@"青海省",@"西藏自治区",@"四川省",@"宁夏回族自治区",@"海南省",@"台湾省",@"香港特别行政区",@"澳门特别行政区",@"海外"];
    
    //各省标识
    areaDic = @{@"北京":@"1",@"天津":@"2",@"河北省":@"3",@"山西省":@"4",@"内蒙古自治区":@"5",@"辽宁省":@"6",@"吉林省":@"7",@"黑龙江省":@"8",@"上海":@"9",@"江苏省":@"10",@"浙江省":@"11",@"安徽省":@"12",@"福建省":@"13",@"江西省":@"14",@"山东省":@"15",@"河南省":@"16",@"湖北省":@"17",@"湖南省":@"18",@"广东省":@"19",@"广西壮族自治区":@"20",@"海南省":@"21",@"重庆":@"22",@"四川省":@"23",@"贵州省":@"24",@"云南省":@"25",@"西藏自治区":@"26",@"陕西省":@"27",@"甘肃省":@"28",@"青海省":@"29",@"宁夏回族自治区":@"30",@"新疆维吾尔自治区":@"31",@"台湾省":@"32",@"香港特别行政区":@"33",@"澳门特别行政区":@"34"};
    
}

- (void)configNav
{
    self.view.backgroundColor = RGB(238, 238, 238);
    self.navigationController.navigationBar.barTintColor = RGB(37, 155, 255);
    self.navigationItem.title = @"个人信息中心";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:RGB(255, 255, 255)}];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 21*SCREENW_RATE, 15*SCREENW_RATE);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB(255, 255, 255)} forState:UIControlStateNormal];
    
}

- (void)configUI
{
    ChooseCity = NO;
    ChooseSex = NO;
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 64*SCREENW_RATE, SCREENW, 90*SCREENW_RATE)];
    headV.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SCREENW_RATE, 0, 70*SCREENW_RATE, 90*SCREENW_RATE)];
    label.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
    label.textColor = RGB(51, 51, 51);
    label.text = @"用户头像";
    [headV addSubview:label];
    [self.view addSubview:headV];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *portraitStr = [ud objectForKey:@"headportrait"];
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 59*SCREENW_RATE, 59*SCREENW_RATE)];
    imageV.center = CGPointMake(SCREENW - 70*SCREENW_RATE, CGRectGetMidY(headV.frame));
    imageV.layer.cornerRadius = 28.0f*SCREENW_RATE;
    imageV.layer.masksToBounds = YES;
    [imageV sd_setImageWithURL:[NSURL URLWithString:portraitStr]];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto)];
    [imageV addGestureRecognizer:photoTap];
    [self.view addSubview:imageV];
    
    UIImageView *cameraV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)-18*SCREENW_RATE, CGRectGetMaxY(imageV.frame)-18*SCREENW_RATE, 18*SCREENW_RATE, 18*SCREENW_RATE)];
    cameraV.image = [UIImage imageNamed:@"huantouxinag0"];
    [self.view addSubview:cameraV];
    
    UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10*SCREENW_RATE, 18*SCREENW_RATE)];
    arrowV.center = CGPointMake(CGRectGetMaxX(imageV.frame)+16*SCREENW_RATE,CGRectGetMidY(headV.frame));
    arrowV.image = [UIImage imageNamed:@"arrow_right"];
    [self.view addSubview:arrowV];
    
    NSArray *titleArr = @[@"姓名",@"城市",@"性别",@"年龄"];
    for (int i = 0; i < 4; i ++)
    {
        UILabel *infoL = [[UILabel alloc]initWithFrame:CGRectMake(0, ((CGRectGetMaxY(headV.frame)+10)+ i*50)*SCREENW_RATE, SCREENW, 50*SCREENW_RATE)];
        infoL.backgroundColor = [UIColor whiteColor];
        infoL.textColor = RGB(51, 51, 51);
        infoL.layer.borderColor = RGB(238, 238, 238).CGColor;
        infoL.layer.borderWidth = 0.5f;
        infoL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
        infoL.userInteractionEnabled = YES;
        infoL.text = [NSString stringWithFormat:@"   %@",titleArr[i]];
        [self.view addSubview:infoL];
        if (i == 0)
        {
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *personName = [ud objectForKey:@"name"];
            UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 125*SCREENW_RATE, infoL.frame.origin.y+1, 110*SCREENW_RATE, 48*SCREENW_RATE)];
            nameL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            nameL.textColor = RGB(51, 51, 51);
            nameL.text = personName;
            nameL.textAlignment = NSTextAlignmentRight;
            [self.view insertSubview:nameL aboveSubview:infoL];
            
        }
        else if (i == 1)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *personCity = [ud objectForKey:@"city"];
            cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 125*SCREENW_RATE, infoL.frame.origin.y+1, 110*SCREENW_RATE, 48*SCREENW_RATE)];
            cityLabel.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            cityLabel.backgroundColor = [UIColor whiteColor];
            cityLabel.textColor = RGB(51, 51, 51);
            cityLabel.text = [self valueForkey:[NSString stringWithFormat:@"%@",personCity] andWithDic:areaDic];
            cityLabel.textAlignment = NSTextAlignmentRight;
            cityLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *cityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCity)];
            [cityLabel addGestureRecognizer:cityTap];
            [self.view insertSubview:cityLabel aboveSubview:infoL];
        }
        else if (i == 2)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *gender = [NSString stringWithFormat:@"%@",[ud objectForKey:@"gender"]];
            UILabel *sexL = [[UILabel alloc]initWithFrame:CGRectMake(SCREENW - 95*SCREENW_RATE, infoL.frame.origin.y+1*SCREENW_RATE, 83*SCREENW_RATE, 48*SCREENW_RATE)];
            sexL.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            sexL.backgroundColor = [UIColor whiteColor];
            sexL.textAlignment = NSTextAlignmentRight;
            sexL.tag = 200;
            if ([gender isEqualToString:@"1"])
            {
                sexL.text = @"女生";
            }
            else if ([gender isEqualToString:@"2"])
            {
                sexL.text = @"男生";
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSex)];
            [infoL addGestureRecognizer:tap];
            [self.view insertSubview:sexL aboveSubview:infoL];
        }
        else if (i == 3)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *driverAge = [ud objectForKey:@"age"];
            UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREENW - 105*SCREENW_RATE, infoL.frame.origin.y+1*SCREENW_RATE, 95*SCREENW_RATE, 48*SCREENW_RATE)];
            tf.text = driverAge;
            tf.delegate = self;
            tf.tag = 203;
            tf.font = [UIFont systemFontOfSize:16*SCREENW_RATE];
            tf.backgroundColor = [UIColor whiteColor];
            [tf setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"请输入年龄" attributes:@{NSForegroundColorAttributeName:RGB(206, 206, 206)}]];
            tf.clearsOnBeginEditing = YES;
            tf.textAlignment = NSTextAlignmentRight;
            [tf addTarget:self action:@selector(changeAge:) forControlEvents:UIControlEventValueChanged];
            [self.view insertSubview:tf aboveSubview:infoL];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    NSString *areaValue = [areaDic objectForKey:cityLabel.text];
    NSLog(@"%@",areaValue);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userid = [ud objectForKey:@"userid"];
    UILabel *label = [self.view viewWithTag:200];
    UITextField *tf = [self.view viewWithTag:203];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"id"];
    [paraDic setObject:areaValue forKey:@"locid"];
    if ([Ultitly shareInstance].protrait != nil)
    {
         [paraDic setObject:[Ultitly shareInstance].protrait forKey:@"portrait"];
    }
    if ([label.text isEqualToString:@"女生"])
    {
        [paraDic setObject:@"1" forKey:@"gender"];
    }
    else if ([label.text isEqualToString:@"男生"])
    {
        [paraDic setObject:@"2" forKey:@"gender"];
    }
    [paraDic setObject:tf.text forKey:@"age"];
    
    [[NetManager shareManager]requestUrlPost:personUpdateAPI andParameter: paraDic withSuccessBlock:^(id data)
    {
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if (_urlStr != nil)
            {
                [ud setObject:_urlStr forKey:@"headportrait"];
            }
            if ([label.text isEqualToString:@"女生"])
            {
                [ud setObject:@"1" forKey:@"gender"];
            }
            else if ([label.text isEqualToString:@"男生"])
            {
                [ud setObject:@"2" forKey:@"gender"];
            }
            [ud setObject:tf.text forKey:@"age"];
            [ud setObject:areaValue forKey:@"city"];
            [[Ultitly shareInstance]showMBProgressHUD:self.view withShowStr:@"个人信息修改成功"];
            
        }
        else if ([data[@"status"]isEqualToString:@"1000"])
        {
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

- (void)chooseSex
{
    if (ChooseCity == NO)
    {
        ChooseSex = YES;
        [UIView animateWithDuration:0.5f animations:^{
            UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150*SCREENW_RATE, 100*SCREENW_RATE)];
            sexView.tag = 201;
            sexView.center = CGPointMake(SCREENW/2, SCREENH/2+130*SCREENW_RATE);
            sexView.layer.cornerRadius = 5.0f;
            sexView.layer.masksToBounds = YES;
            sexView.layer.borderColor = RGB(238, 238, 238).CGColor;
            sexView.layer.borderWidth = 0.5f;
            sexView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:sexView];
            
            UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            boyBtn.frame = CGRectMake(0, 3, 150*SCREENW_RATE, 47*SCREENW_RATE);
            [boyBtn setTitle:@"男生" forState:UIControlStateNormal];
            [boyBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
            [boyBtn addTarget:self action:@selector(boy) forControlEvents:UIControlEventTouchUpInside];
            [sexView addSubview:boyBtn];
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(boyBtn.frame), sexView.bounds.size.width, 1)];
            lineV.backgroundColor = RGB(238, 238, 238);
            [sexView addSubview:lineV];
            
            UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            girlBtn.frame = CGRectMake(0, CGRectGetMaxY(lineV.frame), sexView.bounds.size.width, 48*SCREENW_RATE);
            [girlBtn setTitleColor:RGB(37, 155, 255) forState:UIControlStateNormal];
            [girlBtn addTarget:self action:@selector(girl) forControlEvents:UIControlEventTouchUpInside];
            [girlBtn setTitle:@"女生" forState:UIControlStateNormal];
            [sexView addSubview:girlBtn];
        }];
    }
  
}

- (void)boy
{
    ChooseSex = NO;
    UILabel *boyL = [self.view viewWithTag:200];
    UIView *view = [self.view viewWithTag:201];
    boyL.text = @"男生";
    boyL.textAlignment = NSTextAlignmentRight;
    boyL.textColor = RGB(51, 51, 51);
    [view removeFromSuperview];
}

- (void)girl
{
    ChooseSex = NO;
    UILabel *girlL = [self.view viewWithTag:200];
    UIView *view = [self.view viewWithTag:201];
    girlL.text = @"女生";
    girlL.textAlignment = NSTextAlignmentRight;
    girlL.textColor = RGB(51, 51, 51);
    [view removeFromSuperview];
}

- (void)choosePhoto
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

- (void)changeAge:(UITextField *)textfield
{
    if (textfield.text.length == 0)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *gender = [NSString stringWithFormat:@"%@",[ud objectForKey:@"gender"]];
        if ([gender isEqualToString:@"1"])
        {
            textfield.text = @"女生";
        }
        else if ([gender isEqualToString:@"2"])
        {
            textfield.text = @"男生";
        }
    }
}

- (NSString *)valueForkey:(NSString *)value andWithDic:(NSDictionary *)dic
{
    for (NSString *key in dic)
    {
        if ([value isEqualToString:[dic objectForKey:key]])
        {
            return key;
        }
    }
    return nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    imageV.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NetManager shareManager]requestUrlPostImage:postImageAPI andParameter:nil withImageData:imageData withSuccessBlock:^(id data)
    {
        if ([data[@"status"]isEqualToString:@"9000"])
        {
            NSLog(@"%@",data);
            [Ultitly shareInstance].protrait = data[@"data"][@"path"];
            _urlStr = data[@"data"][@"url"];
        }
        else if ([data[@"status"]isEqualToString:@"1000"])
        {
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

- (UIPickerView *)pickerView
{
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 348*SCREENW_RATE, SCREENW, 367*SCREENW_RATE)];
    _pickView.tag = 1000;
    _pickView.delegate = self;
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.userInteractionEnabled = YES;
    _pickView.showsSelectionIndicator = NO;
    return _pickView;
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
    ChooseCity = NO;
    cityLabel.userInteractionEnabled = YES;
    NSInteger result = [_pickView selectedRowInComponent:0];
    cityLabel.text = [NSString stringWithFormat:@"%@",self.provinceArray[result]];
    [_pickView removeFromSuperview];
    [sureBtn removeFromSuperview];
}

- (void)selectCity
{
    if (ChooseSex == NO)
    {
        [self.view addSubview:[self pickerView]];
        [self.view insertSubview:[self btn] aboveSubview:_pickView];
        cityLabel.userInteractionEnabled = NO;
        ChooseCity = YES;
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
