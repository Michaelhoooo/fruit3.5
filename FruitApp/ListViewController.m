//
//  ListViewController.m
//  FruitApp
//
//  Created by mac on 16/3/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "ListViewController.h"
#import "TableViewCell.h"
#import "Fruit.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "Product.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AddressViewController.h"
#import "CCLocationManager.h"


@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property UITableView *tab;
@property UILabel *heJi;
@property UIButton *pay;


@property UITextView *addText;
@property UITextView *tf;
@property UIView *v4;
@property  User *user;
@property NSMutableArray *arr;
@property NSString *pat;

@property UILabel *lab;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUser];
    [self   setTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aa:) name:@"zzz" object:nil];
}
#pragma mark 接受到通知方法
- (void)aa:(NSNotification *)not
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = not.object;
    
    _addText.text = [NSString stringWithFormat:@"收件人:%@,电话:%@,地址:%@",dic[@"1"],dic[@"2"],dic[@"3"]];
    _addText.textColor = [UIColor blackColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//#pragma mark 添加订单中的商品
//-(void)addToList{
//    //self.navigationItem.title = @"我的订单";
//    _listArr=[[NSMutableArray alloc] init];
//    for (Fruit *tmp in _arr) {
//        if ([tmp.isChoised isEqualToString:@"yes"]) {
//            [_listArr   addObject:tmp];
//        }
//    }
//}


#pragma mark 设置tableview
-(void)setTableView{
    UIView *v=[[UIView   alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-180)];
    [self.view  addSubview:v];
    _tab=[[UITableView   alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height) style:UITableViewStylePlain];
    _tab.dataSource=self;
    _tab.delegate=self;
    [v  addSubview:_tab];
    
    UIView *v2=[[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    v2.backgroundColor=[UIColor orangeColor];
    [self.view  addSubview:v2];
    UIButton *btn1=[[UIButton    alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    [btn1   setBackgroundImage:[UIImage imageNamed:@"miss.png"] forState:UIControlStateNormal];
    btn1.contentMode=UIViewContentModeScaleAspectFit;
    [v2 addSubview:btn1];
    [btn1   addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lab=[[UILabel   alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 15, 100, 30)];
    [v2 addSubview:lab];
    lab.text=@"待完成订单";
    
    UIView  *v3=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    [self.view  addSubview:v3];
    v3.backgroundColor=[UIColor grayColor];
    _heJi=[[UILabel  alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3-30, 15, self.view.frame.size.width/3+30, 30)];
    [v3 addSubview:_heJi];
    _heJi.font=[UIFont  systemFontOfSize:18];
    
    _pay=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2/3, 0, self.view.frame.size.width/3, 60)];
    [v3 addSubview:_pay];
    _pay.backgroundColor=[UIColor    redColor];
    [_pay   setTitle:@"确定" forState:UIControlStateNormal];
    [_pay   setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pay   setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _pay.titleLabel.font=[UIFont    systemFontOfSize:20];
    [_pay   addTarget:self action:@selector(payD) forControlEvents:UIControlEventTouchUpInside];
    
    
    _v4=[[UIView  alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width-50, 60)];
    [self.view  addSubview:_v4];
    _v4.backgroundColor=[UIColor whiteColor];
    _v4.layer.borderColor=[UIColor   blackColor].CGColor;
    _v4.layer.borderWidth=0.8;
    UILabel *address=[[UILabel   alloc] initWithFrame:CGRectMake(8, 20, 40, 20)];
    [_v4 addSubview:address];
    address.text=@"地址:";
    UIButton *getAd=[[UIButton   alloc] initWithFrame:CGRectMake(50, 20, 20, 20)];
    [_v4 addSubview:getAd];
    [getAd  setBackgroundImage:[UIImage imageNamed:@"dingwei.png"] forState:UIControlStateNormal];
    [getAd  addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    _addText=[[UITextView   alloc] initWithFrame:CGRectMake(75, 0,_v4.frame.size.width-75, 60)];
    [_v4 addSubview:_addText];
    _addText.layer.borderWidth=0.5;
    _addText.layer.borderColor=[UIColor blackColor].CGColor;
    _addText.font=[UIFont    systemFontOfSize:15];
    _addText.delegate=self;
    
    
    [self   showMoney];
    
    UIButton *addressBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, self.view.frame.size.height-120+20, 30, 30)];
    [self.view addSubview:addressBut];
    addressBut .backgroundColor = [UIColor redColor];
    [addressBut setTitle:@"我的地址" forState:UIControlStateNormal];
    addressBut.titleLabel.numberOfLines = 0;
    [addressBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addressBut.titleLabel.font = [UIFont systemFontOfSize:13];
    addressBut.layer.cornerRadius = 3;
    addressBut.layer.masksToBounds = YES;
    [addressBut addTarget:self action:@selector(xuandizhi) forControlEvents:UIControlEventTouchUpInside];
    addressBut.layer.cornerRadius = 3;
    addressBut.layer.masksToBounds = YES;
}


#pragma mark 定位
-(void)click{
    _lab=[[UILabel   alloc] initWithFrame:CGRectMake(75, self.view.frame.size.height-120, self.addText.frame.size.width, 60)];
    [self.view  addSubview:_lab];
    _lab.text=@"正在定位...";
    _lab.textColor = [UIColor redColor];
    __block NSString *string;
    
    
    if (IS_IOS8) {
        
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"%@",cityString);
            [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                //string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
            } withAddress:^(NSString *addressString) {
                NSLog(@"%@",addressString);
                [_lab    removeFromSuperview];
                string = [NSString stringWithFormat:@"%@%@",cityString,addressString];
                //[wself setLabelText:string];
                _addText.text=string;
            }];
        }];
    }
}

#pragma 选择地址
- (void)xuandizhi
{
    AddressViewController *addressVc = [[AddressViewController alloc]init];
    addressVc.user = _user;
    addressVc.zhuangtai= @"yes";
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:addressVc];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark 文本框开始编辑状态执行的方法
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _v4.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _addText.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3);
    if (_lab) {
        [_lab   removeFromSuperview];
    }
}

