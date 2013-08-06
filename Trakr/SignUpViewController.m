//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SignUpViewController.h"
#import "IUtils.h"

@implementation SignUpViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"Trakr";
    label.font = [UIFont systemFontOfSize:36];
    label.textColor = [UIColor lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [self.signUpView setLogo:label];

    [self setDelegate:self];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info {
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

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user {
    [IUtils dismissView:self];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController
    didFailToSignUpWithError:(NSError *)error {
    [IUtils logError:error];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {

}

@end