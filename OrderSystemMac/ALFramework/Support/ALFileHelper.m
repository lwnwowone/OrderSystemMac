//
//  ALFileHelper.m
//  ALThreadPool
//
//  Created by Alanc Liu on 10/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALFileHelper.h"

@implementation ALFileHelper

+(NSString *)documentsPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+(NSString *)getFilePathBySubPathInDocumentsPath:(NSString *)subPath{
    return [[ALFileHelper documentsPath] stringByAppendingPathComponent:subPath];
}

+(BOOL)saveData:(NSData *)data toSubPathInDocumentsPath:(NSString *)subPath{
    NSString *filePath = [ALFileHelper getFilePathBySubPathInDocumentsPath:subPath];
    NSString *dirPath = [filePath stringByDeletingLastPathComponent];

    [self checkDirectoryExists:dirPath andNeedAutoCreate:true];

    if(![self checkFileExists:filePath]){
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }

    return [data writeToFile:filePath atomically:YES]; //Write the file
}

+(BOOL)checkFileExists:(NSString *)filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+(BOOL)checkDirectoryExists:(NSString *)directoryPath andNeedAutoCreate:(bool)needAutoCreate{
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];
    if(needAutoCreate && !result){
        return [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return result;
}

+(BOOL)copyFileFrom:(NSString *)originPath to:(NSString *)targetPath{
    NSLog(@"To be implemented");
    return true;
}

@end
