//
//  AppDelegate.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "GroupViewController.h"
#import "BuyCarViewController.h"
#import "MyInforViewController.h"
#import "Fruit.h"
#import "QiDongViewController.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AppDelegate ()

@property NSMutableArray *array;//购物车中商品

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *str = @"yes";
    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"first.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        str = @"no";
    }

    
    if ([str isEqualToString:@"yes"]) {
        QiDongViewController *qidong = [[QiDongViewController alloc]init];
        self.window.rootViewController = qidong;
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSLog(@"%@",path);
        NSString *pat = [path stringByAppendingPathComponent:@"first.plist"];
        [NSKeyedArchiver    archiveRootObject:str toFile:pat];
        
        return YES;
    }
    
    
    
    
    
    UITabBarController *tableBarC = [[UITabBarController alloc] init];
    
    FirstViewController *firstViewC = [[FirstViewController alloc] init];
    GroupViewController *groupViewC = [[GroupViewController alloc] init];
    UINavigationController *firstNC = [[UINavigationController alloc]initWithRootViewController:firstViewC];
    UINavigationController *groupNC = [[UINavigationController alloc]initWithRootViewController:groupViewC];
    
    MyInforViewController *myInforViewC = [[MyInforViewController alloc]init];
    BuyCarViewController *buyCarViewC = [[BuyCarViewController alloc] init];
    
    //UINavigationController *myInforNC=[[UINavigationController   alloc] initWithRootViewController:myInforViewC];
    UINavigationController *buyCarNC=[[UINavigationController    alloc] initWithRootViewController:buyCarViewC];
    
    tableBarC.viewControllers = @[firstNC,groupNC,buyCarNC,myInforViewC];
    
    self.window.rootViewController = tableBarC;
    
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
    
   
    return YES;
     
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

@end
