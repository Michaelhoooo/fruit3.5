//
//  FruitInforViewController.m
//  FruitApp
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "FruitInforViewController.h"
#import "Fruit.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

//#define ScreenW [UIScreen mainScreen].bounds.size.width
//#define ScreenH [UIScreen mainScreen].bounds.size.height
//
//#define ImageGao (250/667.0*ScreenH)
//#define View1Gao (120/667.0*ScreenH)
//#define View2Gao (80/667.0*ScreenH)
//
//#define BiLi (ScreenH/667.0)

@interface FruitInforViewController ()

@property Fruit *fr;
@property NSMutableArray *array;
@property NSMutableArray *array1;//购物车中商品

@end

@implementation FruitInforViewController
{
    UIImageView *image;
    UIView *view1,*view2,*view3;
    UILabel *nameLab,*xiaoShouLab,*countLab,*moneyLab,*pingJiaLab,*goodLab,*miaoShuLab;
    UIButton *jiaBut,*jianBut,*gouWuBut;
    UIProgressView *progress;
    

}

- (void)viewDidLoad {
    
    self.navigationItem.title = @"商品详情";
    
    
    _fr = [[Fruit alloc]init];
    _array = [NSMutableArray array];
   
    
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *img=[[UIImageView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-104)];
    [self.view  addSubview:img];
    img.image=[UIImage  imageNamed:@"23.jpg"];
    img.alpha=0.15;
    [super viewDidLoad];
    [self addView];//添加View
    [self setData];//数据加载
}

#pragma mark 添加View
- (void)addView
{
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, ImageGao)];
    [self.view addSubview:image];
//    image.contentMode = UIViewContentModeScaleAspectFit;
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, ImageGao+66, self.view.frame.size.width, View1Gao)];
    [self.view addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20*BiLi, self.view.frame.size.width-20, 30*BiLi)];
    nameLab.font = [UIFont systemFontOfSize:18*BiLi];
    xiaoShouLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*BiLi, self.view.frame.size.width-20, 20*BiLi)];
    xiaoShouLab.textColor = [UIColor grayColor];
    xiaoShouLab.font = [UIFont systemFontOfSize:12];
    moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 85*BiLi, 150, 30*BiLi)];
    
    moneyLab.textColor = [UIColor redColor];
    moneyLab.font = [UIFont systemFontOfSize:15*BiLi];
    gouWuBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-110, 85*BiLi, 100, 30*BiLi)];
    [gouWuBut setTitle:@"加入购物车" forState:UIControlStateNormal];
    gouWuBut.titleLabel.font = [UIFont systemFontOfSize:14*BiLi];
    gouWuBut.backgroundColor = [UIColor redColor];
    gouWuBut.layer.cornerRadius = 5*BiLi;
    gouWuBut.layer.masksToBounds = YES;
    gouWuBut.tag = 1;
    [gouWuBut addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    jiaBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 85*BiLi, 30*BiLi, 30*BiLi)];
    jiaBut.layer.borderWidth = 1;
    jiaBut.layer.borderColor = [UIColor grayColor].CGColor;
    jiaBut.layer.cornerRadius = 15*BiLi;
    jiaBut.layer.masksToBounds = YES;
    
    [jiaBut setBackgroundImage:[UIImage imageNamed:@"add.jpeg"] forState:UIControlStateNormal];
    countLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 85*BiLi, 30, 30*BiLi)];
   
    countLab.textAlignment = NSTextAlignmentCenter;
    jianBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 85*BiLi, 30*BiLi, 30*BiLi)];
    [jianBut setBackgroundImage:[UIImage imageNamed:@"jian.jpeg"] forState:UIControlStateNormal];
    jianBut.layer.borderWidth = 1;
    jianBut.layer.borderColor = [UIColor grayColor].CGColor;
    jianBut.layer.cornerRadius = 15*BiLi;
    jianBut.layer.masksToBounds = YES;
   
    jianBut.tag = 3;
    jiaBut.tag = 2;
    [jianBut addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    [jiaBut addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.fruit.num) {
        jiaBut.hidden = YES;
        jianBut.hidden = YES;
        countLab.hidden = YES;
        gouWuBut.hidden = NO;
    }else{
        jiaBut.hidden = NO;
        jianBut.hidden = NO;
        countLab.hidden = NO;
        gouWuBut.hidden = YES;
        countLab.text = self.fruit.num;
    }
    
    
    [view1 addSubview:nameLab];
    [view1 addSubview:xiaoShouLab];
    [view1 addSubview:moneyLab];
    [view1 addSubview:gouWuBut];
    [view1 addSubview:jiaBut];
    [view1 addSubview:jianBut];
    [view1 addSubview:countLab];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, View1Gao+ImageGao+68, self.view.frame.size.width, View2Gao)];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor whiteColor];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10*BiLi, 70*BiLi, 30*BiLi)];
    lab1.text = @"商品评价:";
    lab1.font = [UIFont systemFontOfSize:15*BiLi];
    pingJiaLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 10*BiLi, self.view.frame.size.width-90, 30*BiLi)];
    pingJiaLab.textColor = [UIColor grayColor];
    pingJiaLab.font = [UIFont systemFontOfSize:12*BiLi];
    
    progress = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 50*BiLi, self.view.frame.size.width-100, 20)];
    progress.trackTintColor = [UIColor brownColor];
    progress.progressTintColor = [UIColor redColor];
    
    goodLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 50*BiLi, 80, 20*BiLi)];
    
    goodLab.textColor = [UIColor redColor];
    goodLab.font = [UIFont systemFontOfSize:12*BiLi];
    [view2 addSubview:lab1];
    [view2 addSubview:pingJiaLab];
    [view2 addSubview:progress];
    [view2 addSubview:goodLab];
    
    view3 = [[UIView alloc]initWithFrame:CGRectMake(0, ImageGao+View2Gao+View1Gao+70, self.view.frame.size.width, self.view.frame.size.height-(ImageGao+View2Gao+View1Gao+116))];
    [self.view addSubview:view3];
    view3.backgroundColor = [UIColor whiteColor];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10*BiLi, self.view.frame.size.width-20, 30*BiLi)];
    lab2.text = @"商品描述:";
    lab2.font = [UIFont systemFontOfSize:15*BiLi];
    miaoShuLab = [[UILabel alloc]init];
    
    miaoShuLab.numberOfLines = 0;
    miaoShuLab.textColor = [UIColor grayColor];
    miaoShuLab.font = [UIFont systemFontOfSize:12*BiLi];
    [view3 addSubview:lab2];
    [view3 addSubview:miaoShuLab];
    
}