#pragma mark 结束输入时执行的方法
-(void)textViewDidEndEditing:(UITextView *)textView{
    _v4.frame=CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width-50, 60);
    _addText.frame=CGRectMake(75, 0, _v4.frame.size.width-75, 60);
}

#pragma mark 点击空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view  endEditing:YES];
}

#pragma mark  取消按钮方法
-(void)disMiss{
    [self   dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  当前用户查找
- (void)loadUser
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _pat = [path stringByAppendingPathComponent:@"user.plist"];
    _arr=[[NSMutableArray alloc] init];
    _arr=[NSKeyedUnarchiver unarchiveObjectWithFile:_pat];
    _user=[[User alloc] init];
    _user=[_arr lastObject];
}

#pragma mark 结算按钮方法
-(void)payD{
    
    NSMutableArray *a=[[NSMutableArray   alloc] init];
    if(self.i==0){
        a=[_user.listArrM lastObject];
        [_user.listArrM  removeObjectAtIndex:_user.listArrM.count-1];
        for (Fruit *tmp in a) {
            tmp.isChoised=@"payed";
        }
        [_user.listArrM  addObject:a];
        [_arr    replaceObjectAtIndex:_arr.count-1 withObject:_user];
        [NSKeyedArchiver    archiveRootObject:_arr toFile:_pat];
    }else{
        a=_user.listArrM[self.i-1];
        for (Fruit *tmp1 in a) {
            tmp1.isChoised=@"payed";
        }
        [_user.listArrM  replaceObjectAtIndex:self.i-1 withObject:a];
        [_arr    replaceObjectAtIndex:_arr.count-1 withObject:_user];
        [NSKeyedArchiver    archiveRootObject:_arr toFile:_pat];
    }
    Product *product = [[Product alloc]init];
    product.price = 0.01;
    product.subject = @"1";
    product.body=@"测试";
    product.orderId =[self generateTradeNO];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021328701004";
    NSString *seller = @"712291753@qq.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMtB3fAm4cStHD4FMwrvC6tTCIdnhcVJPgnrgYp0Tug65DBlW/xUq7CbCrjVEj36V2Bz1SjYpLCUl/FHO02VZTGCXVDwtKoEyf303/skO6S+A+KhqISmR6qH8gSZuynVtsykb1OkM0qI9GFkfyeCHdj2ESH+nY878W4DsZZtCNkTAgMBAAECgYEAlzjHHaBgAork40PNCQp2vR2Gz+72eKSYcpr0AwWrm14NXfBbcq2wGzIO1Rs5ekEh9xHW+o/MX8/+B7X+aieHY+x3URVafVxUNzoEqxuDDqpvGPL5EKYg9AdDZDa3zhCiTjx/QrEMhzgAlVWT6wXgAtgB92pZ6F6Jm/gRUmtuhZkCQQD6dqJUMoG8L0OieQP13krksSaUP/JB6l9SHZJlbAoQ3H4PiqZ3y/8pyzlFREweptyp9r4kBSxiKH69i+1bPuV/AkEAz8AYOndhRX5B+RWd1elpok/IKhtLYsPiUtn02OgCVAF++DNIfJBp2NUiWzah8NGbf0YMp6/AYfkOblo8CEPebQJBAO466Sws3jmguzRO5vV1+saLuaZJLKSFySTR++18VhazozQlLTHFV27pXhAEZmLBVCJWD4UzZoP3AJZKAfpIWQECQHCWfUrqOagMtbpE0cYE+j+Bl0vigOdkmzolbsFCc0iNiv794/HF3ecqErV2FStKnUfLcb5KzCsMa5q4gkJEbb0CQQCp0KQLIVgXxHnNthvFOVPipbFO6v422e1ps4IqJRu4DSQ2HrNJT3Bi2IsiNsZ05XrYdYZKtKkDIpmmEv1zj5nI";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"payDemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
    [self   dismissViewControllerAnimated:YES completion:nil];///////////////
}


#pragma mark 显示结算价格
-(void)showMoney{
    float pri=0;
    for (Fruit *tmp in _listArr) {
        pri+=[tmp.price floatValue]*[tmp.num    intValue];
    }
    self.heJi.text=[NSString stringWithFormat:@"合计:¥%.2f",pri];
}



#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *reuseID1=@"a";
        TableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:reuseID1];
        if (cell==nil) {
            cell=[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID1];
        }
        Fruit *fr=_listArr[indexPath.row];
        
        cell.lab1.text=fr.name;
        cell.lab2.text=fr.saled;
        cell.lab3.text=fr.goodCom;
        cell.lab4.text=fr.price;
        cell.lab5.text=fr.num;
    cell.btn1.layer.borderWidth=0;
    cell.btn2.layer.borderWidth=0;
        [cell.btn3  setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
    cell.btn3.userInteractionEnabled=NO;
        [cell.img   sd_setImageWithURL:[NSURL URLWithString:fr.imgUrl] placeholderImage:nil];
        //[cell.btn1 setBackgroundImage:[UIImage imageNamed:@"add.jpeg"] forState:UIControlStateNormal];
        [cell.btn2  setBackgroundImage:nil forState:UIControlStateNormal];
        
        return cell;
}

#pragma mark 代理方法，设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
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
