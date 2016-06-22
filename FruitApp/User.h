//
//  User.h
//  FruitApp
//
//  Created by mac on 16/3/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (strong, nonatomic) NSData *photo;
@property (copy, nonatomic) NSString *yongHuMing;//用户名
@property (copy, nonatomic) NSString *passWord;//密码
@property (strong, nonatomic)NSMutableArray *listArrM;//订单数组
@property (strong, nonatomic)NSMutableArray *addressArrM;//地址数组


@end
