//
//  TableViewCell2.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TableViewCell2.h"
#import "Fruit.h"
#import "UIImageView+WebCache.h"
#import "BuyCarViewController.h"
#import "FruitInforViewController.h"
#import "AFHTTPRequestOperationManager.h"


@implementation TableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.img=[[UIImageView   alloc] initWithFrame:CGRectMake(10, 10, ScreenW/5, ScreenW/5)];
    [self.img.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.img.layer setBorderWidth:1];
    [self.contentView   addSubview:self.img];
    self.lab1=[[UILabel  alloc] initWithFrame:CGRectMake(ScreenW/5+20, 10, ScreenW/2, 20)];
    //self.lab1.backgroundColor=[UIColor  blueColor];
    self.lab1.textAlignment=NSTextAlignmentLeft;
    [self.contentView   addSubview:self.lab1];
    self.lab2=[[UILabel  alloc] initWithFrame:CGRectMake(ScreenW/5+20, 35, ScreenW/2, 15)];
    //self.lab2.backgroundColor=[UIColor  yellowColor];
    self.lab2.textAlignment=NSTextAlignmentLeft;
    self.lab2.textColor=[UIColor    grayColor];
    [self.contentView   addSubview:self.lab2];
    self.lab3=[[UILabel  alloc] initWithFrame:CGRectMake(ScreenW/5+20, 55, ScreenW/2, 15)];
    //self.lab3.backgroundColor=[UIColor  brownColor];
    self.lab3.textAlignment=NSTextAlignmentLeft;
    self.lab3.textColor=[UIColor    grayColor];
    [self.contentView   addSubview:self.lab3];
    self.lab4=[[UILabel  alloc] initWithFrame:CGRectMake(ScreenW/5+20, 75, ScreenW/2, 20)];
    //self.lab4.backgroundColor=[UIColor  orangeColor];
    self.lab4.textColor=[UIColor    redColor];
    self.lab4.textAlignment=NSTextAlignmentLeft;
    [self.contentView   addSubview:self.lab4];
    self.btn1=[[UIButton alloc] initWithFrame:CGRectMake(ScreenW*3/4-50, 100, 30, 30)];
    [self.contentView   addSubview:self.btn1];
    self.btn1.layer.cornerRadius=15;
    self.btn1.layer.masksToBounds=YES;
    self.btn1.layer.borderColor=[UIColor    grayColor].CGColor;
    self.btn1.layer.borderWidth=0.5;
    [self.btn1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn2=[[UIButton alloc] initWithFrame:CGRectMake(self.btn1.frame.origin.x-60, 100, 30, 30)];
    [self.contentView   addSubview:self.btn2];
    self.btn2.layer.cornerRadius=15;
    self.btn2.layer.masksToBounds=YES;
    self.btn2.layer.borderColor=[UIColor    grayColor].CGColor;
    self.btn2.layer.borderWidth=0.5;
    [self.btn2  setBackgroundImage:[UIImage imageNamed:@"jian.jpeg"] forState:UIControlStateNormal];
    self.btn2.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.btn2  addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
//    self.btn2.hidden=YES;
    
    
    self.lab5=[[UILabel  alloc] initWithFrame:CGRectMake(self.btn1.frame.origin.x-30, 100, 30, 30)];
    [self.contentView   addSubview:self.lab5];
//    self.lab5.layer.cornerRadius=15;
//    self.lab5.layer.masksToBounds=YES;
//    self.lab5.layer.borderColor=[UIColor    grayColor].CGColor;
//    self.lab5.layer.borderWidth=0.5;
    self.lab5.text=[NSString    stringWithFormat:@"%i",0];
    self.lab5.textAlignment=NSTextAlignmentCenter;
//    self.lab5.hidden=YES;
    self.lab5.textColor=[UIColor    blackColor];
    
    _array=[[NSMutableArray  alloc] init];
    _fr=[[Fruit    alloc] init];
    return self;
}




#pragma mark 加载cell上的数据
-(void)freshData:(Fruit *)tmp{
    self.lab1.text=tmp.name;
    self.lab2.text=[NSString stringWithFormat:@"月售:%@",tmp.saled];
    self.lab3.text=[NSString    stringWithFormat:@"好评:%@",tmp.goodCom];
    self.lab4.text=[NSString    stringWithFormat:@"¥%@",tmp.price];
    [self.img   sd_setImageWithURL:[NSURL URLWithString:tmp.imgUrl] placeholderImage:nil];
    _fr.imgUrl=tmp.imgUrl;
    self.img.contentMode=UIViewContentModeScaleAspectFit;
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"add.jpeg"] forState:UIControlStateNormal];
}

#pragma mark 加号按钮点击事件
-(void)add:(UIButton *)btn{
    self.btn2.hidden=NO;
    self.lab5.hidden=NO;
    self.lab5.text=[NSString    stringWithFormat:@"%i",[self.lab5.text intValue]+1];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
//    NSLog(@"%@",pat);
    NSFileManager *fm=[NSFileManager    defaultManager];
    NSMutableArray *array =[[NSMutableArray  alloc] init];
//    array=[NSKeyedUnarchiver    unarchiveObjectWithFile:pat];
    _fr.name=self.lab1.text;
    _fr.price=[self.lab4.text substringFromIndex:1];
    _fr.saled=self.lab2.text;
    _fr.goodCom=self.lab3.text;
    _fr.num=self.lab5.text;
    for (NSString *tmp1 in _keyArr) {
        NSArray *arr=[_dicA objectForKey:tmp1];
        for (Fruit *tmp2 in arr) {
            if ([tmp2.name isEqualToString:self.lab1.text]) {
                _fr.des=tmp2.des;
                _fr.imgUrl=tmp2.imgUrl;
                _fr.imgUrl2=tmp2.imgUrl2;
                _fr.pingjia=tmp2.pingjia;
                break;
            }
        }
    }
    
    
    if([fm  fileExistsAtPath:pat]==YES){
    array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    int i=0;
    int j=0;
    for (Fruit *tmp in array) {
        if ([_fr.name isEqualToString:tmp.name]) {
            j++;
            break;
        }
        i++;
    }
    if (j==0) {
        [array addObject:_fr];
        
    }else{
        [array replaceObjectAtIndex:i withObject:_fr];
    }
    }else{
        [array addObject:_fr];
       
    }
    [NSKeyedArchiver    archiveRootObject:array toFile:pat];
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"aaa" object:nil];
}


#pragma mark 减号按钮点击事件
-(void)jian{
    self.lab5.text=[NSString    stringWithFormat:@"%i",[self.lab5.text  intValue]-1];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    _fr.name=self.lab1.text;
    _fr.price=[self.lab4.text substringFromIndex:1];
    _fr.saled=self.lab2.text;
    _fr.goodCom=self.lab3.text;
    _fr.num=self.lab5.text;
    int i=0;
    for (Fruit *tmp in _array) {
        if ([_fr.name isEqualToString:tmp.name]) {
            break;
        }
         i++;
    }
    [_array replaceObjectAtIndex:i withObject:_fr];
    if ([_fr.num intValue]==0) {
        self.lab5.hidden=YES;
        self.btn2.hidden=YES;
        [_array removeObjectAtIndex:i];
    }
    [NSKeyedArchiver    archiveRootObject:_array toFile:pat];
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"bbb" object:nil];
    
}



@end
