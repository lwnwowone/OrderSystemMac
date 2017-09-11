//
//  ALThouchIDUitil.m
//  DAE
//
//  Created by AlancLiu on 14/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALThouchIDUitil.h"
#import <UIKit/UIKit.h>

@interface ALThouchIDUitil()

@property (nonatomic) LAContext *context;
@property (nonatomic) NSString *localizedCancelButtonTitle;
@property (nonatomic) NSString *localizedEnterPasswordButtonTitle;

@end

@implementation ALThouchIDUitil

-(LAContext *)context{
    if(!_context)
        _context = [LAContext new];
    return _context;
}

-(void)setCancelButtonTitle:(NSString *)title{
    _localizedCancelButtonTitle = title;
}

-(void)setEnterPasswordButtonTitle:(NSString *)title{
    _localizedEnterPasswordButtonTitle = title;
}

-(ALActionResultWithData *)isTouchIDAvailable{
    NSError *error = nil;

    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    [self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if(error)
        funcResult.data = error;
    else
        funcResult.result = true;
    return funcResult;
}

-(void)popTouchIDAlertWithDescription:(NSString *)description andCallback:(void(^)(ALActionResultWithData *funcResult))callback{
    __block ALActionResultWithData *touchIDResult = [ALActionResultWithData new];

     //这个属性是设置指纹输入失败之后的弹出框的选项
    if(_localizedCancelButtonTitle && [[[UIDevice currentDevice] systemVersion] integerValue] >= 10)
        self.context.localizedCancelTitle = _localizedCancelButtonTitle;
    if(_localizedEnterPasswordButtonTitle)
        self.context.localizedFallbackTitle = _localizedEnterPasswordButtonTitle;

    if ([self isTouchIDAvailable].result) {
//        NSLog(@"支持指纹识别");

        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:description reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
//                        NSLog(@"验证成功 刷新主界面");
                        touchIDResult.result = true;
                        touchIDResult.data = @(ALThouchIDStateSucceeded);
                    }
                    else{
                        NSLog(@"%@",error.localizedDescription);
                        switch (error.code) {
                            case LAErrorSystemCancel:
                            {
//                                NSLog(@"系统取消授权，如其他APP切入");
                                touchIDResult.data = @(ALThouchIDStateCanceled);
                                break;
                            }
                            case LAErrorUserCancel:
                            {
//                                NSLog(@"用户取消验证Touch ID");
                                touchIDResult.data = @(ALThouchIDStateCanceled);
                                break;
                            }
                            case LAErrorAuthenticationFailed:
                            {
//                                NSLog(@"授权失败");
                                touchIDResult.data = @(ALThouchIDStateFailed);
                                break;
                            }
                            case LAErrorPasscodeNotSet:
                            {
//                                NSLog(@"系统未设置密码");
                                touchIDResult.data = @(ALThouchIDStateFailed);
                                break;
                            }
                            case LAErrorTouchIDNotAvailable:
                            {
//                                NSLog(@"设备Touch ID不可用，例如未打开");
                                touchIDResult.data = @(ALThouchIDStateFailed);
                                break;
                            }
                            case LAErrorTouchIDNotEnrolled:
                            {
//                                NSLog(@"设备Touch ID不可用，用户未录入");
                                touchIDResult.data = @(ALThouchIDStateFailed);
                                break;
                            }
                            case LAErrorUserFallback:
                            {
//                                NSLog(@"用户选择输入密码");
                                touchIDResult.data = @(ALThouchIDStateEnterPassword);
                                break;
                            }
                            default:
                            {
//                                NSLog(@"其他情况");
                                touchIDResult.data = @(ALThouchIDStateFailed);
                                break;
                            }
                        }
                    }
                    
                    if(callback)
                        callback([touchIDResult copy]);
                    touchIDResult = nil;
                }];
    }
    else{
//        NSLog(@"不支持指纹识别");
        NSError *error = [self isTouchIDAvailable].data;
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
//                NSLog(@"ThouchID没有被启用");
                touchIDResult.data = @(ALThouchIDStateCannotPerform);
                break;
            }
            case LAErrorPasscodeNotSet:
            {
//                NSLog(@"没有设置解锁密码");
                touchIDResult.data = @(ALThouchIDStateCannotPerform);
                break;
            }
            default:
            {
//                NSLog(@"TouchID模块不可用");
                touchIDResult.data = @(ALThouchIDStateCannotPerform);
                break;
            }
        }
        
        if(callback)
            callback([touchIDResult copy]);
        touchIDResult = nil;
    }
}

@end

