//
//  BuyCarViewController.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BuyCarViewController.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Fruit.h"
#import "FruitInforViewController.h"
#import "ListViewController.h"
#import "User.h"

@interface BuyCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *tab;
@property NSMutableArray *array;
@property NSDictionary *dic;

@property NSArray *arr;
@property Fruit *fr;

@property NSString *isC;//判断是否全选，全选为“yes”，未全选中为“no”

@property UILabel *heJi;//合计
@property UIButton *allCh;//全选按钮
@property UIButton *pay;//结算按钮

@property UILabel *lab;
@property UIView *v;


@property NSTimer *timer;
@end

@implementation BuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self   settableView];
    self.navigationItem.title = @"购物车";
    
    //添加事件监听者
    [[NSNotificationCenter   defaultCenter] addObserver:self selector:@selector(fun) name:@"aaa" object:nil];
    [[NSNotificationCenter   defaultCenter] addObserver:self selector:@selector(fun) name:@"bbb" object:nil];
    [[NSNotificationCenter   defaultCenter] addObserver:self selector:@selector(fun1) name:@"ccc" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 收到通知执行的方法
-(void)fun{
    [_tab   reloadData];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm fileExistsAtPath:pat]){
    NSArray *arr=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
    
    int i=0;
    for (Fruit *tmp in arr) {
        if ([tmp.isChoised isEqualToString:@"no"]||tmp.isChoised==nil) {
            break;
        }
        i++;
    }
    if (i==arr.count&&i!=0) {
        self.isC=@"yes";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
    }else{
        self.isC=@"no";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }
    
    [self   showMoney];
    }else{
        return;
    }
}
-(void)fun1{
    if ([self.isC isEqualToString:@"yes"]) {
        self.isC=@"no";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }else if ([self.isC isEqualToString:@"no"]){
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
        NSArray *arr=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
        int i=0;
        for (Fruit *tmp in arr) {
            if ([tmp.isChoised isEqualToString:@"no"]||tmp.isChoised==nil) {
                break;
            }
            i++;
        }
        if (i==arr.count) {
            self.isC=@"yes";
            [self.allCh setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
        }else{
            self.isC=@"no";
            [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
        }
    }
    [self   showMoney];
    [_tab   reloadData];
}



#pragma mark 界面刚出现时
-(void)viewWillAppear:(BOOL)animated{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    NSArray *arr=[NSKeyedUnarchiver unarchiveObjectWithFile:pat];
    if ([fm fileExistsAtPath:pat]==YES&&arr.count!=0) {
        [self   settableView];
    }else{
        [self   setV];
    }
    
}

#pragma mark 购物车无商品时
-(void)setV{
    UIView  *v=[[UIView  alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108)];
    [self.view  addSubview:v];
    v.backgroundColor=[UIColor  whiteColor];
    UIImageView *img=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104)];
    [v  addSubview:img];
    img.image=[UIImage  imageNamed:@"kong.png"];
    img.contentMode=UIViewContentModeScaleAspectFit;
}

