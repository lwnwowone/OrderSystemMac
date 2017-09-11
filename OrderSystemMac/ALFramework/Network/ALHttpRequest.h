//
//  ALHttpRequet.h
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALActionResult.h"

#define ALHTTPREQUEST_MULTIPARTFORMDATA_KEY "IsFile_"

typedef enum{
    ALHttpMethodGet,
    ALHttpMethodPost,
    ALHttpMethodDelete,
    ALHttpMethodPut
}ALHttpMethod;

typedef enum{
    ALHttpContentTypeFormData,
    ALHttpContentTypeMultiPartFormData,
    ALHttpContentTypeJson
}ALHttpContentType;

@interface ALHttpRequest : NSObject

@property (nonatomic) ALHttpContentType contentType;

+(NSString*)getMethodStringBy:(ALHttpMethod)method;

-(id)initWithUrl:(NSString*)url;
-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params with:(NSDictionary*)hParams;

@property NSString *url;

@end
