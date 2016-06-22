//
//  ATableViewCell.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ATableViewCell.h"
#import "Address.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@implementation ATableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenW-10, 30)];
        [self.contentView addSubview:self.nameLab];
//        self.nameLab.text = @"收件人：侯运红";
        self.phoneLab.font = [UIFont systemFontOfSize:14];
        
        self.phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 37, ScreenW-10, 20)];
        [self.contentView addSubview:self.phoneLab];
//        self.phoneLab.text = @"电话：13456788909";
        self.phoneLab.font = [UIFont systemFontOfSize:13];
        
        self.addressLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.addressLab];
        self.addressLab.font = [UIFont systemFontOfSize:13];
        self.addressLab.numberOfLines = 0;
        
    }
    return self;
}

- (CGFloat)setData:(Address *)address
{
    self.nameLab.text = [NSString stringWithFormat:@"%@%@",@"收件人:",address.shoujianren];
    self.phoneLab.text = [NSString stringWithFormat:@"%@%@",@"电话:",address.dianhua];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",@"地址:",address.dizhi];
    
    CGSize size = CGSizeMake(ScreenW-20, MAXFLOAT);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    
    CGRect rect = [self.addressLab.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    self.addressLab.frame = CGRectMake(10, 59, ScreenW-20, rect.size.height);
    
    return 59+rect.size.height;
    
    
    
    return 0;
}

@end
