//
//  LoginViewController.h
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginViewController : NSViewController

@property (nonatomic) void(^loginSucceeded)();

@end