#pragma mark 界面刚出现时
- (void)viewWillAppear:(BOOL)animated
{
    BOOL have=NO;
    _array1 = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _array1 =[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        //[NSKeyedArchiver    archiveRootObject:_array1 toFile:pat];
    }else{
        _array1=nil;
    }
    
    for (Fruit *fruit in _array1) {
        if ([fruit.name isEqualToString:self.fruit.name]) {
            countLab.text = fruit.num;
            have=YES;
        }
    }
    if (!countLab.text||(have==NO)) {
        jiaBut.hidden = YES;
        jianBut.hidden = YES;
        countLab.hidden = YES;
        gouWuBut.hidden = NO;
    }else{
        jiaBut.hidden = NO;
        jianBut.hidden = NO;
        countLab.hidden = NO;
        gouWuBut.hidden = YES;
    }
}




#pragma mark button点击事件
-(void)clickBut:(UIButton *)but
{
    if (but.tag == 1)//加入购物车
    {
        gouWuBut.hidden = YES;
        jiaBut.hidden = NO;
        jianBut.hidden = NO;
        countLab.hidden = NO;
        countLab.text = @"1";
        [self jia];

    }else if (but.tag == 2)//加
    {
        int b = [countLab.text intValue];
        b++;
        countLab.text = [NSString stringWithFormat:@"%d",b];

      [self jia];
    
    }else//减
    {
        int b = [countLab.text intValue];
        b--;
        if (b==0)
        {
            gouWuBut.hidden = NO;
            jiaBut.hidden = YES;
            jianBut.hidden = YES;
            countLab.text=[NSString stringWithFormat:@"%i",0];
            countLab.hidden = YES;
        }else
        {
            countLab.text = [NSString stringWithFormat:@"%d",b];
        }
        [self jian];
    }
}

