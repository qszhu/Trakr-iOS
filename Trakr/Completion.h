//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Task;


@interface Completion : NSObject
@property(strong, nonatomic) NSDate *date;
@property(nonatomic) NSInteger cost;
@property(strong, nonatomic) Task *task;
//@property(nonatomic) NSInteger step;

- (id)initWithParseObject:(PFObject *)object;

- (PFObject *)getParseObject;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end