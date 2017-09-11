//
//  UserMeta.h
//  OrderSystemMac
//
//  Created by AlancLiu on 11/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMeta : NSObject

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *Nickname;
@property (nonatomic) NSString *Department;

-(id)initWithInfoDic:(NSDictionary *)infoDic;

@end

