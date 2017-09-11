//
//  ALTimer.m
//  DAE
//
//  Created by 刘文楠 on 7/10/17.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#define GLOBAL_COUNT_MAX_VALUE 10

#import "ALTimer.h"

@interface ALTimer()

@property (nonatomic) dispatch_source_t timer;

@end

static ALTimer *instance;

@implementation ALTimer

-(id)init{
    self = [super init];
    
    //间隔
    uint64_t interval = 1 * NSEC_PER_SEC;
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = dispatch_queue_create("TimerQueue", 0);
    //创建Timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    //设置回调
    dispatch_source_set_event_handler(_timer, ^(){
        if(self.timerfired)
            self.timerfired();
    });
    
    dispatch_resume(_timer);
    
    return self;
}

-(void)runTimer{
    dispatch_resume(_timer);
}

-(void)stopTimer{
    dispatch_suspend(_timer);
}

@end
