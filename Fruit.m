//
//  Fruit.m
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Fruit.h"

@implementation Fruit

//-(id)initWith:(NSDictionary *)tmp{
//    self=[super init];
//    if (self) {
//        self.name=[tmp  objectForKey:@"name"];
//        self.des=[tmp   objectForKey:@"des"];
//        self.price=[tmp objectForKey:@"price"];
//        self.originalPrice=[tmp objectForKey:@"originalPrice"];
//        self.saled=[tmp objectForKey:@"saled"];
//        self.goodCom=[tmp   objectForKey:@"goodCom"];
//        self.kind=[tmp  objectForKey:@"kind"];
//        self.num=[tmp   objectForKey:@"num"];
//    }
//    return self;
//}


#pragma mark 编码方法和解码方法实现
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.saled forKey:@"saled"];
    [aCoder encodeObject:self.goodCom forKey:@"goodCom"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.num forKey:@"num"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:self.imgUrl2 forKey:@"imgUrl2"];
    [aCoder encodeObject:self.des forKey:@"des"];
    [aCoder encodeObject:self.pingjia forKey:@"pingjia"];
    [aCoder encodeObject:self.isChoised forKey:@"isChoised"];
}

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.name=[aDecoder    decodeObjectForKey:@"name"];
    self.saled=[aDecoder    decodeObjectForKey:@"saled"];
    self.goodCom=[aDecoder    decodeObjectForKey:@"goodCom"];
    self.price=[aDecoder    decodeObjectForKey:@"price"];
    self.num=[aDecoder    decodeObjectForKey:@"num"];
    self.imgUrl=[aDecoder   decodeObjectForKey:@"imgUrl"];
    self.imgUrl2=[aDecoder  decodeObjectForKey:@"imgUrl2"];
    self.des=[aDecoder  decodeObjectForKey:@"des"];
    self.pingjia=[aDecoder  decodeObjectForKey:@"pingjia"];
    self.isChoised=[aDecoder   decodeObjectForKey:@"isChoised"];
    return self;
}

@end
