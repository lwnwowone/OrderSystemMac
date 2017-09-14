//
//  UserModel.h
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMeta.h"

@interface UserModel : NSObject

@property (nonatomic) UserMeta *currentUser;

+(instancetype)sharedInstance;

-(void)registerWithUsername:(NSString *)username
                andPassword:(NSString *)password
             andFinishBlock:(void(^)(ALActionResult *))callback;

-(void)loginWithUsername:(NSString *)username
             andPassword:(NSString *)password
          andFinishBlock:(void(^)(ALActionResult *))callback;

-(void)changePasswordWithOPassword:(NSString *)oPassword
                      andNPassword:(NSString *)nPassword
                    andFinishBlock:(void(^)(ALActionResult *))callback;

-(void)autoLoginWithFinishBlock:(void(^)(ALActionResult *))callback;

@end
