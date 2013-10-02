//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface IUtils : NSObject
+ (NSString *)trim:(NSString *)aString;

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)errorMessage;

+ (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateByOffset:(NSInteger)offset fromDate:(NSDate *)date;

+ (void)setRightBarAddButton:(UIViewController *)viewController action:(SEL)action;

+ (void)dismissView:(UIViewController *)viewController;

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showErrorDialogWithTitle:(NSString *)title error:(NSError *)error;

+ (void)showValidationErrorDialog;

+ (void)logError:(NSError *)error;
@end