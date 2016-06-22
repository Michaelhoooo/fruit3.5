//
//  GroupViewController.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GroupViewController.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"
#import "AFHTTPRequestOperationManager.h"
#import "Fruit.h"

#import "FruitInforViewController.h"

#define SHOPURL @"http://waimai.baidu.com/stickyRice/waimai?qt=shopmenu&display=json&from=bn-ios&client_from=nuomi-iphone&cid=983253&vmgdb=nuomi-default-vmgdb&dostatid=988266&shop_id=1528262775"
#define DatuStr @"http://map.baidu.com/maps/services/thumbnails?width=320&height=600&align=center,center&quality=100&src=http://img.waimai.bdimg.com/pb/"
#define XiaoTuStr @"http://img.waimai.bdimg.com/pb/"

@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UIView *v1;
@property UIView *v2;
@property UITableView *tab1;
@property UITableView *tab2;

@property NSString *str;//商品分类的名称
@property NSMutableDictionary *dicA;//所有商品组成的字典
@property NSMutableArray *arrayG;//每个分类里，商品的集合
@property NSArray *keyArr;//商品分类名称组成的数组
@property NSMutableArray *arr;//点击左边cell，得到该商品类下所有的商品的数组
@property NSString *kind;//商品种类名称

@property long location;//左边被电击cell所在位置

@property long numOfCell;

@property NSMutableArray *array;//购物车中商品

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"果品分类";
    UIImageView *img=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104)];
    [self.view  addSubview:img];
    img.image=[UIImage  imageNamed:@"23.jpg"];
    img.alpha=0.15;
    
    _location=0;
    
    [self getShopCarData];
    [self   getData];
}

#pragma mark 获取购物车中数据
- (void)getShopCarData
{
//    _array = [NSMutableArray array];
//    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
//    _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    _array = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _array =[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        //[NSKeyedArchiver    archiveRootObject:_array1 toFile:pat];
    }else{
        _array=nil;
    }
}


#pragma mark 网络请求数据
-(void)getData{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:SHOPURL parameters:nil success:^(AFHTTPRequestOperation *operation, id response)
     {
         [self   loadData:response];
//         NSLog(@"网络请求成功");
     } failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
//         NSLog(@"网络请求失败");
     }];
}

#pragma mark 加载数据（数据加载到模型中）
-(void)loadData:(NSDictionary   *)dic{
    _dicA=[[NSMutableDictionary  alloc] init];
    //_arrayG=[[NSMutableArray  alloc] init];
    NSDictionary *dic2=[dic objectForKey:@"result"];
    NSArray *arrAll=[dic2    objectForKey:@"takeout_menu"];
    for (NSDictionary *tmp1 in arrAll) {
        NSArray *arrGrouped=[tmp1 objectForKey:@"data"];
        _arrayG=[[NSMutableArray  alloc] init];
        for (NSDictionary *tmp2 in arrGrouped) {
            Fruit *fru=[[Fruit   alloc] init];
            fru.kind=[tmp1  objectForKey:@"catalog"];
            fru.name=[tmp2  objectForKey:@"name"];
            fru.des=[tmp2   objectForKey:@"description"];
            fru.imgUrl=[tmp2    objectForKey:@"url"];
            fru.price=[tmp2 objectForKey:@"current_price"];
            fru.originalPrice=[tmp2 objectForKey:@"origin_price"];
            fru.saled=[tmp2 objectForKey:@"saled"];
            fru.goodCom=[tmp2   objectForKey:@"good_comment_num"];
            fru.imgUrl2 = [fru.imgUrl stringByReplacingOccurrencesOfString:XiaoTuStr withString:DatuStr];
            [_arrayG addObject:fru];
            _str=fru.kind;
        }
        [_dicA  setObject:_arrayG forKey:_str];
        _keyArr=[_dicA  allKeys];
    }
    
    for (NSString *groupN in _keyArr)
    {
        NSMutableArray *fruits = [NSMutableArray array];
        BOOL isChongFu;
    do{
        fruits = [_dicA objectForKey:groupN];
        isChongFu = NO;
        for (int i = 0; i < fruits.count; i++)
        {
            Fruit *fruit = fruits[i];
            //购买的水量加到商品中
            for (Fruit *buyFruit in _array)
            {
                if ([fruit.name isEqualToString:buyFruit.name])
                {
                    fruit.num = buyFruit.num;
                }
            }
            //找出重复商品
            for (int j = 0; j < i; j++)
            {
                Fruit *fruit1 = fruits[j];
                if ([fruit.name isEqualToString:fruit1.name])
                {
                    [fruits removeObjectAtIndex:i];
                    isChongFu = YES;
                    break;
                }
            }
            if (isChongFu)
            {
                break;
            }
           
        }
    }while(isChongFu);
    }


    [self  setTableView];
}


