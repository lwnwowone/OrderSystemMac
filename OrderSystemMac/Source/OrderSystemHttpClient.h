//
//  OrderSystemHttpClient.h
//  DAE
//
//  Created by AlancLiu on 04/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSystemHttpClient : NSObject

@property (nonatomic) ALHttpContentType contentType;
@property (nonatomic) bool needToken;
@property (nonatomic) NSString *url;

-(id)initWith:(NSString*)FunctionStr;
-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params;
-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params andHeader:(NSDictionary *)header;

#pragma request making

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                 andParameters:(NSDictionary *)parameters
                              andRequestMethod:(ALHttpMethod)requestMethod;

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                 andParameters:(NSDictionary *)parameters
                              andRequestMethod:(ALHttpMethod)requestMethod
                                    andHeaders:(NSDictionary *)headers;

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                 andParameters:(NSDictionary *)parameters
                              andRequestMethod:(ALHttpMethod)requestMethod
                       andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock;

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod;

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                                      andHeaders:(NSDictionary *)headers;

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                         andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock;

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                                      andHeaders:(NSDictionary *)headers
                         andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock;

+(ALActionResult *)runAPIWithAPIAddress:(NSString *)apiAddress
                           andNeedToken:(bool)needToken
                         andContentType:(ALHttpContentType)contentType
                             andHeaders:(NSDictionary *)headers
                          andParameters:(NSDictionary *)parameters
                       andRequestMethod:(ALHttpMethod)requestMethod
                andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock;

@end
