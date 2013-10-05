//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Todo.h"
#import "Progress.h"

@implementation Todo {

}

- (id)initWithTask:(Task *)task inProgress:(Progress *)progress {
    self = [super init];
    if (self) {
        self.task = task;
        self.progress = progress;
    }
    return self;
}

- (void)completeWithCost:(NSInteger)cost {
    [self.progress completeTask:self.task withCost:cost];
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    [self.progress saveWithTarget:target selector:selector];
}

- (BOOL)isCompleted {
    return [self.progress isTaskCompleted:self.task];
}

@end