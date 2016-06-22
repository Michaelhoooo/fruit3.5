//
//  TableViewCell2.h
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fruit.h"
#import "BuyCarViewController.h"



@interface TableViewCell2 : UITableViewCell<NSCoding>

@property UIImageView *img;
@property UILabel *lab1;
@property UILabel *lab2;
@property UILabel *lab3;
@property UILabel *lab4;
@property UIButton *btn1;
@property UILabel *lab5;
@property UIButton *btn2;

@property NSDictionary *dic;
@property NSMutableArray *array;

@property NSMutableDictionary *dicA;
@property NSMutableArray *arrayG;
@property NSArray *keyArr;
@property NSString *str;

@property Fruit *fr;

-(void)freshData:(Fruit *)tmp;

//-(void)encodeWithCoder:(NSCoder *)aCoder;
//-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
