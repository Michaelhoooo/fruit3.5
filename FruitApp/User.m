//
//  User.m
//  FruitApp
//
//  Created by mac on 16/3/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init
{
    if (self = [super init]) {
        self.listArrM = [NSMutableArray array];
        self.addressArrM = [NSMutableArray array];
    }
    return self;
}



#pragma mark 编码方法和解码方法实现
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.yongHuMing forKey:@"yongHuMing"];
    [aCoder encodeObject:self.passWord forKey:@"passWord"];
    [aCoder encodeObject:self.listArrM forKey:@"listArrM"];
    [aCoder encodeObject:self.addressArrM forKey:@"addressArrM"];
}

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.photo=[aDecoder    decodeObjectForKey:@"photo"];
    self.yongHuMing=[aDecoder    decodeObjectForKey:@"yongHuMing"];
    self.passWord=[aDecoder    decodeObjectForKey:@"passWord"];
    self.listArrM=[aDecoder    decodeObjectForKey:@"listArrM"];
    self.addressArrM=[aDecoder    decodeObjectForKey:@"addressArrM"];

    return self;
}


@end
