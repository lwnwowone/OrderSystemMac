//
//  NSString+ALExtension.m
//  DAE
//
//  Created by AlancLiu on 26/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "NSString+ALExtension.h"

@implementation NSString (ALExtension)

-(bool)hasValue{
    if(!self)
        return false;
    
    NSString *fixedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([fixedString isEqualToString:@""]){
        return false;
    }
    else{
        return true;
    }
}

@end
