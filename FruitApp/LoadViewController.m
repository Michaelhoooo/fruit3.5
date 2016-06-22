//
//  LoadViewController.m
//  FruitApp
//
//  Created by mac on 16/3/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoadViewController.h"
#import "User.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define zhuceUrl @"http://115.28.55.133:8000/jsonregister"
#define dengluUrl @"http://115.28.55.133:8000/jsonlogin"
#define name @"username="
#define pass @"&password="

@interface LoadViewController ()<UIAlertViewDelegate>

@property UILabel *lab;
@property UIView *v;
@property NSMutableArray *userArrM;

@property NSTimer *timer;

@end

@implementation LoadViewController
{
    UITextField *nameTextF;
    UITextField *passWordTextF;
    
}

#pragma mark 建立view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUser];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录／注册";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];

    [self addView];//建立界面
}

#pragma mark 加载所有用户
- (void)loadUser
{
    _userArrM = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _userArrM =[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        //[NSKeyedArchiver    archiveRootObject:_array1 toFile:pat];
    }
}

#pragma mark 点击空白处
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark 返回个人中心
- (void)fanhui
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 创建界面
- (void)addView
{
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 60, 44)];
    nameLab.text = @"用户名:";
    [self.view addSubview:nameLab];
    
    UILabel *passLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 174, 60, 44)];
    passLab.text = @"密码:";
    [self.view addSubview:passLab];
    
    nameTextF = [[UITextField alloc]initWithFrame:CGRectMake(90, 110, ScreenW-100, 44)];
    [self.view addSubview:nameTextF];
    nameTextF.borderStyle = UITextBorderStyleRoundedRect;
    nameTextF.placeholder = @"请输入用户名";
    nameTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    passWordTextF = [[UITextField alloc]initWithFrame:CGRectMake(90, 174, ScreenW-100, 44)];
    [self.view addSubview:passWordTextF];
    passWordTextF.borderStyle = UITextBorderStyleRoundedRect;
    passWordTextF.placeholder = @"请输入密码";
    passWordTextF.secureTextEntry = YES;
    passWordTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *denglu = [[UIButton alloc]initWithFrame:CGRectMake(60, 250, 60, 44)];
    [self.view addSubview: denglu];
    [denglu setTitle:@"登录" forState:UIControlStateNormal];
    [denglu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    denglu.backgroundColor = [UIColor yellowColor];
    denglu.layer.borderColor = [UIColor purpleColor].CGColor;
    denglu.layer.borderWidth = 1;
    denglu.layer.cornerRadius = 5;
    denglu.layer.masksToBounds = YES;
    [denglu addTarget:self action:@selector(deng) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zhuce = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 120, 250, 60, 44)];
    [self.view addSubview: zhuce];
    [zhuce setTitle:@"注册" forState:UIControlStateNormal];
    [zhuce setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zhuce.backgroundColor = [UIColor greenColor];
    zhuce.layer.borderColor = [UIColor purpleColor].CGColor;
    zhuce.layer.borderWidth = 1;
    zhuce.layer.cornerRadius = 5;
    zhuce.layer.masksToBounds = YES;
    [zhuce addTarget:self action:@selector(zhu) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 注册按钮
- (void)zhu
{
    [self.view endEditing:YES];
    NSURL *url = [NSURL URLWithString:zhuceUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str1 = nameTextF.text;
    NSString *str2 = passWordTextF.text;
    
    NSString *parma = [NSString stringWithFormat:@"%@%@%@%@",name,str1,pass,str2];
    NSData *data = [parma dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *reciveData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    //json解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reciveData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *a = [dic objectForKey:@"code"];
    int b = [a intValue];
    
    if (b==200) {//注册成功
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nameTextF.text message:@"恭喜这册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        alert.tag = 1;
        alert.delegate = self;
        
    }else{//注册失败
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nameTextF.text message:@"用户名已存在，请重新注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        alert.tag = 2;
        alert.delegate = self;

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {//注册成功
        
        User *user = [[User alloc] init];
        user.yongHuMing = nameTextF.text;
        user.passWord = passWordTextF.text;
        [_userArrM addObject:user];
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSLog(@"%@",path);
        NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
        [NSKeyedArchiver    archiveRootObject:_userArrM toFile:pat];
        
        [self fanhui];
        
        
    }else{//注册失败
    
    }
}


#pragma mark 登录按钮
- (void)deng
{
    [self.view endEditing:YES];
    NSURL *url = [NSURL URLWithString:dengluUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str1 = nameTextF.text;
    NSString *str2 = passWordTextF.text;
    
    NSString *parma = [NSString stringWithFormat:@"%@%@%@%@",name,str1,pass,str2];
    NSData *data = [parma dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *reciveData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //json解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reciveData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *a = [dic objectForKey:@"code"];
    int b = [a intValue];
    
    if (b==200) {//登录成功
        User *user = [[User alloc]init];
        for (User *obj in _userArrM) {
            if ([obj.yongHuMing isEqualToString:nameTextF.text]) {
                user = obj;
                [_userArrM removeObject:obj];
                break;
            }
        }
        if (user.yongHuMing==nil) {
            user.yongHuMing=nameTextF.text;
            user.passWord=passWordTextF.text;
        }
        [_userArrM addObject:user];
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
        [NSKeyedArchiver    archiveRootObject:_userArrM toFile:pat];
        [self denglijieguo:@"登录成功"];
        
        
        
       
        
    }else{//登录失败
        [self denglijieguo:@"用户名或密码错误，请重新登录"];
        
    }
    
}

#pragma 登录结果
- (void)denglijieguo:(NSString *)str
{
    _v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _v.backgroundColor=[UIColor  lightGrayColor];
    _v.alpha=0.5;
    [self.view  addSubview:_v];
    _lab=[[UILabel   alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6,self.view.frame.size.height/2 , self.view.frame.size.width*2/3, 88)];
    _lab.numberOfLines = 0;
    [self.view  addSubview:_lab];
    _lab.text=str;
    [self.view  bringSubviewToFront:_lab];
    _lab.layer.cornerRadius=15;
    _lab.layer.masksToBounds=YES;
    _lab.textAlignment=NSTextAlignmentCenter;
    _lab.backgroundColor=[UIColor   redColor];
    _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:NO];
}

#pragma mark 定时器方法
-(void)time{
    [_v   removeFromSuperview];
    if ([_lab.text isEqualToString:@"登录成功"]) {
        [self fanhui];
    }
    [_lab   removeFromSuperview];
    [_timer invalidate];
    _timer=nil;
    
    
}

@end
