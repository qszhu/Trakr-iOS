//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

extern NSString *const kRepeatEveryDay;
extern NSString *const kRepeatEveryWeek;
extern NSString *const kRepeatEveryMonth;

@interface Repeat : NSObject
+ (NSUInteger)count;

+ (NSArray *)names;

+ (NSUInteger)getIndexForValue:(NSNumber *)value;

+ (NSNumber *)getValueForName:(NSString *)name;

+ (NSString *)getNameForValue:(NSNumber *)unit;

+ (NSString *)getNameAtIndex:(NSUInteger)index;

+ (NSNumber *)getValueAtIndex:(NSUInteger)index;
@end