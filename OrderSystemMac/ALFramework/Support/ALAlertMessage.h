//
//  ALAlertMessage.h
//  DAE
//
//  Created by AlancLiu on 26/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALActionResult.h"
#import "ALAlertView.h"

@interface ALAlertMessage : NSObject

+(void)setSucceededTitle:(NSString *)title;
+(void)setFailedTitle:(NSString *)title;
+(void)setCancelTitle:(NSString *)title;

+(void)operationSucceededWithMessage:(NSString *)message;

+(void)operationFailedWithMessage:(NSString *)message;
+(void)operationFailedWithMessage:(NSString *)message andCloseAction:(void(^)())closeAction;

+(void)displayWithTitle:(NSString *)title andMessage:(NSString *)message;
+(void)displayWithTitle:(NSString *)title andMessage:(NSString *)message andCloseAction:(void(^)())closeAction;
+(void)displayWithTitle:(NSString *)title
             andMessage:(NSString *)message
  andConfirmButtonTitle:(NSString *)confirmTitle
       andConfirmAction:(void(^)())confirmAction
         andCloseAction:(void(^)())closeAction;

+(void)operationFailedWithActionResult:(ALActionResult *)actionResult;

@property UIAlertView *alert;

@property void(^closeAction)();
@property void(^confirmAction)();

@end
