//
//  QiDongViewController.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "QiDongViewController.h"

#import "FirstViewController.h"
#import "GroupViewController.h"
#import "BuyCarViewController.h"
#import "MyInforViewController.h"
#import "Fruit.h"
#import "QiDongViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface QiDongViewController ()<UIScrollViewDelegate>

@property NSMutableArray *array;//购物车中商品

@end

@implementation QiDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addView];
}


#pragma mark 界面建立
- (void)addView
{
    NSArray *arr = @[@"qidong1.jpg",@"qidong2.jpg",@"top.jpg"];
    UIScrollView *scroller = [[UIScrollView alloc]init];
    scroller.frame = self.view.frame;
    scroller.contentSize = CGSizeMake(ScreenW*3, 0);
    scroller.pagingEnabled = YES;
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    for (int i = 0; i <3; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(ScreenW*i, 0, ScreenW, ScreenH);
        image.image = [UIImage imageNamed:arr[i]];
        [scroller addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    UIButton *but = [[UIButton alloc]init];
    but.frame = CGRectMake(ScreenW*2.4, ScreenH*0.7, ScreenW*0.2, 44);
    [scroller addSubview:but];
    but.backgroundColor = [UIColor orangeColor];
    [but addTarget:self action:@selector(dianji) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:@"立即体验" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:15*ScreenW/375];
    but.layer.cornerRadius = 5*ScreenW/375;
    but.layer.masksToBounds = YES;
    
}

- (void)dianji
{
    
    
    UITabBarController *tableBarC = [[UITabBarController alloc] init];
    
    FirstViewController *firstViewC = [[FirstViewController alloc] init];
    GroupViewController *groupViewC = [[GroupViewController alloc] init];
    UINavigationController *firstNC = [[UINavigationController alloc]initWithRootViewController:firstViewC];
    UINavigationController *groupNC = [[UINavigationController alloc]initWithRootViewController:groupViewC];
    
    MyInforViewController *myInforViewC = [[MyInforViewController alloc]init];
    BuyCarViewController *buyCarViewC = [[BuyCarViewController alloc] init];
    
    UINavigationController *buyCarNC=[[UINavigationController    alloc] initWithRootViewController:buyCarViewC];
    
    tableBarC.viewControllers = @[firstNC,groupNC,buyCarNC,myInforViewC];
    
    [self presentViewController:tableBarC animated:YES completion:nil];
    
    [UIImage imageNamed:@"first.png"];
    UIImage *image1 = [UIImage imageNamed:@"first_selected.png"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"first.png"] selectedImage:image1];
    UIImage *image2 = [UIImage imageNamed:@"group_selected.png"];
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    groupNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"果品分类" image:[UIImage imageNamed:@"group.png"] selectedImage:image2];
    UIImage *image3 = [UIImage imageNamed:@"shopCar_selected@2x.png"];
    image3 = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    buyCarViewC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[UIImage imageNamed:@"shopCar@2x.png"] selectedImage:image3];
    UIImage *image4 = [UIImage imageNamed:@"my_selected@2x.png"];
    image4 = [image4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myInforViewC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"my@2x.png"] selectedImage:image4];
    
    [self getShopCarData];
    if (_array){
        int sum = 0;
        for (Fruit *fruit in _array) {
            int num = [fruit.num intValue];
            sum += num;
        }
        if (sum != 0) {
            buyCarViewC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",sum];
        }
        
    }

}

#pragma mark 获取购物车中数据
- (void)getShopCarData
{
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

@end
