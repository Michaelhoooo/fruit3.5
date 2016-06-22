//
//  TableViewCell.m
//  FruitApp
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TableViewCell.h"
#import "Fruit.h"
#import "FruitInforViewController.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.img=[[UIImageView   alloc] initWithFrame:CGRectMake(20, 10, ScreenW/4, ScreenW/4)];
    [self.img.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.img.layer setBorderWidth:1];
    [self.contentView   addSubview:self.img];
    self.lab1=[[UILabel  alloc] initWithFrame:CGRectMake(self.img.frame.size.width+30, 10, ScreenW*3/4-30, 20)];
    //self.lab1.backgroundColor=[UIColor  blueColor];
    self.lab1.textAlignment=NSTextAlignmentLeft;
    [self.contentView   addSubview:self.lab1];
    self.lab2=[[UILabel  alloc] initWithFrame:CGRectMake(self.img.frame.size.width+30, 35, ScreenW*3/4-30, 15)];
    //self.lab2.backgroundColor=[UIColor  yellowColor];
    self.lab2.textAlignment=NSTextAlignmentLeft;
    self.lab2.textColor=[UIColor    grayColor];
    self.lab2.font=[UIFont  systemFontOfSize:15];
    [self.contentView   addSubview:self.lab2];
    self.lab3=[[UILabel  alloc] initWithFrame:CGRectMake(self.img.frame.size.width+30, 55, ScreenW*3/4-30, 15)];
    //self.lab3.backgroundColor=[UIColor  brownColor];
    self.lab3.textAlignment=NSTextAlignmentLeft;
    self.lab3.textColor=[UIColor    grayColor];
    self.lab3.font=[UIFont  systemFontOfSize:15];
    [self.contentView   addSubview:self.lab3];
    self.lab4=[[UILabel  alloc] initWithFrame:CGRectMake(self.img.frame.size.width+30, 75, ScreenW*3/4-30, 20)];
    //self.lab4.backgroundColor=[UIColor  orangeColor];
    self.lab4.textColor=[UIColor    redColor];
    self.lab4.textAlignment=NSTextAlignmentLeft;
    [self.contentView   addSubview:self.lab4];
    self.lab5=[[UILabel  alloc] initWithFrame:CGRectMake(self.btn1.frame.origin.x-30, 100, 30, 30)];
    [self.contentView   addSubview:self.lab5];
    //self.lab5.text=[NSString    stringWithFormat:@"%i",0];
    self.lab5.textAlignment=NSTextAlignmentCenter;
    self.lab5.hidden=NO;
    self.lab5.textColor=[UIColor    blackColor];
    
    self.btn1=[[UIButton alloc] initWithFrame:CGRectMake(ScreenW*3/4, 100, 30, 30)];
    [self.contentView   addSubview:self.btn1];
//    self.btn1.layer.cornerRadius=15;
//    self.btn1.layer.masksToBounds=YES;
    self.btn1.layer.borderColor=[UIColor    grayColor].CGColor;
    self.btn1.layer.borderWidth=0.5;
    [self.btn1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btn2=[[UIButton alloc] initWithFrame:CGRectMake(self.btn1.frame.origin.x-60, 100, 30, 30)];
    [self.contentView   addSubview:self.btn2];
//    self.btn2.layer.cornerRadius=15;
//    self.btn2.layer.masksToBounds=YES;
    self.btn2.layer.borderColor=[UIColor    grayColor].CGColor;
    self.btn2.layer.borderWidth=0.5;
    [self.btn2  setBackgroundImage:[UIImage imageNamed:@"jian.jpeg"] forState:UIControlStateNormal];
    self.btn2.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.btn2  addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
    self.btn2.hidden=NO;
    
    self.btn3=[[UIButton alloc] initWithFrame:CGRectMake(ScreenW*7/8, 52.5, 30, 30)];
    [self.contentView   addSubview:self.btn3];
    self.btn3.layer.cornerRadius=15;
    self.btn3.layer.masksToBounds=YES;
    self.btn3.layer.borderColor=[UIColor    grayColor].CGColor;
    self.btn3.layer.borderWidth=1;
    self.btn3.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.btn3  addTarget:self action:@selector(choise) forControlEvents:UIControlEventTouchUpInside];
    
    self.lab5=[[UILabel  alloc] initWithFrame:CGRectMake(self.btn1.frame.origin.x-30, 100, 30, 30)];
    [self.contentView   addSubview:self.lab5];
    self.lab5.layer.borderColor=[UIColor    grayColor].CGColor;
    self.lab5.layer.borderWidth=0.5;
    self.lab5.textAlignment=NSTextAlignmentCenter;
    self.lab5.hidden=NO;
    self.lab5.textColor=[UIColor    blackColor];
    
    _arrayB=[[NSMutableArray  alloc] init];
    _fr=[[Fruit  alloc] init];
    return self;
}


