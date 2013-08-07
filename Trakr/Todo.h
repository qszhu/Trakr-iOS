//
// Created by Qinsi ZHU on 8/7/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Progress;
@class Task;
@class Completion;


@interface Todo : NSObject
@property(strong, nonatomic) Progress *progress;
@property(strong, nonatomic) Task *task;
@property(strong, nonatomic) Completion *completion;

- (BOOL)isCompleted;
@end