#pragma mark  购物车有商品时设置tableview
-(void)settableView{
    UIView  *v=[[UIView  alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-168)];
    [self.view  addSubview:v];
    UIImageView *img=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104)];
    [v  addSubview:img];
    img.image=[UIImage  imageNamed:@"beijing.jpg"];
    
    
    _tab=[[UITableView   alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height) style:UITableViewStylePlain];
    [v  addSubview:_tab];
    [v bringSubviewToFront:_tab];
    _tab.alpha=0.9;
    _tab.dataSource=self;
    _tab.delegate=self;
    _array=[[NSMutableArray  alloc] init];
    
    UIView  *v2=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-104, self.view.frame.size.width, 60)];
    [self.view  addSubview:v2];
    v2.backgroundColor=[UIColor grayColor];
    
    _allCh=[[UIButton   alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    [v2  addSubview:_allCh];
    _allCh.layer.cornerRadius=15;
    _allCh.layer.masksToBounds=YES;
    _allCh.layer.borderColor=[UIColor greenColor].CGColor;
    _allCh.layer.borderWidth=1;
    [_allCh  addTarget:self action:@selector(allChD) forControlEvents:UIControlEventTouchUpInside];
    UILabel *quanXuan=[[UILabel  alloc] initWithFrame:CGRectMake(45, 15, 30, 30)];
    [v2 addSubview:quanXuan];
    quanXuan.text=@"全选";
    quanXuan.font=[UIFont   systemFontOfSize:15];
    quanXuan.textColor=[UIColor whiteColor];
    
    _heJi=[[UILabel  alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3-30, 15, self.view.frame.size.width/3+30, 30)];
    [v2 addSubview:_heJi];
    _heJi.font=[UIFont  systemFontOfSize:18];
    
    _pay=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2/3, 0, self.view.frame.size.width/3, 60)];
    [v2 addSubview:_pay];
    _pay.backgroundColor=[UIColor    redColor];
    [_pay   setTitle:@"提交订单" forState:UIControlStateNormal];
    [_pay   setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pay   setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _pay.titleLabel.font=[UIFont    systemFontOfSize:20];
    [_pay   addTarget:self action:@selector(payD) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self   setIconFirst];
    [self   showMoney];
}

#pragma mark 显示结算价格
-(void)showMoney{
    float pri=0;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSArray *arr=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
    for (Fruit *tmp in arr) {
        if ([tmp.isChoised isEqualToString:@"yes"]) {
            NSString *nPri=tmp.price;
            pri+=[tmp.num   intValue]*[nPri floatValue];
        }
    }
    self.heJi.text=[NSString stringWithFormat:@"合计:¥%.2f",pri];
}






