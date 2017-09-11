//
//  NSDecimalNumber+ALExtension.m
//  ALFramework
//
//  Created by AlancLiu on 31/08/2017.
//  Copyright © 2017 Alanc. All rights reserved.
//

#import "NSDecimalNumber+ALExtension.h"

@implementation NSDecimalNumber (ALExtension)

+(NSDecimalNumber *)decimalNumberWithOjbect:(id)aObject{
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    if(aObject && [NSNull null] != aObject){
        if([aObject isKindOfClass:[NSString class]]){
            result = [NSDecimalNumber decimalNumberWithString:aObject];
        }
        else if([aObject doubleValue] > 0){
            NSString *tStrValue = [NSString stringWithFormat:@"%lf",[aObject doubleValue]];
            result = [NSDecimalNumber decimalNumberWithString:tStrValue];
        }
    }
    
    return result;
}

@end
