//
//  ALLocalizationHelper.h
//  ALThreadPool
//
//  Created by Alanc Liu on 25/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ToLocalized(__STR__) [ALLocalizationHelper getLocalizedStringByKey:@#__STR__]

@interface ALLocalizationHelper : NSObject

+(void)setLanguage:(NSString *)language;

+(NSString *)getLocalizedStringByKey:(NSString *)key;
+(NSString *)getLocalizedStringByKey:(NSString *)key andParameterArray:(NSArray<NSString*>*)parameters;

@end
