//
//  Setting.m
//  Trakr
//
//  Created by Qinsi ZHU on 9/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "Setting.h"

static NSString *const kTaskShouldShowTimer = @"task_should_show_timer";

@interface Setting()
@end

@implementation Setting

+ (BOOL)taskShouldShowTimer {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTaskShouldShowTimer];
}

+ (void)setTaskShouldShowTimer:(BOOL)taskShouldShowTimer {
    [[NSUserDefaults standardUserDefaults] setBool:taskShouldShowTimer forKey:kTaskShouldShowTimer];
}

@end
