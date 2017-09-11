//
//  OrderMeta.m
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "OrderMeta.h"

@implementation OrderMeta

-(id)initWithInfoDic:(NSDictionary *)infoDic{
    self = [self init];
    if(infoDic){
        self.orderID = infoDic[@"OrderID"];
        self.username = infoDic[@"Username"];
        self.orderTime = infoDic[@"OrderTime"];
        self.orderDate = infoDic[@"OrderDate"];
    }
    return self;
}

@end
