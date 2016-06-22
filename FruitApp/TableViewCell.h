//
//  TableViewCell.h
//  FruitApp
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fruit.h"

@interface TableViewCell : UITableViewCell<NSCoding>

@property UIImageView *img;
@property UILabel *lab1;
@property UILabel *lab2;
@property UILabel *lab3;
@property UILabel *lab4;
@property UIButton *btn1;
@property UILabel *lab5;
@property UIButton *btn2;
@property UIButton *btn3;


@property NSDictionary *dicB;
@property NSMutableArray *arrayB;


@property Fruit *fr;
@end
