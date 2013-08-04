//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface IUtils : NSObject
+ (NSString *)trim:(NSString *)aString;

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)errorMessage;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (void)setRightBarAddButton:(UIViewController *)viewController action:(SEL)action;

+ (void)dismissView:(UIViewController *)viewController;

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showErrorDialogWithTitle:(NSString *)title error:(NSError *)error;

+ (void)showValidationErrorDialog;

+ (void)logError:(NSError *)error;
@end