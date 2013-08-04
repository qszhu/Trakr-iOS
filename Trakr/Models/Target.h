//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Target : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *desc;
@property(strong, nonatomic) PFObject *pfObject;

+ (Target *)fromPFObject:(PFObject *)object;

- (NSError *)getValidationError;

- (void)saveWithTarget:(id)target selector:(SEL)selector;
@end