//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "IUtils.h"


@implementation IUtils {

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

+ (void)showValidationErrorDialog {
    [self showDialogWithTitle:@"Missing Information"
                      message:@"Make sure you fill out all of the information!"];
}

+ (void)logError:(NSError *)error {
    NSLog(@"Error: %@", [[error userInfo] objectForKey:@"error"]);
}
@end