//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Target;


@interface Plan : NSObject
@property(strong, nonatomic) Target *target;
@property(strong, nonatomic) NSNumber *total;
@property(strong, nonatomic) NSNumber *unit;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSArray *tasks;
@property(strong, nonatomic) PFObject *pfObject;

+ (Plan *)fromPFObject:(PFObject *)object;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end