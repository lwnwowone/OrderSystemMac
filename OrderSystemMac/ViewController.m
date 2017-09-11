//
//  ViewController.m
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "ViewController.h"
#import "ServicesEnvironment.h"
#import "OrderMeta.h"
#import "UserMeta.h"
#import "LoginViewController.h"
#import "OrderModel.h"
#import "UserModel.h"

#define CELL_ID @"OrderListCell"

@interface ViewController()<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *orderTable;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSButton *logoutButton;
@property (weak) IBOutlet NSButton *orderButton;
@property (weak) IBOutlet NSButton *refreshListButton;

@end

@implementation ViewController{

@private NSMutableArray<OrderMeta *> *dataList;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    _loginButton.hidden = true;
    _logoutButton.hidden = true;
    _orderButton.hidden = true;
    _refreshListButton.hidden = true;

    dataList = [NSMutableArray new];
    
    self.orderTable.delegate = self;
    self.orderTable.dataSource = self;
    [self.orderTable reloadData];
    
    [self performSelector:@selector(checkToken) withObject:nil afterDelay:0.3];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)login:(id)sender {
    [self showLoginWindow];
}

- (IBAction)createOrder:(NSButton *)sender {
    if([OrderModel sharedInstance].currentOrderState){
        [[OrderModel sharedInstance] closeOrderWithFinishBlock:^(ALActionResult *funcResult) {
            if(funcResult.result){
                [OrderModel sharedInstance].currentOrderState = false;
                self.orderButton.title = @"订餐";
                [self reloadOrderList];
            }
            else{
                [ALertMessage operationFailedWithActionResult:funcResult];
            }
        }];
    }
    else{
        [[OrderModel sharedInstance] createOrderWithFinishBlock:^(ALActionResult *funcResult) {
            [self reloadOrderList];

            if(funcResult.result){
                [OrderModel sharedInstance].currentOrderState = true;
                self.orderButton.title = @"取消订单";
                [self reloadOrderList];
            }
            else{
                [ALertMessage operationFailedWithActionResult:funcResult];
            }
        }];
    }
}
- (IBAction)refreshOrderList:(NSButton *)sender {
    [self reloadOrderList];
}

-(void)showLoginWindow{
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    NSWindowController *winController = [storyBoard instantiateControllerWithIdentifier:@"LoginWindowController"]; // instantiate your window controller
    [[NSApplication sharedApplication] beginSheet:winController.window
                                   modalForWindow:self.view.window
                                    modalDelegate:self
                                   didEndSelector:@selector(didFinishedLogin)
                                      contextInfo:nil];
}

- (IBAction)Logout:(NSButton *)sender {
    [UserModel sharedInstance].currentUser = nil;
    [dataList removeAllObjects];
    [_orderTable reloadData];
    
}

- (void)checkToken{
    NSString *token = [ServicesEnvironment getToken];

    _loginButton.hidden = true;
    _logoutButton.hidden = true;
    _orderButton.hidden = true;
    _refreshListButton.hidden = true;
    if([token hasValue]){
        [[UserModel sharedInstance] autoLoginWithFinishBlock:^(ALActionResult *funcResult) {
            if(funcResult.result){
                [self reloadOrderList];
                [ALBasicToolBox runFunctionInMainThread:^{
                    [self didFinishedLogin];
                }];
            }
            else{
                [ALertMessage operationFailedWithActionResult:funcResult];
                [ALBasicToolBox runFunctionInMainThread:^{
                    _loginButton.hidden = false;
                    _logoutButton.hidden = true;
                }];
            }
        }];
    }
    else
        [self showLoginWindow];
}

-(void)didFinishedLogin{
    NSLog(@"登录成功");
    [ALBasicToolBox runFunctionInMainThread:^{
        _loginButton.hidden = true;
        _logoutButton.hidden = false;

        _orderButton.hidden = false;
        _refreshListButton.hidden = false;
        
        if([OrderModel sharedInstance].currentOrderState)
            self.orderButton.title = @"取消订单";
        else
            self.orderButton.title = @"订餐";
    }];
}

-(void)reloadOrderList{
    [[OrderModel sharedInstance] searchTodayOrdersWithFinishBlock:^(ALActionResultWithData *funcResult) {
        if(funcResult.result){
            dataList = funcResult.data;
            [ALBasicToolBox runFunctionInMainThread:^{
                [self.orderTable reloadData];
            }];
        }
        else{
            [ALertMessage operationFailedWithActionResult:funcResult];
        }
    }];
}

#pragma table view

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return dataList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    float columnWidth = tableColumn.width;
    NSTextField *view = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, columnWidth, 30)];
    view.backgroundColor = [NSColor clearColor];
    view.bordered = NO;
    view.editable = NO;
    
    OrderMeta *meta = [dataList objectAtIndex:row];
    NSString *infoString = @"";
    if([tableColumn.identifier isEqualToString:@"OrderUser"]){
        infoString = meta.userNickname;
        if(!infoString)
            infoString = meta.username;
        
        UserMeta *currentUser = [UserModel sharedInstance].currentUser;
        if([meta.username isEqualToString:currentUser.userName])
           infoString = [NSString stringWithFormat:@"%@(我)",infoString];
    }
    else if([tableColumn.identifier isEqualToString:@"OrderTime"]){
        infoString = meta.orderTime;
        NSString *hour = [infoString substringWithRange:NSMakeRange(0, 2)];
        NSString *min = [infoString substringWithRange:NSMakeRange(2, 2)];
        NSString *sec = [infoString substringWithRange:NSMakeRange(4, 2)];

        infoString = [NSString stringWithFormat:@"%@:%@:%@",hour,min,sec];
    }
    
    [view setStringValue:infoString];
    return view;
}

@end
