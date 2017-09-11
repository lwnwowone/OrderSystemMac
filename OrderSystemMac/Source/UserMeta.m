//
//  UserMeta.m
//  OrderSystemMac
//
//  Created by AlancLiu on 11/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "UserMeta.h"

@implementation UserMeta

-(id)initWithInfoDic:(NSDictionary *)infoDic{
    self = [super init];
    if(!infoDic)
        return self;
    
    self.userName = infoDic[@"username"];
    self.Nickname = infoDic[@"nickname"];
    self.Department = infoDic[@"department"];
    
    return self;
}

@end
