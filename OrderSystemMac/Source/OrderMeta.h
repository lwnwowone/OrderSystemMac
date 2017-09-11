//
//  OrderMeta.h
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderMeta : NSObject

@property (nonatomic) NSString *orderID;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *userNickname;
@property (nonatomic) NSString *orderTime;
@property (nonatomic) NSString *orderDate;

-(id)initWithInfoDic:(NSDictionary *)infoDic;

@end
