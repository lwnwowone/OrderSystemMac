//
//  ALActionResultStandardError.h
//  DAE
//
//  Created by AlancLiu on 21/08/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALActionResult.h"

@interface ALActionResultStandardError : NSObject

+(void)setApplicationErrorMessage:(NSString *)errorMessage;
+(void)setNoInternetConnectionErrorMessage:(NSString *)errorMessage;
+(void)setTaskCanceledErrorMessage:(NSString *)errorMessage;
+(void)setTimeoutErrorMessage:(NSString *)errorMessage;

+(void)applicationError:(ALActionResult *)ar;
+(void)noInternetConnectionError:(ALActionResult *)ar;
+(void)taskCanceledError:(ALActionResult *)ar;
+(void)timeoutError:(ALActionResult *)ar;

@end
