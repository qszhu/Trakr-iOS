//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Progress;
@class Task;

@interface Todo : NSObject
@property(strong, nonatomic) Progress *progress;
@property(strong, nonatomic) Task *task;

- (id)initWithTask:(Task *)task inProgress:(Progress *)progress;
- (void)completeWithCost:(NSInteger)cost;
- (void)saveWithTarget:(id)target selector:(SEL)selector;
@end
