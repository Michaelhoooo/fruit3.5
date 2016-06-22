//
//  Fruit.h
//  FruitApp
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fruit : NSObject<NSCoding>

@property NSString *isChoised;

//@property NSString *fid;//商品id
@property NSString *name;//商品名称
@property NSString *des;//商品描述
@property NSString *imgUrl;//小图
@property NSString *imgUrl2;//大图
@property NSString *price;//现价
@property NSString *originalPrice;//原价
@property NSString *saled;//已卖
@property NSString *goodCom;//好评
@property NSString *pingjia;//总评数
@property NSString *kind;//种类

@property NSString *num;//购买数量



-(void)encodeWithCoder:(NSCoder *)aCoder;
-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder;


@end

