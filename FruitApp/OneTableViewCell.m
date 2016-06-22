//
//  OneTableViewCell.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "OneTableViewCell.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define FirstGao 250

@implementation OneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  // self.button.backgroundColor = [UIColor brownColor];
    self.image.frame = CGRectMake(0, 0, ScreenW-100, FirstGao);
    self.button.frame = CGRectMake(0, 0, ScreenW, FirstGao);
    self.name.frame = CGRectMake(0, 0, ScreenW-5, 25);
    self.price.frame = CGRectMake(0, 30, ScreenW-50, 25);
    
}


@end
