//
//  MyInforViewController.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyInforViewController.h"
#import "LoadViewController.h"
#import "User.h"
#import "AddressViewController.h"
#import "DingDanViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface MyInforViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>

@property NSMutableArray *userArrM;

@end

@implementation MyInforViewController
{
    UIImageView *PhotoImageView;//头像
    UIButton *nameBut;//用户名／登录／注册按钮
    NSArray *arr;//存放cell显示的名字
    UIButton *changeBut;//切换登录
    User *user;
    UIImagePickerController *picker;
    NSArray *imageArr;//存放cell显示的名字

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    arr = @[@"收货地址",@"我的订单",@"客服电话",@"常见问题",@"邀请好友"];
    imageArr = @[@"41.png",@"42.png",@"43.png",@"44.png",@"45.png"];
    
    [self addView];//添加界面
    
    
}


#pragma mark 界面建立
- (void)addView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,ScreenW*0.5)];
    view.backgroundColor = [UIColor orangeColor];
    view.alpha = 0.6;
    [self.view addSubview: view];
    
    PhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenW-100*ScreenW/375)*0.5, 35*ScreenW/375, 100*ScreenW/375, 100*ScreenW/375)];
    PhotoImageView.userInteractionEnabled = YES;
    
    PhotoImageView.backgroundColor = [UIColor purpleColor];
    PhotoImageView.layer.cornerRadius = 50*ScreenW/375;
    PhotoImageView.layer.masksToBounds = YES;
    [view addSubview:PhotoImageView];
    [self addPhoto];
    
    nameBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 140*ScreenW/375, ScreenW, 30*ScreenW/375)];
    [nameBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:nameBut];
    [nameBut addTarget:self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    nameBut.titleLabel.font = [UIFont systemFontOfSize:18*ScreenW/375];
    
    changeBut = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-70, ScreenW*0.5-40, 50, 30*ScreenW/375)];
    changeBut.backgroundColor = [UIColor yellowColor];
    [view addSubview:changeBut];
    [changeBut setTitle:@"切换用户" forState:UIControlStateNormal];
    changeBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [changeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeBut.layer.borderColor = [UIColor grayColor].CGColor;
    changeBut.layer.borderWidth = 1;
    changeBut.layer.cornerRadius = 5;
    changeBut.layer.masksToBounds = YES;
    [changeBut addTarget:self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenW*0.5, ScreenW, ScreenH - ScreenW*0.5) style:UITableViewStylePlain];
    [self.view addSubview:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
}

#pragma mark 多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark cell创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = arr[indexPath.row];
    
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    return cell;
}

#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*ScreenW/375;
}

#pragma mark 点击cell执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddressViewController *addressVc = [[AddressViewController alloc]init];
        addressVc.user = user;
        addressVc.zhuangtai = @"no";
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:addressVc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if (indexPath.row==1){
        DingDanViewController *dingdan=[[DingDanViewController   alloc] init];
        [self   presentViewController:dingdan animated:YES completion:nil];
    }else if (indexPath.row==2){
        [self   clickD];
    }

}

#pragma mark 打电话方法
-(void)clickD{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15971875283"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark 登录按钮点击
-(void)dengLu
{
    LoadViewController *loadViewC = [[LoadViewController alloc]init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:loadViewC];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark 界面刚出现时
- (void)viewWillAppear:(BOOL)animated
{
    [self loadUser];
    if(_userArrM.count == 0)
    {
        [nameBut setTitle:@"登录／注册" forState:UIControlStateNormal];
        nameBut.userInteractionEnabled = YES;
    }else
    {
        user = [_userArrM lastObject];
        [nameBut setTitle:user.yongHuMing forState:UIControlStateNormal];
        nameBut.userInteractionEnabled = NO;
        
        PhotoImageView.image = [UIImage imageWithData:user.photo];
    }
}

#pragma mark 照片添加点击事件
- (void)addPhoto
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chlicPhoto)];
    [PhotoImageView addGestureRecognizer:tap];

    tap.numberOfTapsRequired = 2;
    
    
}

- (void)chlicPhoto
{
    [self.view endEditing:YES];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"照片选择界面" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照片库" otherButtonTitles: nil];
    [actionSheet showInView: self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        picker = [[UIImagePickerController alloc] init];
        [self presentViewController:picker animated:YES completion:nil];
        picker.delegate = self;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoImageView.image=image;
    user.photo = UIImageJPEGRepresentation(image, 1);
    [_userArrM removeLastObject];
    [_userArrM addObject:user];
    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"%@",path);
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    [NSKeyedArchiver    archiveRootObject:_userArrM toFile:pat];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark 加载所有用户
- (void)loadUser
{
    _userArrM = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pat = [path stringByAppendingPathComponent:@"user.plist"];
    NSFileManager *fm=[NSFileManager    defaultManager];
    if([fm  fileExistsAtPath:pat]==YES){
        _userArrM =[NSKeyedUnarchiver   unarchiveObjectWithFile:pat];
        //[NSKeyedArchiver    archiveRootObject:_array1 toFile:pat];
    }else{
        //        _userArrM=nil;
    }
}

@end
