//
//  ATableViewCell.h
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Address;

@interface ATableViewCell : UITableViewCell

@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UILabel *phoneLab;
@property (strong, nonatomic)UILabel *addressLab;

- (CGFloat)setData:(Address *)address;

@end


