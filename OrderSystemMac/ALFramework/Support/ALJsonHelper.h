//
//  ALJsonHelper.h
//  ALThreadPool
//
//  Created by Alanc Liu on 26/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALActionResult.h"

@interface ALJsonHelper : NSObject

+(ALActionResultWithData<NSString *> *)getJsonStringFromJsonObject:(id)jDic;

+(ALActionResultWithData *)getJsonObjectFromJsonString:(NSString *)jsonStr;
+(ALActionResultWithData *)getJsonValueFromJsonString:(NSString *)jStr andKey:(NSString *)key;
+(ALActionResultWithData *)getJsonObjectFromFile:(NSString *)jsonFilePath;
+(ALActionResultWithData *)getJsonObjectFromResource:(NSString *)resourceFileName;
+(ALActionResultWithData *)getJsonValueFromResource:(NSString *)resourceFileName andKey:(NSString *)key;

@end
