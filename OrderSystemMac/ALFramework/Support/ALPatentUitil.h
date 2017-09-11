//
//  ALPatentUitil.h
//  DAE
//
//  Created by AlancLiu on 17/08/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPatentUitil : NSObject

+(BOOL)isContainsString:(NSString *)aStr forPatent:(NSString *)patent;
+(BOOL)isMatchesString:(NSString *)aStr forPatent:(NSString *)patent;

@end
