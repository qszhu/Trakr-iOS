//
//  GroupedTask.h
//  Trakr
//
//  Created by Qinsi ZHU on 10/3/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupedTasks : NSObject
- (id)initWithProgresses:(NSArray *)progresses;

- (NSInteger)getNumberOfProgressesInGroup:(NSInteger)group;

- (NSArray *)getProgressesInGroup:(NSInteger)group;

- (NSInteger)getNumberOfTasksOfProgressById:(NSString *)progressId inGroup:(NSInteger)group;

- (NSArray *)getTasksOfProgressById:(NSString *)progressId inGroup:(NSInteger)group;
@end
