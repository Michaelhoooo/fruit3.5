//
//  FirstViewController.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "FirstViewController.h"
#import "OneTableViewCell.h"
#import "TwoTableViewCell.h"
#import "FruitInforViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "Fruit.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

#import "SDCycleScrollView.h"

#define SHOPURL @"http://waimai.baidu.com/stickyRice/waimai?qt=shopmenu&display=json&from=bn-ios&client_from=nuomi-iphone&cid=983253&vmgdb=nuomi-default-vmgdb&dostatid=988266&shop_id=1528262775"
#define DatuStr @"http://map.baidu.com/maps/services/thumbnails?width=320&height=600&align=center,center&quality=100&src=http://img.waimai.bdimg.com/pb/"
#define XiaoTuStr @"http://img.waimai.bdimg.com/pb/"

#define FirstGao 250
#define SecondGao 190
#define HeadGao 250


@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property NSString *str;//商品分类的名称
@property NSMutableDictionary *dicA;//所有商品信息组成的字典
@property NSMutableArray *arrayG;//每个分类里，商品的集合
@property NSArray *keyArr;//所有商品分类名称组成的数组
@property NSMutableArray *arr;//点击左边cell，得到该商品类下所有的商品的数组
@property NSString *kind;//商品种类名称

@property NSMutableArray *array;//购物车中商品


@property UIImageView *img1;
@property UIImageView *img2;

@end

@implementation FirstViewController
{
    UITableView *myTableView;
//    UIPageControl  *page;
    UIScrollView *scroll;
    SDCycleScrollView *cycleScrollView2;
    BOOL isSearch;
    NSMutableArray *searchArr;
    
    CGPoint oldOffSet;
    CGPoint nowOffSet;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self   setTop];
    [self getShopCarData];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    searchArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *img=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104)];
    [self.view  addSubview:img];
    img.image=[UIImage  imageNamed:@"23.jpg"];
    img.alpha=0.15;
    [self getData];//请求数据
    
}

#pragma mark  设置顶部
-(void)setTop{
    CGRect nav=self.navigationController.navigationBar.frame;
    UIView *v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, nav.size.height)];
    
    _img1=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height)];
    _img1.contentMode=UIViewContentModeScaleAspectFit;
    _img1.backgroundColor=[UIColor    whiteColor];
    _img1.image=[UIImage  imageNamed:@"top.jpg"];
    [v  addSubview:_img1];
    _img2=[[UIImageView   alloc] initWithFrame:CGRectMake(v.frame.size.width, 0, v.frame.size.width, v.frame.size.height)];
    _img2.contentMode=UIViewContentModeScaleAspectFit;
    _img2.backgroundColor=[UIColor    whiteColor];
    _img2.image=[UIImage  imageNamed:@"top.jpg"];
    [v  addSubview:_img2];
    
    
    //设置定时器
    NSTimer *timer=[NSTimer    timerWithTimeInterval:0.05 target:self selector:@selector(showTop) userInfo:nil repeats:YES];
    NSRunLoop *runLoop=[NSRunLoop   currentRunLoop];
    [runLoop    addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    self.navigationItem.titleView=v;
}
-(void)showTop{
    static int i=1;
    _img1.frame=CGRectMake(0-i*2, 0, _img1.frame.size.width, _img1.frame.size.height);
    _img2.frame=CGRectMake(_img2.frame.size.width-i*2, 0, _img1.frame.size.width, _img1.frame.size.height);
    i++;
    if (_img2.frame.origin.x<=0) {
        _img1.frame=CGRectMake(0, 0, _img1.frame.size.width, _img1.frame.size.height);
        _img2.frame=CGRectMake(_img1.frame.size.width, 0, _img1.frame.size.width, _img1.frame.size.height);
        i=1;
    }
}




#pragma mark 界面消失时
-(void)viewWillDisappear:(BOOL)animated{
    [self getData];
}


#pragma mark 获取购物车中数据
- (void)getShopCarData
{
    _array = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
}

#pragma mark －－－添加TableView
- (void)addView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
}


