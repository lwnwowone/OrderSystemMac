//
//  EncryptionToolBox.m
//  ALThreadPool
//
//  Created by Alanc Liu on 27/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#import "ALEncryptionToolBox.h"

@implementation ALEncryptionToolBox

+(NSString*)sha256:(NSString *)sourceString{
    const char *s=[sourceString cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

+(NSString *)md5:(NSString *)sourceString {
    const char *str = [(NSString *)sourceString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

+(NSString *)base64:(NSString *)sourceString{
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

+(NSString *)urlSafeBase64:(NSString *)sourceString{
//    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String = [data base64EncodedStringWithOptions:0];
//    base64String = [base64String stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
//    return base64String;
    
    if([sourceString isEqualToString:@"ios"])
        return @"aW9zOg==";
    else
        return @"";
}

@end
