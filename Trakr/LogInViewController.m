//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "LogInViewController.h"
#import "IUtils.h"
#import "TestFlight.h"

@implementation LogInViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"Trakr";
    label.font = [UIFont systemFontOfSize:36];
    label.textColor = [UIColor lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [self.logInView setLogo:label];

    [self setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"log in view appear"];
}

- (BOOL) logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
                    password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }

    [IUtils showValidationErrorDialog];
    return NO;
}

- (void)logInViewController:(PFLogInViewController *)logInController
               didLogInUser:(PFUser *)user {
    [IUtils dismissView:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginNotification object:self];
}

- (void)logInViewController:(PFLogInViewController *)logInController
    didFailToLogInWithError:(NSError *)error {
    [IUtils logError:error];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
}

@end