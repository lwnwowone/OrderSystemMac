//
//  ALAlertMessage.m
//  DAE
//
//  Created by AlancLiu on 26/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALAlertMessage.h"
#import "ALAlertView.h"

static NSString *operationSucceeded = @"Operation succeeded";
static NSString *operationFailed = @"Operation failed";

@interface ALAlertMessage()<UIAlertViewDelegate>

@end

@implementation ALAlertMessage

+(void)setSucceededTitle:(NSString *)title{
    operationSucceeded = title;
}

+(void)setFailedTitle:(NSString *)title{
    operationFailed = title;
}

+(void)setCancelTitle:(NSString *)title{
    [ALAlertView setCancelTitle:title];
}

+(void)operationSucceededWithMessage:(NSString *)message{
    NSString *localizedTitle = operationSucceeded;
    [ALAlertMessage displayWithTitle:localizedTitle andMessage:message andCloseAction:nil];
}

+(void)operationFailedWithMessage:(NSString *)message{
    NSString *localizedTitle = operationFailed;
    [ALAlertMessage displayWithTitle:localizedTitle andMessage:message andCloseAction:nil];
}

+(void)operationFailedWithMessage:(NSString *)message andCloseAction:(void(^)())closeAction{
    NSString *localizedTitle = operationFailed;
    [ALAlertMessage displayWithTitle:localizedTitle andMessage:message andCloseAction:closeAction];
}

+(void)operationFailedWithActionResult:(ALActionResult *)actionResult{
    [ALAlertMessage operationFailedWithMessage:actionResult.errorMessage];
}

+(void)displayWithTitle:(NSString *)title andMessage:(NSString *)message{
    [ALAlertMessage displayWithTitle:title andMessage:message andCloseAction:nil];
}

+(void)displayWithTitle:(NSString *)title andMessage:(NSString *)message andCloseAction:(void(^)())closeAction{
    [[ALAlertView sharedInstance] displayWithTitle:title andMessage:message andCloseAction:closeAction];
}

+(void)displayWithTitle:(NSString *)title andMessage:(NSString *)message andConfirmButtonTitle:(NSString *)confirmTitle andConfirmAction:(void(^)())confirmAction andCloseAction:(void(^)())closeAction{
    [[ALAlertView sharedInstance] displayWithTitle:title andMessage:message andConfirmButtonTitle:confirmTitle andConfirmAction:confirmAction andCloseAction:closeAction];
}

@end
