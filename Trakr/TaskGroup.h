//
//  TaskStatusType.h
//  Trakr
//
//  Created by Qinsi ZHU on 10/3/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kTaskGroupLate,
    kTaskGroupToday,
    kTaskGroupTomorrow,
    kTaskGroupThisWeek,
    kTaskGroupFuture,
    kTaskGroupAll
};

@interface TaskGroup : NSObject
+ (NSArray *)values;

+ (NSArray *)names;

+ (NSString *)getNameForValue:(NSInteger)taskGroup;

+ (NSInteger)getValueAtIndex:(NSUInteger)index;
@end
