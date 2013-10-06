//
//  GroupedTask.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/3/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "GroupedTasks.h"
#import "Progress.h"
#import "TaskGroup.h"

@interface GroupedTasks()
@property(strong, nonatomic) NSDictionary *groups;
@property(strong, nonatomic) NSDictionary *progressMap;
@end

@implementation GroupedTasks

- (id)initWithProgresses:(NSArray *)progresses {
    /*
     {
        groupNumber: {
            progressId: [task, ...],
            ...
        }
        ...
     }
     */
    self = [super init];
    if (self) {
        NSMutableDictionary *progressMap = [NSMutableDictionary new];
        for (Progress *progress in progresses) {
            [progressMap setObject:progress forKey:[progress objectId]];
        }

        NSMutableDictionary *groups = [NSMutableDictionary new];
        for (NSNumber *groupNumber in [TaskGroup values]) {
            NSInteger group = [groupNumber integerValue];

            NSMutableDictionary *dict = [NSMutableDictionary new];
            for (Progress *progress in progresses) {
                NSArray *tasks = [progress getTasksInGroup:group];
                if (tasks.count > 0) {
                    [dict setObject:tasks forKey:[progress objectId]];
                }
            }
            if (dict.count > 0) {
                [groups setObject:[NSDictionary dictionaryWithDictionary:dict] forKey:groupNumber];
            }
        }

        self.progressMap = [NSDictionary dictionaryWithDictionary:progressMap];
        self.groups = [NSDictionary dictionaryWithDictionary:groups];
    }
    return self;
}

- (NSInteger)getNumberOfProgressesInGroup:(NSInteger)group {
    NSNumber *groupNumber = [NSNumber numberWithInteger:group];
    NSDictionary *dict = [self.groups objectForKey:groupNumber];
    return [dict allKeys].count;
}

- (NSArray *)getProgressesInGroup:(NSInteger)group {
    NSNumber *groupNumber = [NSNumber numberWithInteger:group];
    NSDictionary *dict = [self.groups objectForKey:groupNumber];
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *progressId in [dict allKeys]) {
        [array addObject:[self.progressMap objectForKey:progressId]];
    }
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Progress *a = obj1;
        Progress *b = obj2;
        NSInteger d1 = [a getLateDays];
        NSInteger d2 = [b getLateDays];
        if (d1 < d2) {
            return NSOrderedDescending;
        }
        if (d1 > d2) {
            return NSOrderedAscending;
        }
        return [[a getName] compare:[b getName]];
    }];
    return sorted;
}

- (NSInteger)getNumberOfTasksOfProgressById:(NSString *)progressId inGroup:(NSInteger)group {
    NSNumber *groupNumber = [NSNumber numberWithInteger:group];
    NSDictionary *dict = [self.groups objectForKey:groupNumber];
    return [[dict objectForKey:progressId] count];
}

- (NSArray *)getTasksOfProgressById:(NSString *)progressId inGroup:(NSInteger)group {
    NSNumber *groupNumber = [NSNumber numberWithInteger:group];
    NSDictionary *dict = [self.groups objectForKey:groupNumber];
    return [dict objectForKey:progressId];
}

@end
