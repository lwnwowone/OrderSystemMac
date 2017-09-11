//
//  ALActionResultStandardError.m
//  DAE
//
//  Created by AlancLiu on 21/08/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALActionResultStandardError.h"

static NSString *applicationErrorCode = @"-ALE9999";
static NSString *applicationErrorMessage = @"Application error";

static NSString *noInternetConnectionErrorCode = @"-ALE9998";
static NSString *noInternetConnectionErrorMessage = @"No internet connection";

static NSString *taskCanceledErrorCode = @"-ALE9997";
static NSString *taskCanceledErrorMessage = @"Task has been canceled";

static NSString *timeoutErrorCode = @"-ALE9996";
static NSString *timeoutErrorMessage = @"Operation timeout";

@implementation ALActionResultStandardError

+(void)setApplicationErrorMessage:(NSString *)errorMessage{
    applicationErrorMessage = errorMessage;
}

+(void)applicationError:(ALActionResult *)ar{
    ar.result = false;
    ar.errorCode = applicationErrorCode;
    ar.errorMessage = applicationErrorMessage;
}

+(void)setNoInternetConnectionErrorMessage:(NSString *)errorMessage{
    noInternetConnectionErrorMessage = errorMessage;
}

+(void)noInternetConnectionError:(ALActionResult *)ar{
    ar.result = false;
    ar.errorCode = noInternetConnectionErrorCode;
    ar.errorMessage = noInternetConnectionErrorMessage;
}

+(void)setTaskCanceledErrorMessage:(NSString *)errorMessage{
    taskCanceledErrorMessage = errorMessage;
}

+(void)taskCanceledError:(ALActionResult *)ar{
    ar.result = false;
    ar.errorCode = taskCanceledErrorCode;
    ar.errorMessage = taskCanceledErrorMessage;
}

+(void)setTimeoutErrorMessage:(NSString *)errorMessage{
    timeoutErrorMessage = errorMessage;
}

+(void)timeoutError:(ALActionResult *)ar{
    ar.result = false;
    ar.errorCode = timeoutErrorCode;
    ar.errorMessage = timeoutErrorMessage;
}

@end
