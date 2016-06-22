//
//  Address.m
//  FruitApp
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Address.h"

@implementation Address

#pragma mark 编码方法和解码方法实现
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.shoujianren forKey:@"shoujianren"];
    [aCoder encodeObject:self.dianhua forKey:@"dianhua"];
    [aCoder encodeObject:self.dizhi forKey:@"dizhi"];

}

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.shoujianren=[aDecoder    decodeObjectForKey:@"shoujianren"];
    self.dianhua=[aDecoder    decodeObjectForKey:@"dianhua"];
    self.dizhi=[aDecoder    decodeObjectForKey:@"dizhi"];
    return self;
}

@end
