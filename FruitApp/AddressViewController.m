//
//  AddressViewController.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AddressViewController.h"
#import "ATableViewCell.h"
#import "User.h"
#import "Address.h"
#import "DZXViewController.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddressViewController
{
    UITableView *myTableView;
    CGFloat rowH;//行高
    NSMutableArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的地址";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(tianjia)];
    UIBarButtonItem *xiugaiBar = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(xiugai)];
    self.navigationItem.rightBarButtonItems = @[addBar,xiugaiBar] ;
    
    [self addView];
    
}

#pragma mark 建立界面
- (void)addView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    myTableView.userInteractionEnabled = NO;
}

#pragma mark 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.user.addressArrM) {
        self.user.addressArrM = [NSMutableArray array];
    }
    return self.user.addressArrM.count;
    
}

#pragma mark cell创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[ATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Address *address = self.user.addressArrM[indexPath.row];
    rowH = [cell setData:address];
    
    return cell;
}

#pragma mark 点击cell执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.zhuangtai isEqualToString:@"yes"]) {
        Address *address = self.user.addressArrM[indexPath.row];
    
        
        NSDictionary *dic = @{@"1":address.shoujianren,@"2":address.dianhua,@"3":address.dizhi};
        
        //添加通知中心
        [[NSNotificationCenter   defaultCenter] postNotificationName:@"zzz" object:dic];
        [self fanhui];
        return;
    }
    
    DZXViewController *view = [[DZXViewController alloc]init];
    view.address = self.user.addressArrM[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
    
}

#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowH+10;
}

#pragma mark 返回个人中心
- (void)fanhui
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 添加地址
- (void)tianjia
{
    DZXViewController *view = [[DZXViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark 修改地址
- (void)xiugai
{
    myTableView.userInteractionEnabled = YES;
}

#pragma mark 界面刚出现时
- (void)viewWillAppear:(BOOL)animated
{
    [self getUserData];
    self.user = [array lastObject];
    [myTableView reloadData];
    if ([self.zhuangtai isEqualToString:@"yes"]) {
        myTableView.userInteractionEnabled = YES;
    }else{
        myTableView.userInteractionEnabled = NO;
    }
}

#pragma mark 获取用户数据
- (void)getUserData
{
    array = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
}



@end