#pragma mark 网络请求数据
-(void)getData{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:SHOPURL parameters:nil success:^(AFHTTPRequestOperation *operation, id response)
     {
         [self   loadData:response];
//         NSLog(@"网络请求成功");
//         //NSLog(@"%@",_arrayA);
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
    for (NSDictionary *tmp1 in arrAll)
    {
        NSArray *arrGrouped=[tmp1 objectForKey:@"data"];
        _arrayG=[[NSMutableArray  alloc] init];
        for (NSDictionary *tmp2 in arrGrouped)
        {
            Fruit *fru=[[Fruit   alloc] init];
            fru.kind=[tmp1  objectForKey:@"catalog"];
            fru.name=[tmp2  objectForKey:@"name"];
            fru.des=[tmp2   objectForKey:@"description"];
            fru.imgUrl=[tmp2    objectForKey:@"url"];
            fru.imgUrl2 = [fru.imgUrl stringByReplacingOccurrencesOfString:XiaoTuStr withString:DatuStr];

            fru.price=[tmp2 objectForKey:@"current_price"];
            fru.originalPrice=[tmp2 objectForKey:@"origin_price"];
            fru.saled=[tmp2 objectForKey:@"saled"];
            fru.goodCom=[tmp2   objectForKey:@"good_comment_num"];
            fru.pingjia = [tmp2 objectForKey:@"recommend_num"];
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
    
    [self addView];//添加界面
    [self addSearchBar];//添加搜索栏
    
}


#pragma mark 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch)
    {
        return searchArr.count;
    }
    NSString *groupName = self.keyArr[section];
    NSArray *fruitArr = [self.dicA objectForKey:groupName];
    NSInteger number = fruitArr.count;
    
    int a = (int)number/5;
    int b = number%5;
    int c = b/2;
    int d = b%2;
    
    return a*3+c+d;
    

}


#pragma mark 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        OneTableViewCell *cell = [self getOneCell:tableView];
        cell.button.tag = indexPath.row;
        //给cell赋值
        [self setFirstCellData:cell];
        return cell;
    }
    
    NSString *groupName = self.keyArr[indexPath.section];
    NSArray *fruitArr = [self.dicA objectForKey:groupName];
    NSInteger number = fruitArr.count;
    
   int a = (int)number/5;
   int b = number%5;
    
    if (indexPath.row < a*3 )
    {
        if ((indexPath.row+1)%3==0)
        {
           OneTableViewCell *cell = [self getOneCell:tableView];
            cell.button.tag = indexPath.section*100+(indexPath.row+1)/3*5;
            //给cell赋值
            [self setFirstCellData:cell];
            return cell;
            
        } else
        {
           TwoTableViewCell *cell = [self getTwoCell:tableView];
            
            if ((indexPath.row+2)%3==0)
            {
                cell.leftBut.tag = indexPath.section*100+(indexPath.row+2)/3*5-2;
                cell.rightBut.tag = indexPath.section*100+(indexPath.row+2)/3*5-1;
            }else
            {
                cell.leftBut.tag = indexPath.section*100+(indexPath.row+3)/3*5-4;
                cell.rightBut.tag = indexPath.section*100+(indexPath.row+3)/3*5-3;
            }
            //给cell赋值
            [self setSecondCellData:cell];
            return cell;
        }
    }
    else
    {
        if (indexPath.row - a*3 == 0)
        {
            if (b == 1)
            {
                OneTableViewCell *cell = [self getOneCell:tableView];
                cell.button.tag = indexPath.section*100+number;
                //给cell赋值
                [self setFirstCellData:cell];
                return cell;
            }else
            {
               TwoTableViewCell *cell = [self getTwoCell:tableView];
                if (b == 2)
                {
                    cell.leftBut.tag = indexPath.section*100+number - 1;
                    cell.rightBut.tag = indexPath.section*100+number ;
                }
                else if (b == 3)
                {
                    cell.leftBut.tag = indexPath.section*100+number - 2;
                    cell.rightBut.tag = indexPath.section*100+number - 1;

                }else
                {
                    cell.leftBut.tag = indexPath.section*100+number - 3;
                    cell.rightBut.tag = indexPath.section*100+number - 2;

                }
                //给cell赋值
                [self setSecondCellData:cell];
                return cell;
            }
        }else
        {
            if (b == 3)
            {
                OneTableViewCell *cell = [self getOneCell:tableView];
                cell.button.tag = indexPath.section*100+number;
                [self setFirstCellData:cell];
                //给cell赋值
                return cell;
            }else
            {
                TwoTableViewCell *cell = [self getTwoCell:tableView];
                cell.leftBut.tag = indexPath.section*100+number - 1;
                cell.rightBut.tag = indexPath.section*100+number;
                //给cell赋值
                [self setSecondCellData:cell];
                return cell;
            }

        }
    }
    
}

