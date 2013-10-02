//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SignUpViewController.h"
#import "IUtils.h"
#import "LoginCommon.h"
#import "TestFlight.h"

@implementation SignUpViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.signUpView setLogo:[LoginCommon getTitleLabel]];

    [self setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"sign up view appear"];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL valid = YES;
    for (id key in info) {
        NSString *value = [info objectForKey:key];
        if (!value || value.length == 0) {
            valid = NO;
            break;
        }
    }
    if (!valid) {
        [IUtils showValidationErrorDialog];
    }
    return valid;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [IUtils dismissView:self];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    [IUtils logError:error];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
}

@end