#pragma mark 设置tableview
-(void)setTableView{
    
    _v1=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width/4, self.view.frame.size.height)];
    [self.view addSubview:_v1];
    _v2=[[UIView  alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 64,self.view.frame.size.width*3/4, self.view.frame.size.height)];
    [self.view  addSubview:_v2];
    _v2.layer.borderColor=[UIColor  blackColor].CGColor;
    _v2.layer.borderWidth=1;
    
    _tab1=[[UITableView  alloc] initWithFrame:CGRectMake(0, 0, _v1.frame.size.width, _v1.frame.size.height-108) style:UITableViewStylePlain];
    _tab1.tag=1;
    [_v1 addSubview:_tab1];
    _tab1.dataSource=self;
    _tab1.delegate=self;
    
    _tab2=[[UITableView  alloc] initWithFrame:CGRectMake(0, 0, _v2.frame.size.width, _v2.frame.size.height-108) style:UITableViewStylePlain];
    _tab2.tag=2;
    [_v2    addSubview:_tab2];
    _tab2.dataSource=self;
    _tab2.delegate=self;
    
}

#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==1){
        return _dicA.count;
    }else if (tableView.tag==2){
        if (_location==0) {
            NSMutableArray *a=[[NSMutableArray   alloc] init];
            a=[_dicA    objectForKey:_keyArr[0]];
            return a.count;
        }else{
            return _numOfCell;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Fruit *fruit = [[Fruit alloc]init];
    
    static NSString *reuseID1=@"asd";
    //static NSString *reuseID2=@"qwe";
    NSString *reuseID2 = [NSString stringWithFormat:@"Cell%li%li",_location,indexPath.row];//以indexPath和location来唯一确定cell
    if(tableView.tag==1){
        TableViewCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:reuseID1];
        if (cell1==nil) {
            cell1=[[TableViewCell1   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID1];
        }
        [cell1  freshData:_keyArr[indexPath.row]];
        if (_location==indexPath.row) {
            cell1.gName.textColor=[UIColor  redColor];
            cell1.gName.backgroundColor=[UIColor    whiteColor];
        }else{
            cell1.gName.textColor=[UIColor  whiteColor];
            cell1.gName.backgroundColor=[UIColor    lightGrayColor];
        }
        cell1.gName.frame=CGRectMake(0, 0, _v1.frame.size.width, _v1.frame.size.width*2/3);
        return cell1;
        }else if (tableView.tag==2){
            TableViewCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:reuseID2];
            if (cell2==nil) {
                cell2=[[TableViewCell2   alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID2];
            }
            if (_location==0) {
                NSMutableArray *a=[[NSMutableArray   alloc] init];
                a=[_dicA    objectForKey:_keyArr[0]];
                [cell2  freshData:a[indexPath.row]];
                fruit = a[indexPath.row];
            }else{
                [cell2  freshData:_arr[indexPath.row]];
                fruit = _arr[indexPath.row];
            }
            [self chuLiButton:cell2 AndFruit:fruit];
            [cell2.btn1 addTarget:self action:@selector(dianji1) forControlEvents:UIControlEventTouchUpInside];
            [cell2.btn2 addTarget:self action:@selector(dianji2) forControlEvents:UIControlEventTouchUpInside];
            cell2.dicA=[[NSMutableDictionary alloc] initWithDictionary:_dicA];
            cell2.keyArr=_keyArr;
            
            return cell2;
    }else{
        return nil;
    }
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
        [self .tabBarController childViewControllers][2].tabBarItem.badgeValue= nil;
    }
}

#pragma mark 处理减号以及数量的隐藏出现
- (void)chuLiButton:(TableViewCell2 *)cell AndFruit:(Fruit *)fruit
{
    if (!fruit.num) {
        cell.btn2.hidden = YES;
        cell.lab5.hidden = YES;
    }else{
        cell.btn2.hidden = NO;
        cell.lab5.hidden = NO;
        cell.lab5.text = fruit.num;
    }

}

#pragma mark 界面刚出现时
- (void)viewWillAppear:(BOOL)animated
{
    [self getShopCarData];
    [self   getData];
    [_tab2 reloadData];
}



#pragma mark 代理方法,返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1){
        return _v1.frame.size.width*2/3;
    }else if (tableView.tag==2){
        return 135;
    }else{    
        return 0;
    }
}


#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        _location=indexPath.row;
        _arr=[[NSMutableArray    alloc] init];
        _arr=[_dicA objectForKey:_keyArr[indexPath.row]];
        _kind=_keyArr[indexPath.row];
        _numOfCell=_arr.count;
        [_tab1  reloadData];
        [_tab2  reloadData];
    } else {
    //*********************************************
        NSString *groupName = _keyArr[_location];
        NSArray *fruits = [_dicA objectForKey:groupName];
        Fruit *fruit = fruits[indexPath.row];
        
        FruitInforViewController *fruitViewC = [[FruitInforViewController alloc] init];
        fruitViewC.fruit = fruit;
        [self.navigationController pushViewController:fruitViewC animated:YES];
    }
}


#pragma mark 设置右边tableview的header
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag==2) {
        UIView *v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.v2.frame.size.width, 30)];
        v.backgroundColor=[UIColor  lightGrayColor];
        UILabel *lab=[[UILabel   alloc] initWithFrame:CGRectMake(20, 5, v.frame.size.width, 20)];
        lab.backgroundColor=[UIColor    lightGrayColor];
        lab.textColor=[UIColor  redColor];
        [v  addSubview:lab];
        if (_location==0) {
            lab.text=_keyArr[0];
        }else{
            lab.text=_kind;
        }
        return v;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag==2) {
        return 30;
    }else{
    
        return 0;
    }
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