#pragma mark 创建第一种类型cell
- (OneTableViewCell *)getOneCell:(UITableView *)tableView
{
    OneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OneTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 1;
    
    return cell;
}

#pragma mark 创建第二种类型cell
- (TwoTableViewCell *)getTwoCell:(UITableView *)tableView
{
    
    TwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[TwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark cell赋值
-(void)setFirstCellData:(OneTableViewCell *)cell
{
    if (isSearch) {
        Fruit *fruit1 = searchArr[cell.button.tag];
        
        cell.name.text = [NSString stringWithFormat:@"%@",fruit1.name];
        cell.price.text = [NSString stringWithFormat:@"¥%@",fruit1.price];
        NSURL *url = [NSURL URLWithString:fruit1.imgUrl2];
        [cell.image sd_setImageWithURL:url placeholderImage:nil];
        
        [cell.button addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    
    int zu = (int)cell.button.tag/100;
    int hang = (int)cell.button.tag%100;
    NSString *keyName = self.keyArr[zu];
    NSArray *fruits = [self.dicA objectForKey:keyName];
    Fruit *fruit = fruits[hang-1];
    
    cell.name.text = [NSString stringWithFormat:@"%@",fruit.name];
    cell.price.text = [NSString stringWithFormat:@"¥%@",fruit.price];
    NSURL *url = [NSURL URLWithString:fruit.imgUrl2];
    [cell.image sd_setImageWithURL:url placeholderImage:nil];
    
    [cell.button addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark cell赋值
-(void)setSecondCellData:(TwoTableViewCell *)cell
{
    int zu = (int)cell.leftBut.tag/100;
    int hang = (int)cell.leftBut.tag%100;
    NSString *keyName = self.keyArr[zu];
    NSArray *fruits = [self.dicA objectForKey:keyName];
    Fruit *fruit1 = fruits[hang-1];
    
    int zu1 = (int)cell.rightBut.tag/100;
    int hang1 = (int)cell.rightBut.tag%100;
    NSString *keyName1 = self.keyArr[zu1];
    NSArray *fruits1 = [self.dicA objectForKey:keyName1];
    Fruit *fruit2 = fruits1[hang1-1];
    
    cell.leftName.text = [NSString stringWithFormat:@"%@",fruit1.name];
    cell.rightName.text = [NSString stringWithFormat:@"%@",fruit2.name];
    cell.leftPrice.text = [NSString stringWithFormat:@"¥%@",fruit1.price];
    cell.rightPrice.text = [NSString stringWithFormat:@"¥%@",fruit2.price];
    NSURL *url1 = [NSURL URLWithString:fruit1.imgUrl2];
    [cell.leftImage sd_setImageWithURL:url1 placeholderImage:nil];
    NSURL *url2 = [NSURL URLWithString:fruit2.imgUrl2];
    [cell.rightImage sd_setImageWithURL:url2 placeholderImage:nil];
    
    [cell.leftBut addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightBut addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark 组头部view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isSearch) {
        return nil;
    }
    
    NSString *groupName = self.keyArr[section];
    
    NSArray *fruitArr = [self.dicA objectForKey:groupName];
    NSInteger number = fruitArr.count;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeadGao)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    lab.text = groupName;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor orangeColor];
    lab.font = [UIFont systemFontOfSize:20];
    [view addSubview:lab];
    
    if (number<6) {
        return view;
    }
    
    
    //******************************************
    scroll = [[UIScrollView alloc]init];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width*5, HeadGao-30);
    scroll.frame = CGRectMake(0, 30, self.view.frame.size.width, HeadGao-30);
    [view addSubview:scroll];
    scroll.backgroundColor = [UIColor greenColor];
    
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        Fruit *fruit = fruitArr[number-i-1];
        [imagesURLStrings addObject:fruit.imgUrl2];
        NSString *str = [NSString stringWithFormat:@"欢迎光顾'秒生活'，以下为'%@'商品",fruit.kind];
        [titles addObject:str];
    }
    
    // 网络加载 --- 创建带标题的图片轮播器
    cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeadGao-30) delegate:self placeholderImage:nil];
    cycleScrollView2.autoScrollTimeInterval = 1.2;
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.pageDotColor = [UIColor brownColor];
    [scroll addSubview:cycleScrollView2];
    
    cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView2.titleLabelTextFont= [UIFont systemFontOfSize:12];
    cycleScrollView2.titleLabelBackgroundColor = [UIColor clearColor];
    
    
    return view;

}




