//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Task : NSObject
@property(nonatomic) NSInteger offset;
@property(nonatomic) NSInteger step;
@property(strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSDate *deadline;

- (id)initWithParseObject:(PFObject *)object;

- (PFObject *)getParseObject;

- (NSDate *)getDate:(NSDate *)startDate;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end