//
//  ServicesEnvironment.m
//  DAE
//
//  Created by AlancLiu on 30/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ServicesEnvironment.h"

@implementation ServicesEnvironment

+(NSString *)serviceAPIAddress{
    return HTTP_HOST;
}

+(void)setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"UserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UserToken"];
}

@end
