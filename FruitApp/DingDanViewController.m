//
//  DingDanViewController.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DingDanViewController.h"
#import "TableViewCell.h"
#import "User.h"
#import "Fruit.h"
#import "UIImageView+WebCache.h"
#import "ListViewController.h"

@interface DingDanViewController ()<UITableViewDataSource,UITableViewDelegate>

@property UITableView *tab;

@property NSMutableArray *b;

@end

@implementation DingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self   setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.user=[[User alloc] init];
    }
    return self;
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 设置tableview
-(void)setTableView{
    UIView *vi=[[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    vi.backgroundColor=[UIColor orangeColor];
    UILabel *lab=[[UILabel   alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 0, 80, 60)];
    [vi addSubview:lab];
    lab.text=@"我的订单";
    lab.font=[UIFont    systemFontOfSize:20];
    [self.view  addSubview:vi];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 30, 30)];
    [vi addSubview:btn];
    [btn    setBackgroundImage:[UIImage imageNamed:@"miss.png"] forState:UIControlStateNormal];
    [btn    addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *v=[[UIView   alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    [self.view  addSubview:v];
    _tab=[[UITableView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, v.frame.size.height) style:UITableViewStyleGrouped];
    _tab.delegate=self;
    _tab.dataSource=self;
    [v  addSubview:_tab];
}

-(void)miss{
    [self   dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 数据源方法和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.user.listArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *a=self.user.listArrM[self.user.listArrM.count-section-1];
    return a.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"bnm";
    TableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil) {
        cell=[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    NSArray *a=self.user.listArrM[self.user.listArrM.count-indexPath.section-1];
    Fruit *fr=a[indexPath.row];
    cell.lab1.text=fr.name;
    cell.lab2.text=fr.saled;
    cell.lab3.text=fr.goodCom;
    cell.lab4.text=fr.price;
    cell.lab5.text=fr.num;
    [cell.img sd_setImageWithURL:[NSURL   URLWithString:fr.imgUrl] placeholderImage:nil];
    cell.btn1.hidden=YES;
    cell.btn2.hidden=YES;
    cell.btn3.hidden=YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView   alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    UILabel *lab=[[UILabel   alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [v  addSubview:lab];
    NSArray *a=self.user.listArrM;
    lab.text=[NSString  stringWithFormat:@"订单%li",self.user.listArrM.count-section];
    
    _b=[[NSMutableArray  alloc] init];
    _b=a[self.user.listArrM.count-section-1];
    Fruit *fr=_b[0];
    if (![fr.isChoised isEqualToString:@"payed"]) {
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(70, 0, 80, 20)];
        [v  addSubview:btn];
        [btn    setBackgroundColor:[UIColor grayColor]];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn    setTitle:@":待付款" forState:UIControlStateNormal];
        btn.tag=self.user.listArrM.count-section-1;
        [btn    addTarget:self action:@selector(fun:) forControlEvents:UIControlEventTouchUpInside];
    }
    return v;
}

-(void)fun:(UIButton *)btn{
    ListViewController *lvc=[[ListViewController alloc] init];
    lvc.listArr=[[NSMutableArray alloc] init];
    NSArray *a=self.user.listArrM;
    NSMutableArray *b=[[NSMutableArray   alloc] init];
    b=a[btn.tag];
    lvc.listArr=b;
    lvc.i=(int)btn.tag+1;
    [self   presentViewController:lvc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    NSMutableArray *userArrM = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
//    NSLog(@"%@",pat);
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        userArrM =[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        [NSKeyedArchiver    archiveRootObject:userArrM toFile:pat];
    }/*else{
        userArrM=nil;
    }*/
    self.user=[userArrM lastObject];
    [_tab   reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
