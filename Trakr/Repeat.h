//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

enum {
    kRepeatEveryDay = 1,
    kRepeatEveryWeek = 2,
    kRepeatEveryMonth = 4
};

@interface Repeat : NSObject
+ (NSArray *)names;

+ (NSString *)getNameForValue:(NSInteger)repeat;

+ (NSInteger)getValueAtIndex:(NSUInteger)index;

+ (NSUInteger)getIndexForValue:(NSInteger)repeat;

+ (BOOL)isValidRepeat:(NSInteger)repeat;
@end