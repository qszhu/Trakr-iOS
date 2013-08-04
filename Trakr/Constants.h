//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Constants : NSObject

+ (NSDictionary *)UNIT;

+ (NSNumber *)getUnitForName:(NSString *)name;

+ (NSString *)getNameForUnit:(NSNumber *)unit;

+ (NSString *)getUnitNameAtIndex:(NSUInteger)index;

+ (NSDictionary *)REPEAT;

@end