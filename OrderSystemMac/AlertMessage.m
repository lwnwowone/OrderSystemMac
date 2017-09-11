//
//  ALertMessage.m
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "AlertMessage.h"
#import <Cocoa/Cocoa.h>

@implementation ALertMessage

+(void)operationFailedWithMessage:(NSString *)message{
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"关闭"];
    [alert setMessageText:@"操作失败"];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert runModal];
}

+(void)operationFailedWithActionResult:(ALActionResult *)actionResult{
    [ALertMessage operationFailedWithMessage:actionResult.errorMessage];
}

@end
