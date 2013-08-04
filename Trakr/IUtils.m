//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "IUtils.h"


@implementation IUtils {

}

+ (NSString *)trim:(NSString *)aString {
    return [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)errorMessage {
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:errorMessage forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"world" code:errorCode userInfo:details];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

+ (void)setRightBarAddButton:(UIViewController *)viewController action:(SEL)action {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:viewController
                                 action:action];
    viewController.navigationItem.rightBarButtonItem = btn;
}

+ (void)dismissView:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (void)showErrorDialogWithTitle:(NSString *)title error:(NSError *)error {
    [self showDialogWithTitle:title message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
}

+ (void)showValidationErrorDialog {
    [self showDialogWithTitle:@"Missing Information"
                      message:@"Make sure you fill out all of the information!"];
}

+ (void)logError:(NSError *)error {
    NSLog(@"Error: %@", [[error userInfo] objectForKey:NSLocalizedDescriptionKey]);
}

@end