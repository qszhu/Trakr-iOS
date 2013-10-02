//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

enum {
    kUnitChapter = 1,
    kUnitPage = 2
};

@interface Unit : NSObject
+ (NSArray *)names;

+ (NSString *)getNameForValue:(NSInteger)unit;

+ (NSInteger)getValueAtIndex:(NSUInteger)index;

+ (NSUInteger)getIndexForValue:(NSInteger)unit;

+ (BOOL)isValidUnit:(NSInteger)unit;
@end