//
//  ALFileHelper.h
//  ALThreadPool
//
//  Created by Alanc Liu on 10/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

@interface ALFileHelper : NSObject

+(NSString *)documentsPath;
+(NSString *)getFilePathBySubPathInDocumentsPath:(NSString *)subPath;

+(BOOL)saveData:(NSData *)data toSubPathInDocumentsPath:(NSString *)subPath;

+(BOOL)checkFileExists:(NSString *)filePath;
+(BOOL)checkDirectoryExists:(NSString *)directoryPath andNeedAutoCreate:(bool)needAutoCreate;

+(BOOL)copyFileFrom:(NSString *)originPath to:(NSString *)targetPath;


@end
