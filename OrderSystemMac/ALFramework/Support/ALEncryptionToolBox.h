//
//  EncryptionToolBox.h
//  ALThreadPool
//
//  Created by Alanc Liu on 27/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALEncryptionToolBox : NSObject

+(NSString*)sha256:(NSString *)sourceString;
+(NSString *)md5:(NSString *)sourceString;
+(NSString *)base64:(NSString *)sourceString;
+(NSString *)urlSafeBase64:(NSString *)sourceString;

@end
