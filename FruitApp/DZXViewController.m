//
//  DZXViewController.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DZXViewController.h"
#import "Address.h"
#import "User.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface DZXViewController ()

@property UILabel *lab;
@property UIView *v;
@property NSTimer *timer;

@end

@implementation DZXViewController
{
    UITextField *nameTF ;
    UITextField *telTF;
    UITextView *addressTF;
    BOOL isAdd;
    NSMutableArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(queding)];
    
    [self addView];//界面建立
    [self loadData];//加载传过来的数据
    [self getUserData];//获取所有用户数据
}

#pragma mark 获取用户数据
- (void)getUserData
{
    array = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
}

#pragma mark 加载传过来的数据
- (void)loadData
{
    if (!self.address) {
        isAdd = YES;
        return;
    }
    nameTF.text = self.address.shoujianren;
    telTF.text = self.address.dianhua;
    addressTF.text = self.address.dizhi;
    isAdd = NO;

}

#pragma mark 界面建立
- (void)addView
{
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 84, 60, 30)];
    [self.view addSubview:lab1];
//    lab1.backgroundColor = [UIColor yellowColor];
    lab1.text = @"收件人:";
    lab1.font = [UIFont systemFontOfSize:15];
    
    nameTF = [[UITextField alloc]initWithFrame:CGRectMake(80, 84, ScreenW-130, 30)];
    nameTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTF];
    
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 119, 60, 30)];
    [self.view addSubview:lab2];
//    lab2.backgroundColor = [UIColor yellowColor];
    lab2.text = @"电话:";
    lab2.font = [UIFont systemFontOfSize:15];
    
    telTF = [[UITextField alloc]initWithFrame:CGRectMake(80, 119, ScreenW-130, 30)];
    telTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:telTF];
    telTF.keyboardType =UIKeyboardTypeNumberPad;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 154, 60, 30)];
    [self.view addSubview:lab3];
//    lab3.backgroundColor = [UIColor yellowColor];
    lab3.text = @"地址:";
    lab3.font = [UIFont systemFontOfSize:15];
    
    addressTF = [[UITextView alloc]initWithFrame:CGRectMake(50, 189, ScreenW-100, ScreenW-100)];
    addressTF.layer.borderColor = [UIColor grayColor].CGColor;
    addressTF.layer.borderWidth = 1;
    [self.view addSubview:addressTF];
    addressTF.layer.cornerRadius = 5;
    addressTF.layer.masksToBounds = YES;
    
}

#pragma mark 点击确定按钮
- (void)queding
{
    [self.view endEditing:YES];
    if (nameTF.text.length ==0||telTF.text.length ==0||addressTF.text.length ==0) {
        [self denglijieguo];
        return;
    }
    
    User *user = [array lastObject];
    Address *newAddress = [[Address alloc]init];
    newAddress.shoujianren = nameTF.text;
    newAddress.dianhua = telTF.text;
    newAddress.dizhi = addressTF.text;
    [self.view endEditing:YES];
    if (isAdd) {
        if (user.addressArrM== nil) {
            user.addressArrM = [NSMutableArray array];
        }
        [user.addressArrM addObject:newAddress];
    } else {
        for (Address *obj in user.addressArrM) {
            if ([obj.shoujianren isEqualToString:self.address.shoujianren]&&[obj.dianhua isEqualToString:self.address.dianhua]&&[obj.dizhi isEqualToString:self.address.dizhi]) {
                [user.addressArrM removeObject:obj];
                break;
            }
        }
        [user.addressArrM addObject:newAddress];
    }
    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"%@",path);
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    [NSKeyedArchiver    archiveRootObject:array toFile:pat];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma 信息填写不完整时弹出窗口
- (void)denglijieguo
{
    _v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _v.backgroundColor=[UIColor  lightGrayColor];
    _v.alpha=0.5;
    [self.view  addSubview:_v];
    _lab=[[UILabel   alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6,self.view.frame.size.height/2 , self.view.frame.size.width*2/3, 88)];
    _lab.numberOfLines = 0;
    [self.view  addSubview:_lab];
    _lab.text=@"信息不完整，请继续填写";
    [self.view  bringSubviewToFront:_lab];
    _lab.layer.cornerRadius=15;
    _lab.layer.masksToBounds=YES;
    _lab.textAlignment=NSTextAlignmentCenter;
    _lab.backgroundColor=[UIColor   grayColor];
    _lab.alpha = 0.6;
    //_timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:NO];
    [UIView animateWithDuration:2.f animations:^{
        _v.alpha =0.f;
        _lab.alpha = 0.f;
    } completion:^(BOOL finished){
        [_lab   removeFromSuperview];
        [_v   removeFromSuperview];
        
    
    }];
}

#pragma mark 定时器方法
//-(void)time{
//    [_v   removeFromSuperview];
//    [_lab   removeFromSuperview];
//    [_timer invalidate];
//    _timer=nil;
//    
//    
//}


#pragma mark 点击空白处
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
