//
//  ALHttpRequet.m
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALHttpRequest.h"
#import "ALNetworkHelper.h"
#import "ALBasicToolBox.h"
#import "ALJsonHelper.h"
#import "ALActionResultStandardError.h"

@implementation ALHttpRequest

+(NSString*)getMethodStringBy:(ALHttpMethod)method{
    NSString *result = @"";
    switch (method) {
        case ALHttpMethodGet:
            result = @"GET";
            break;
        case ALHttpMethodPost:
            result = @"POST";
            break;
        case ALHttpMethodDelete:
            result = @"DELETE";
            break;
        case ALHttpMethodPut:
            result = @"PUT";
            break;
        default:
            break;
    }
    return result;
}

-(id)initWithUrl:(NSString*)url{
    self = [super init];
    _url = url;
    _contentType = ALHttpContentTypeFormData;
    return self;
}

-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params with:(NSDictionary*)hParams{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    if([ALNetworkHelper networkStatus] != ALNetworkStatusNotReachable){
        if(method == ALHttpMethodGet){
            funcResult = [self doGetRequestWith:(NSDictionary*)params with:(NSDictionary*)hParams];
        }
        else{
            funcResult = [self doBodyRequestUsing:method with:params with:hParams];
        }
    }
    else
        [ALActionResultStandardError noInternetConnectionError:funcResult];
    return funcResult;
}

-(ALActionResultWithData*)doBodyRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params with:(NSDictionary*)hParams{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    //构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSLog(@"Current httpMethod is : %@",[ALHttpRequest getMethodStringBy:method]);
    [request setHTTPMethod:[ALHttpRequest getMethodStringBy:method]];
    [request setTimeoutInterval:[ALNetworkHelper timeOutTime]];
    //设置请求头
    if(hParams){
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    
        for (NSString *key in hParams) {
            [headerDic setObject:[hParams objectForKey:key] forKey:key];
        }
        
        [request setAllHTTPHeaderFields:headerDic];
    }
    
    [request setTimeoutInterval:[ALNetworkHelper timeOutTime]];
    
    if(_contentType == ALHttpContentTypeFormData){
        request.HTTPBody = [[self getParamStringBy:params] dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[self typeStringFromALHttpContentTypeAndExtraString:nil] forHTTPHeaderField: @"Content-Type"];
    }
    else if(_contentType == ALHttpContentTypeJson){
        ALActionResultWithData *loadResult = [ALJsonHelper getJsonStringFromJsonObject:params];
        if(loadResult.result){
            NSString *jsonStr = [ALJsonHelper getJsonStringFromJsonObject:params].data;
            request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:[self typeStringFromALHttpContentTypeAndExtraString:nil] forHTTPHeaderField: @"Content-Type"];
        }
        else
            return loadResult;
    }
    else if(_contentType == ALHttpContentTypeMultiPartFormData){
        NSString *boundary = [self generateBoundaryString];
        request.HTTPBody = [self createBodyWithBoundary:boundary parameters:params];
        [request setValue:[self typeStringFromALHttpContentTypeAndExtraString:boundary] forHTTPHeaderField: @"Content-Type"];
    }
    
    dispatch_semaphore_t httpRequestWD = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError* error) {
        if(nil == error){
            funcResult.result = YES;
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            funcResult.data = result;
        }
        else{
            funcResult.errorCode = @"-m9998";
            funcResult.errorMessage = [error localizedDescription];
        }
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            funcResult.extraData = [NSString stringWithFormat:@"%d",(int)statusCode];
        }
        dispatch_semaphore_signal(httpRequestWD);
    }];
    [task resume];
    dispatch_semaphore_wait(httpRequestWD,DISPATCH_TIME_FOREVER);
    return funcResult;
}

-(ALActionResultWithData*)doGetRequestWith:(NSDictionary*)params with:(NSDictionary*)hParams{
    ALActionResultWithData<NSString *> *funcResult = [ALActionResultWithData<NSString *> new];
    
    NSString *oUrl = _url;
    if (params && params.count > 0) {
        oUrl = [self getOperationUrlBy:params];
    }
    
    //构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:oUrl]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[self typeStringFromALHttpContentTypeAndExtraString:nil] forHTTPHeaderField: @"Content-Type"];
    [request setTimeoutInterval:[ALNetworkHelper timeOutTime]];
    //设置请求头
    if(hParams){
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
        
        for (NSString *key in hParams) {
            [headerDic setObject:[hParams objectForKey:key] forKey:key];
        }
        
        [request setAllHTTPHeaderFields:headerDic];
    }
    
    [request setTimeoutInterval:[ALNetworkHelper timeOutTime]];
    
    dispatch_semaphore_t httpRequestWD = dispatch_semaphore_create(0);//创建等待信号量
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError* error) {
        if(nil == error){
            funcResult.result = YES;
            NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            funcResult.data = result;
        }
        else{
            funcResult.errorCode = @"-m9998";
            funcResult.errorMessage = [error localizedDescription];
        }
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            funcResult.extraData = [NSString stringWithFormat:@"%d",(int)statusCode];
        }
        dispatch_semaphore_signal(httpRequestWD);//发送停止等待信号
    }];
    [task resume];
    dispatch_semaphore_wait(httpRequestWD,DISPATCH_TIME_FOREVER);//等待信号量命令
    return funcResult;
}

//uitil method

-(NSString *)getOperationUrlBy:(NSDictionary *)dic{
    return [NSString stringWithFormat:@"%@?%@",_url,[self getParamStringBy:dic]];
}

-(NSString*)getParamStringBy:(NSDictionary *)dic{
    NSString *result = @"";
    int index = 0;
    for (NSString *item in dic) {
        NSString *symbol = @"&";
        if(0 == index)
            symbol = @"";
        NSString *tmpStr = [NSString stringWithFormat:@"%@%@=%@",symbol,item,[dic valueForKey:item]];
        result = [result stringByAppendingString:tmpStr];
        index++;
    }
    return result;
}

-(NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    NSString *fileKey = @ALHTTPREQUEST_MULTIPARTFORMDATA_KEY;
    for (NSString *key in parameters) {
        bool fileFlag = [[key substringWithRange:NSMakeRange(0, [fileKey length])] isEqualToString:fileKey];
        if(fileFlag){
            NSString *realKey = [key substringWithRange:NSMakeRange([fileKey length], [key length] - [fileKey length])];
            NSString *filePath = parameters[key];
            
            NSString *filename = [filePath lastPathComponent];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSString *mimetype = [self mimeTypeForPath:filePath];
            
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", realKey, filename] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:data];
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else{
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameters[key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

-(NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

-(NSString *)typeStringFromALHttpContentTypeAndExtraString:(NSString *)extraString{
    if(self.contentType == ALHttpContentTypeJson)
        return  @"application/json";
    else if(self.contentType == ALHttpContentTypeFormData)
        return  @"application/x-www-form-urlencoded";
    else if(self.contentType == ALHttpContentTypeMultiPartFormData)
        return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", extraString];
    else
        return @"";
}


@end
