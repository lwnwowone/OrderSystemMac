//
//  ALPatentUitil.m
//  DAE
//
//  Created by AlancLiu on 17/08/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALPatentUitil.h"

@implementation ALPatentUitil

+(BOOL)isContainsString:(NSString *)aStr forPatent:(NSString *)patent
{
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:patent options:0 error:&error];
    NSArray *resultArray = [regex matchesInString:aStr options:0 range:NSMakeRange(0, aStr.length)];
    return resultArray.count > 0;
}

+(BOOL)isMatchesString:(NSString *)aStr forPatent:(NSString *)patent
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patent];
    return [predicate evaluateWithObject:aStr];
}

@end
