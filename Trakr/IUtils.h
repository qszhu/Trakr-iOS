//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface IUtils : NSObject
+ (void)dismissView:(UIViewController *)viewController;

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showValidationErrorDialog;

+ (void)logError:(NSError *)error;
@end