#pragma mark 加号方法
-(void)add:(UIButton *)btn{
    self.btn2.hidden=NO;
    self.lab5.hidden=NO;
    self.lab5.text=[NSString    stringWithFormat:@"%i",[self.lab5.text intValue]+1];
    _fr.name=self.lab1.text;
    _fr.price=self.lab4.text;
    _fr.saled=self.lab2.text;
    _fr.goodCom=self.lab3.text;
    _fr.num=self.lab5.text;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _arrayB=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    
    int i=0;
    for (Fruit *tmp in _arrayB) {
        if ([_fr.name isEqualToString:tmp.name]) {
            _fr.isChoised=tmp.isChoised;
            _fr.imgUrl=tmp.imgUrl;
            break;
        }
        i++;
    }
    [_arrayB replaceObjectAtIndex:i withObject:_fr];

    
    [NSKeyedArchiver    archiveRootObject:_arrayB toFile:pat];
    
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"aaa" object:nil];
}


#pragma mark 减号方法
-(void)jian{
    self.lab5.text=[NSString    stringWithFormat:@"%i",[self.lab5.text  intValue]-1];
    _fr.name=self.lab1.text;
    _fr.price=self.lab4.text;
    _fr.saled=self.lab2.text;
    _fr.goodCom=self.lab3.text;
    _fr.num=self.lab5.text;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _arrayB=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    
    int i=0;
    for (Fruit *tmp in _arrayB) {
        if ([_fr.name isEqualToString:tmp.name]) {
            _fr.isChoised=tmp.isChoised;
            _fr.imgUrl=tmp.imgUrl;
            break;
        }
        i++;
    }
    [_arrayB replaceObjectAtIndex:i withObject:_fr];
    
    if ([self.lab5.text isEqualToString:@"0"]) {
        [_arrayB    removeObjectAtIndex:i];
    }
    
    [NSKeyedArchiver    archiveRootObject:_arrayB toFile:pat];
    
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"bbb" object:nil];
}


#pragma mark 选中按钮方法
-(void)choise{
    _fr.name=self.lab1.text;
    _fr.price=self.lab4.text;
    _fr.saled=self.lab2.text;
    _fr.goodCom=self.lab3.text;
    _fr.num=self.lab5.text;
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _arrayB=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    int j=0;
    for (Fruit *tmp in _arrayB) {
        if ([_fr.name isEqualToString:tmp.name]) {
            _fr.imgUrl=tmp.imgUrl;
            _fr.isChoised=tmp.isChoised;
            break;
        }
        j++;
    }
    if ([_fr.isChoised isEqualToString:@"no"]||_fr.isChoised==nil) {
        _fr.isChoised=@"yes";
    }else{
        _fr.isChoised=@"no";
    }
    [_arrayB    replaceObjectAtIndex:j withObject:_fr];
    [NSKeyedArchiver    archiveRootObject:_arrayB toFile:pat];
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"ccc" object:nil];
}

@end
