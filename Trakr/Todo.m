//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Todo.h"
#import "Progress.h"
#import "Task.h"
#import "Completion.h"


@implementation Todo {

}
- (BOOL)isCompleted {
    return self.completion != nil;
}

@end