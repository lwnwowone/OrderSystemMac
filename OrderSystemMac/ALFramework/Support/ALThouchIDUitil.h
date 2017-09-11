//
//  ALThouchIDUitil.h
//  DAE
//
//  Created by AlancLiu on 14/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalAuthentication/LocalAuthentication.h"
#import "ALActionResult.h"

typedef enum{
    ALThouchIDStateSucceeded,
    ALThouchIDStateFailed,
    ALThouchIDStateCanceled,
    ALThouchIDStateEnterPassword,
    ALThouchIDStateCannotPerform
}ALThouchIDState;

@interface ALThouchIDUitil : NSObject

-(ALActionResultWithData *)isTouchIDAvailable;
-(void)popTouchIDAlertWithDescription:(NSString *)description andCallback:(void(^)(ALActionResultWithData *funcResult))callback;

-(void)setCancelButtonTitle:(NSString *)title;
-(void)setEnterPasswordButtonTitle:(NSString *)title;

@end
