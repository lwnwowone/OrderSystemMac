//
//  LoginViewController.m
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"

@interface LoginViewController ()

@property (weak) IBOutlet NSTextField *tfUsername;
@property (weak) IBOutlet NSTextField *tfPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)btnLogin:(NSButton *)sender {
    NSString *username = _tfUsername.stringValue;
    NSString *password = _tfPassword.stringValue;
    [[UserModel sharedInstance] loginWithUsername:username andPassword:password andFinishBlock:^(ALActionResult *funcResult) {
        if(funcResult.result){
            [ALBasicToolBox runFunctionInMainThread:^{
                [self.loginSucceeded invoke];
                [[NSApplication sharedApplication] endSheet:self.view.window];
                [self.view.window close];
            }];
        }
        else{
            [ALBasicToolBox runFunctionInMainThread:^{
                [ALertMessage operationFailedWithActionResult:funcResult];
            }];
        }
    }];
}

@end
