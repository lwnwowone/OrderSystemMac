//
//  ServicesEnvironment.h
//  DAE
//
//  Created by AlancLiu on 30/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicesEnvironment : NSObject

+(NSString *)serviceAPIAddress;

+(void)setToken:(NSString *)token;
+(NSString *)getToken;

@end
