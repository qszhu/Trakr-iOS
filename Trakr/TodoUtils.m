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
    if ([Setting taskShouldShowTimer]) {
        [self showCompleteTaskTimer:todo];
    } else {
        [self showCompleteTaskDialog:todo];
    }
}

- (void)showCompleteTaskTimer:(Todo *)todo {
    CompleteTaskViewController *completeTaskVC = [[CompleteTaskViewController alloc] init];
    completeTaskVC.todo = todo;
    [self.viewController presentViewController:completeTaskVC animated:YES completion:nil];
}

- (void)showCompleteTaskDialog:(Todo *)todo {
    self.todo = todo;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Complete this task?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self completeTodo:self.todo withCost:0];
    }
}

- (void)completeTodo:(Todo *)todo withCost:(NSInteger)cost {
    [todo completeWithCost:cost];
    [SVProgressHUD showWithStatus:@"Completing task..." maskType:SVProgressHUDMaskTypeGradient];
    [todo saveWithTarget:self selector:@selector(saveTodo:error:)];
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
