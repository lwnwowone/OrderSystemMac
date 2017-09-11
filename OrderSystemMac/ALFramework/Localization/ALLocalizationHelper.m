//
//  ALLocalizationHelper.m
//  ALThreadPool
//
//  Created by Alanc Liu on 25/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALLocalizationHelper.h"
#import "ALJsonHelper.h"
#import "ALFileHelper.h"
#import "NSString+ALExtension.h"    

@interface ALLocalizationHelper()

@property (nonatomic) NSString *currentLanguageKey;
@property (nonatomic) NSDictionary *currentLanguageDic;

@end

static ALLocalizationHelper *instance;
static NSString *defaultLanguage = @"CN";
static NSString *configPath = @"LanguageConfig";

@implementation ALLocalizationHelper

+(void)setLanguage:(NSString *)language{
    [ALLocalizationHelper defaultHelper].currentLanguageKey = language;
    [[ALLocalizationHelper defaultHelper] loadSourceFileToCurrentDic];
}

+(NSString *)getLocalizedStringByKey:(NSString *)key{
    return [[ALLocalizationHelper defaultHelper] getLocalizedStringFromKey:key];
}

+(NSString *)getLocalizedStringByKey:(NSString *)key andParameterArray:(NSArray<NSString *> *)parameters{
    return [[ALLocalizationHelper defaultHelper] getLocalizedStringFromKey:key andParameters:parameters];
}

#pragma private methods

+(instancetype)defaultHelper{
    if(!instance){
        instance = [ALLocalizationHelper new];
        [instance loadSourceFileToCurrentDic];
    }
    return instance;
}

-(id)init{
    self = [super init];
    _currentLanguageKey = defaultLanguage;
    return self;
}

-(void)loadSourceFileToCurrentDic{
    ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromResource:[self getLocalizationFileNameBylanguage:_currentLanguageKey]];
    if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
        NSDictionary *jsonDic = (NSDictionary *)loadResult.data;
        _currentLanguageDic = [jsonDic valueForKey:@"localization"];
    }
}

-(NSString *)getLocalizedStringFromKey:(NSString *)key{
    return [self getLocalizedStringFromKey:key andParameters:nil];
}

-(NSString *)getLocalizedStringFromKey:(NSString *)key andParameters:(NSArray<NSString*> *)parameters{
    NSString *funcResult = @"";
    
    ALLocalizationHelper *defaultHelper = [ALLocalizationHelper defaultHelper];
    
    if(defaultHelper.currentLanguageDic){//Judge current language
        funcResult = [defaultHelper.currentLanguageDic valueForKey:key];
    }
    else{
        [self loadSourceFileToCurrentDic];
        if(defaultHelper.currentLanguageDic)
            funcResult = [defaultHelper.currentLanguageDic valueForKey:key];
    }
    
    if(parameters){
        int replaceCounter = 0;
        for (NSString *aStr in parameters) {
            NSString *replaceFlag = [NSString stringWithFormat:@"{%d}",replaceCounter++];
            funcResult = [funcResult stringByReplacingOccurrencesOfString:replaceFlag withString:aStr];
        }
    }
    
    if(![funcResult hasValue])
        funcResult = [NSString stringWithFormat:@"#%@#",key];

    return funcResult;
}

-(NSString *)getLocalizationFilePathByLanguage:(NSString *)language{
    NSString *result = [NSString stringWithFormat:@"/%@/%@",[[NSBundle mainBundle] resourcePath],[self getLocalizationFileNameBylanguage:language]];
    return result;
}

-(NSString *)getLocalizationFileNameBylanguage:(NSString *)language{
    NSString *result = @"DAE_localization_";
    NSString *fileKey = @"en";
    ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromResource:configPath];
    if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
        NSDictionary *configDic = (NSDictionary *)loadResult.data;
        fileKey = [[configDic valueForKey:@"Content"] valueForKey:language];
        result = [NSString stringWithFormat:@"%@%@",result,[fileKey uppercaseString]];
        return result;
    }
    return @"";
}

@end
