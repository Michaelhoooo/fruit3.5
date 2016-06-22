//
//  TwoTableViewCell.m
//  FruitApp
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TwoTableViewCell.h"
#define IMageGao 140
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height




@implementation TwoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, (ScreenW - 3)*0.5, IMageGao)];
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW - 3)*0.5, 1, (ScreenW - 3)*0.5, IMageGao)];
        self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
        self.rightImage.contentMode = UIViewContentModeScaleAspectFit;
        self.leftImage.layer.borderColor = [UIColor grayColor].CGColor;
        self.leftImage.layer.borderWidth = 1;

        
        self.rightImage.layer.borderColor = [UIColor grayColor].CGColor;
        self.rightImage.layer.borderWidth = 1;

        
        self.leftBut = [[UIButton alloc]init];
        self.rightBut = [[UIButton alloc]init];
        self.leftBut.frame = CGRectMake(0, 0, (ScreenW )*0.5, IMageGao+50);
        self.rightBut.frame = CGRectMake((ScreenW - 3)*0.5, 1, (ScreenW - 3)*0.5, IMageGao+50);
        self.leftName = [[UILabel alloc] initWithFrame:CGRectMake(0, IMageGao, (ScreenW - 3)*0.5, 25)];
        self.leftName.font = [UIFont systemFontOfSize:12];
        self.leftName.textAlignment = NSTextAlignmentRight;
        self.leftPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, IMageGao+25, (ScreenW- 3)*0.5, 25)];
        self.leftPrice.textColor = [UIColor redColor];
        self.leftPrice.font = [UIFont systemFontOfSize:14];
        self.leftPrice.textAlignment = NSTextAlignmentRight;
        
        
        
        self.rightName = [[UILabel alloc]initWithFrame:CGRectMake((ScreenW - 3)*0.5+2, IMageGao, (ScreenW - 3)*0.5, 25)];
        
        self.rightName.font = [UIFont systemFontOfSize:12];
        self.rightName.textAlignment = NSTextAlignmentRight;
        self.rightPrice = [[UILabel alloc]initWithFrame:CGRectMake((ScreenW - 3)*0.5+2, IMageGao+25, (ScreenW - 3)*0.5, 25)];
       
        self.rightPrice.textColor = [UIColor redColor];
        self.rightPrice.font = [UIFont systemFontOfSize:14];
        self.rightPrice.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.rightName];
        [self.contentView addSubview:self.leftName];
        [self.contentView addSubview:self.rightImage];
        [self.contentView addSubview:self.leftImage];
        [self.contentView addSubview:self.leftBut];
        [self.contentView addSubview:self.rightBut];
        [self.contentView addSubview:self.leftPrice];
        [self.contentView addSubview:self.rightPrice];
    }
    return self;
}

@end
