//
//  ALLogMeta.h
//  DAE
//
//  Created by AlancLiu on 27/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ALLogType){
    ALLogTypeError = 1,
    ALLogTypeBasicInfo = 2,
    ALLogTypeDebug = 3,
    ALLogTypeInfo = 4
};

@interface ALLogMeta : NSObject

@property (nonatomic) long long metaID;
@property (nonatomic) ALLogType type;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *timestamp;

@end
