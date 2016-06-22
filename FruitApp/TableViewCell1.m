//
//  TableViewCell1.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TableViewCell1.h"
#import "Fruit.h"

@implementation TableViewCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark 重写init方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.gName=[[UILabel alloc] init];
    [self.contentView   addSubview:self.gName];
    self.gName.numberOfLines=0;
    self.gName.textAlignment=NSTextAlignmentCenter;
    //self.gName.textColor=[UIColor   blackColor];
    self.gName.font = [UIFont systemFontOfSize:14];
    
    return self;
}


#pragma mark 加载cell上的数据
-(void)freshData:(NSString *)kind{
    self.gName.text=kind;
}

@end
