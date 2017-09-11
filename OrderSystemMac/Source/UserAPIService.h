//
//  UserAPIService.h
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAPIService : NSObject

-(ALActionResultWithData *)registerWith:(NSString *)username
                            andPassword:(NSString *)password;

-(ALActionResultWithData *)loginWith:(NSString *)username
                         andPassword:(NSString *)password;

-(ALActionResultWith2Data *)getProfile;

@end
