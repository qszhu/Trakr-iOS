//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

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