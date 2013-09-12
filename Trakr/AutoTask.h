//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Plan;

@interface AutoTask : NSObject
@property(nonatomic) NSInteger workload;
@property(strong, nonatomic) NSNumber *repeat;

- (NSError *)getValidationError;

- (void)createTasksForPlan:(Plan *)plan;
@end