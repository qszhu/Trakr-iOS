//
//  TodoUtils.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/4/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TodoUtils.h"
#import "CompleteTaskViewController.h"
#import "IUtils.h"
#import "Const.h"
#import "Setting.h"
#import "Todo.h"
#import "SVProgressHUD.h"

@interface TodoUtils()
@property(strong, nonatomic) UIViewController *viewController;
@property(strong, nonatomic) Todo *todo;
@end

@implementation TodoUtils

- (id)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)completeTodo:(Todo *)todo {
    self.todo = todo;
    if ([Setting taskShouldShowTimer]) {
        [self showCompleteTaskTimer];
    } else {
        [self showCompleteTaskDialog];
    }
}

- (void)showCompleteTaskTimer {
    CompleteTaskViewController *completeTaskVC = [[CompleteTaskViewController alloc] init];
    completeTaskVC.todo = self.todo;
    [self.viewController presentViewController:completeTaskVC animated:YES completion:nil];
}

- (void)showCompleteTaskDialog {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Complete this task?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self completeTodoWithCost:0];
    }
}

- (void)completeTodoWithCost:(NSInteger)cost {
    [self.todo completeWithCost:cost];
    [SVProgressHUD showWithStatus:@"Completing task..." maskType:SVProgressHUDMaskTypeGradient];
    [self.todo saveWithTarget:self selector:@selector(saveTodo:error:)];
}

- (void)saveTodo:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot complete task" error:error];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCompleteTaskNotification object:self];
}

@end
