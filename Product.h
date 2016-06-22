//
//  Product.h
//  ZmembShareApp
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Tea.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
@end
