//
//  ProfileViewController.m
//  OrderSystemMac
//
//  Created by 刘文楠 on 9/12/17.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserModel.h"
#import "AlertMessage.h"

@interface ProfileViewController ()

@property (weak) IBOutlet NSTextField *oPassword;
@property (weak) IBOutlet NSTextField *nPassword;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)changePassword:(id)sender {
    NSString *oP = _oPassword.stringValue;
    NSString *nP = _nPassword.stringValue;
    
    __TO_WEAK_SELF;
    [[UserModel sharedInstance] changePasswordWithOPassword:oP
                                               andNPassword:nP
                                             andFinishBlock:^(ALActionResult *funcResult) {
                                                 if(funcResult.result){
                                                     __TO_STRONG_SELF;
                                                     [ALBasicToolBox runFunctionInMainThread:^{
                                                         _oPassword.stringValue = @"";
                                                         _nPassword.stringValue = @"";
                                                         [self closeWindow];
                                                     }];
                                                 }
                                                 else{
                                                     [ALBasicToolBox runFunctionInMainThread:^{
                                                         [ALertMessage operationFailedWithActionResult:funcResult];
                                                     }];
                                                 }
    }];
}

- (IBAction)closeWindow:(id)sender {
    [self closeWindow];
}

-(void)closeWindow{
    [self.view.window close];
}

@end