#pragma  mark 上拉去除键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    nowOffSet.y = myTableView.contentOffset.y;
    if (nowOffSet.y>oldOffSet.y) {
        [self.view endEditing:YES];
    }
    oldOffSet.y = nowOffSet.y;
    
    
}


#pragma mark 组头部view高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isSearch) {
        return  0;
    }
    
    NSString *groupName = self.keyArr[section];
    NSArray *fruitArr = [self.dicA objectForKey:groupName];
    NSInteger number = fruitArr.count;
    if (number<6) {
        return 30;
    }
    return HeadGao;
}

#pragma mark 点击图片
- (void)dianji:(UIButton *)but
{
    if (isSearch) {
        Fruit *fruit = searchArr[but.tag];
        FruitInforViewController *fruitViewC = [[FruitInforViewController alloc] init];
        fruitViewC.fruit = fruit;
        [self.navigationController pushViewController:fruitViewC animated:YES];
        return;
    }
    
    
    int zu = (int)but.tag/100;
    int hang = (int)but.tag%100;
    NSString *keyName = self.keyArr[zu];
    NSArray *fruits = [self.dicA objectForKey:keyName];
    Fruit *fruit = fruits[hang-1];
    
    FruitInforViewController *fruitViewC = [[FruitInforViewController alloc] init];
    fruitViewC.fruit = fruit;
    [self.navigationController pushViewController:fruitViewC animated:YES];
}

#pragma mark 多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch) {
        return 1;
    }
    
    return self.keyArr.count;
}

#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch) {
        return FirstGao;
    }
    
    NSString *groupName = self.keyArr[indexPath.section];
    NSArray *fruitArr = [self.dicA objectForKey:groupName];
    NSInteger number = fruitArr.count;
    
    int a = (int)number/5;
    int b = number%5;
    
    if (indexPath.row < a*3 )
    {
        if ((indexPath.row+1)%3==0)
        {
            return FirstGao;
            
        } else
        {
          
            return SecondGao;
        }
    }
    else
    {
        if (indexPath.row - a*3 == 0)
        {
            if (b == 1)
            {
                return FirstGao;
            }else
            {
                return SecondGao;
            }
        }else
        {
            if (b == 3)
            {
                return FirstGao;
            }else
            {
                return SecondGao;
            }
            
        }
    }
}

#pragma mark 添加SearchBar
- (void)addSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    searchBar.backgroundColor = [UIColor redColor];
    searchBar.placeholder = @"请输入寻找水果";
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark 搜索过程文字变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isSearch = YES;
    [searchArr removeAllObjects];
    
    NSInteger zushu = self.keyArr.count;
    for (int i = 0; i < zushu; i++)
    {
        NSString *zuming = self.keyArr[i];
        NSArray *fruits = [self.dicA objectForKey:zuming];
        for (Fruit *fruit in fruits)
        {
            if ([fruit.name rangeOfString:searchText].length)
            {
                [searchArr addObject:fruit];
            }
        }
    }
   
    [myTableView reloadData];
}

#pragma mark 点击SearchBar取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch = NO;
    [searchArr removeAllObjects];
    [myTableView reloadData];
    [self.view endEditing:YES];
    
}

@end