#pragma mark 给全选按钮添加初始图标
-(void)setIconFirst{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    NSMutableArray *arr =[[NSMutableArray  alloc] init];
    if([fm  fileExistsAtPath:pat]==YES){
    arr=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    int i=0;
    for (Fruit *tmp in arr) {
        if ([tmp.isChoised isEqualToString:@"yes"]) {
            i++;
        }
    }
    if (i==arr.count&&i!=0) {
        self.isC=@"yes";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
    }else{
        self.isC=@"no";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }
    }else{
        self.isC=@"no";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }
    [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
}

#pragma mark 全选按钮点击方法
-(void)allChD{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSArray *arr=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    
    if ([self.isC isEqualToString:@"no"]) {
        for (Fruit *tmp in arr) {
            tmp.isChoised=@"yes";
//            NSLog(@"%@",tmp.isChoised);
        }
        [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
        self.isC=@"yes";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
        [_tab   reloadData];
    }else if([self.isC isEqualToString:@"yes"]){
        for (Fruit *tmp in arr) {
            tmp.isChoised=@"no";
//            NSLog(@"%@",tmp.isChoised);
        }
        [NSKeyedArchiver    archiveRootObject:arr toFile:pat];
        self.isC=@"no";
        [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
        [_tab   reloadData];
    }
    [self   showMoney];
}


#pragma marl 结算按钮点击方法
-(void)payD{
    int no=0;
    self.heJi.text=[NSString stringWithFormat:@"合计:¥%.2f",0.00];
    
    
    int i=0;
    for (Fruit *tmp in _array) {
        if ([tmp.isChoised isEqualToString:@"yes"]) {
            i++;
        }
    }
    if(i!=0){
        ListViewController *listV=[[ListViewController   alloc] init];
        listV.listArr=[[NSMutableArray alloc] init];
        for (Fruit *tmp in _array) {
            if ([tmp.isChoised isEqualToString:@"yes"]) {
                [listV.listArr  addObject:tmp];
            }
        }
        [self   addDingDan:listV.listArr];
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
        for (Fruit *tmp2 in listV.listArr) {
            [_array removeObject:tmp2];
            no+=[tmp2.num  intValue];
        }
        [NSKeyedArchiver    archiveRootObject:_array toFile:pat];
        [self presentViewController:listV animated:YES completion:nil];
        [_tab   reloadData];
        
        //设置购物车下标显示的数字//
        NSString *numStr = [self .tabBarController childViewControllers][2].tabBarItem.badgeValue;
        int num = [numStr intValue];
        if (num >no) {
            [self .tabBarController childViewControllers][2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num-no];
        }else{
            [self .tabBarController childViewControllers][2].tabBarItem.badgeValue= nil;
        }/////////////////////
        
        //判断购物车是否为空
        if (_array.count==0) {
            self.isC=@"no";
            [self.allCh setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
        }
        
    }else{
        _v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _v.backgroundColor=[UIColor  lightGrayColor];
        _v.alpha=0.5;
        [self.view  addSubview:_v];
        _lab=[[UILabel   alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3,(self.view.frame.size.height-self.view.frame.size.width/3)/2 , self.view.frame.size.width/3, self.view.frame.size.width/3)];
        [self.view  addSubview:_lab];
        _lab.text=@"请选择商品";
        [self.view  bringSubviewToFront:_lab];
        _lab.layer.cornerRadius=15;
        _lab.layer.masksToBounds=YES;
        _lab.textAlignment=NSTextAlignmentCenter;
        _lab.backgroundColor=[UIColor   grayColor];
        _lab.alpha=0.8;
        _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:NO];
    }
}

#pragma mark 将订单存入沙盒
-(void)addDingDan:(NSMutableArray *)list{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
//    NSLog(@"%@",pat);
    NSMutableArray *arrAll=[[NSMutableArray  alloc] init];
    arrAll=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    User *user=[[User    alloc] init];
    user=[arrAll    lastObject];
    if (user.listArrM==nil) {
        user.listArrM=[[NSMutableArray   alloc] init];
        [user.listArrM  addObject:list];
    }else{
        [user.listArrM  addObject:list];
    }
    [arrAll replaceObjectAtIndex:(arrAll.count-1) withObject:user];
    [NSKeyedArchiver    archiveRootObject:arrAll toFile:pat];
    //NSLog(@"%@",user.listArrM);
}


#pragma mark 定时器方法
-(void)time{
    [_v   removeFromSuperview];
    [_lab   removeFromSuperview];
    [_timer invalidate];
    _timer=nil;
}

#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        return _array.count;
    }else{
    
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = [NSString stringWithFormat:@"Cell%li",indexPath.row];
    //static NSString *reuseID=@"zxc";
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil) {
        cell=[[TableViewCell    alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    Fruit *fr=[[Fruit    alloc] init];
    fr=_array[indexPath.row];
    cell.lab1.text=fr.name;
    cell.lab2.text=fr.saled;
    cell.lab3.text=fr.goodCom;
    cell.lab4.text=fr.price;
    cell.lab5.text=fr.num;
    if ([fr.isChoised isEqualToString:@"yes"]) {
        [cell.btn3  setBackgroundImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
    }else{
        [cell.btn3  setBackgroundImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }
    
    [cell.img   sd_setImageWithURL:[NSURL URLWithString:fr.imgUrl] placeholderImage:nil];
    [cell.btn1 setBackgroundImage:[UIImage imageNamed:@"add.jpeg"] forState:UIControlStateNormal];
    
    [cell.btn1 addTarget:self action:@selector(dianji1) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(dianji2) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)dianji1
{
    
    int num;
    NSString *numStr = [self .tabBarController childViewControllers][2].tabBarItem.badgeValue;
    if (!numStr) {
        num = 0;
    }
    else{
        num = [numStr intValue];
    }
    [self .tabBarController childViewControllers][2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num+1];
    
    
    
}

- (void)dianji2
{
    NSString *numStr = [self .tabBarController childViewControllers][2].tabBarItem.badgeValue;
    int num = [numStr intValue];
    if (num >1) {
        [self .tabBarController childViewControllers][2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num-1];
    }else{
        [self   setV];
        [self .tabBarController childViewControllers][2].tabBarItem.badgeValue= nil;
    }
}

#pragma mark 代理方法，设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}


#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSArray *array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    [NSKeyedArchiver    archiveRootObject:array toFile:pat];
    Fruit *fr=array[indexPath.row];
    FruitInforViewController *fruitViewC = [[FruitInforViewController alloc] init];
    fruitViewC.fruit = fr;
    [self.navigationController pushViewController:fruitViewC animated:YES];
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
