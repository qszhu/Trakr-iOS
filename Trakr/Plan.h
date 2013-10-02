//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Target;

@interface Plan : NSObject
@property(strong, nonatomic) Target *target;
@property(nonatomic) NSInteger total;
@property(nonatomic) NSInteger unit;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSString *creator;
@property(strong, nonatomic) NSArray *tasks;

- (id)initWithParseObject:(PFObject *)object;

- (PFObject *)getParseObject;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;

@end