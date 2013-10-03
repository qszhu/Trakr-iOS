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
    kTaskGroupFuture
};

@interface TaskStatus : NSObject
+ (NSArray *)names;

+ (NSString *)getNameForValue:(NSInteger)taskStatus;
@end
