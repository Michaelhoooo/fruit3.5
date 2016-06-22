//
//  FruitInforViewController.h
//  FruitApp
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define ImageGao (250/667.0*ScreenH)
#define View1Gao (120/667.0*ScreenH)
#define View2Gao (80/667.0*ScreenH)

#define BiLi (ScreenH/667.0)

@class Fruit;

@interface FruitInforViewController : UIViewController<NSCoding>

@property (strong, nonatomic)Fruit *fruit;

@end