-(void)jia
{
    _fr.name=nameLab.text;
    _fr.price=moneyLab.text;
    _fr.saled=xiaoShouLab.text;
    _fr.goodCom=goodLab.text;
    _fr.num=countLab.text;
    _fr.imgUrl = self.fruit.imgUrl;
    _fr.imgUrl2 = self.fruit.imgUrl2;

    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
//    NSLog(@"%@",pat);
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        int i=0;
        int j=0;
        for (Fruit *tmp in _array) {
            if ([_fr.name isEqualToString:tmp.name]) {
                j++;
                break;
            }
            i++;
        }
        if (j==0) {
            [_array addObject:_fr];
        }else{
            [_array replaceObjectAtIndex:i withObject:_fr];
        }
    }else{
        [_array addObject:_fr];
    }
    [NSKeyedArchiver    archiveRootObject:_array toFile:pat];
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"aaa" object:nil];
    
    int num;
    NSString *numStr = [self .tabBarController childViewControllers][2].tabBarItem.badgeValue;
    if (!numStr) {
        num = 0;
    }
    else{
        num = [numStr intValue];
    }
    [self .tabBarController childViewControllers][2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num+1];

}

- (void)jian
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"buyCar.plist"];
    _array=[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
    _fr.name=nameLab.text;
    _fr.price=moneyLab.text;
    _fr.saled=xiaoShouLab.text;
    _fr.goodCom=goodLab.text;
    _fr.num=countLab.text;
    _fr.imgUrl = self.fruit.imgUrl;
    _fr.imgUrl2 = self.fruit.imgUrl2;
    int i=0;
    for (Fruit *tmp in _array) {
        if ([_fr.name isEqualToString:tmp.name]) {
            break;
        }
        i++;
    }
    [_array replaceObjectAtIndex:i withObject:_fr];
    
    if ([_fr.num intValue]==0) {
        [_array removeObjectAtIndex:i];
    }
   
    [NSKeyedArchiver    archiveRootObject:_array toFile:pat];
    //添加通知中心
    [[NSNotificationCenter   defaultCenter] postNotificationName:@"bbb" object:nil];
    NSString *numStr = [self .tabBarController childViewControllers][2].tabBarItem.badgeValue;
    int num = [numStr intValue];
    if (num >1) {
        [self .tabBarController childViewControllers][2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",num-1];
    }else{
        [self .tabBarController childViewControllers][2].tabBarItem.badgeValue= nil;
    }
    
}




#pragma mark 加载数据
- (void)setData
{
    NSURL *url = [NSURL URLWithString:self.fruit.imgUrl2];
    [image sd_setImageWithURL:url placeholderImage:nil];
    
    nameLab.text = self.fruit.name;
    xiaoShouLab.text = [NSString stringWithFormat:@"月售%@份",self.fruit.saled ];
    moneyLab.text = [NSString stringWithFormat:@"¥%@",self.fruit.price];
    if (!self.fruit.pingjia) {
        self.fruit.pingjia=@"0";
    }
    pingJiaLab.text = [NSString stringWithFormat:@"共%@人评价",self.fruit.pingjia ];
    NSString *num1 = self.fruit.pingjia;
    NSString *num2 = self.fruit.goodCom;
    int a1 = [num1 intValue];
    int a2 = [num2 intValue];
    if (a1 == 0) {
        goodLab.text = @"暂时无人评价";
        progress.progress = 0;
    }
    else{
        float b = a2*1.0/a1;
        goodLab.text = [NSString stringWithFormat:@"好评率%2.0f%@",b*100,@"%"];
        progress.progress = b;
    }
    
    miaoShuLab.text = self.fruit.des;
    CGSize size = CGSizeMake(self.view.frame.size.width-20, MAXFLOAT);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12*BiLi],NSFontAttributeName, nil];
    CGRect rect = [miaoShuLab.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    miaoShuLab.frame = CGRectMake(20, 40*BiLi, self.view.frame.size.width-20, rect.size.height);
}

@end
