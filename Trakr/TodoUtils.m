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
#import "SWTableViewCell.h"

@interface TodoUtils()
@property(strong, nonatomic) UIViewController *viewController;
@property(strong, nonatomic) Todo *todo;
@property(nonatomic) BOOL uncomplete;
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
    self.uncomplete = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Complete this task?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)showUncompleteTaskDialog:(Todo *)todo {
    self.todo = todo;
    self.uncomplete = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Uncomplete this task?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (self.uncomplete) {
            [self uncompleteTodo:self.todo];
        } else {
            [self completeTodo:self.todo withCost:0];
        }
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

- (void)uncompleteTodo:(Todo *)todo {
    [todo uncomplete];
    [SVProgressHUD showWithStatus:@"Uncompleting task..." maskType:SVProgressHUDMaskTypeGradient];
    [todo saveWithTarget:self selector:@selector(uncompleteTodo:error:)];
}

- (void)uncompleteTodo:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot uncomplete task" error:error];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCompleteTaskNotification object:self]; // reused notification
}

+ (SWTableViewCell *)recycleSWCellFromTableView:(UITableView *)tableView delegate:(id)delegate completed:(BOOL)completed {
    static NSString *cellIdentifier = @"SWCell";
    static NSString *cellIdentifierCompleted = @"SWCellCompleted";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:completed ? cellIdentifierCompleted : cellIdentifier];
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];

        if (completed) {
            [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                     icon:[UIImage imageNamed:@"cross.png"]];
        } else {
            [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                     icon:[UIImage imageNamed:@"check.png"]];
            [leftUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                     icon:[UIImage imageNamed:@"clock.png"]];
        }

        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:completed ? cellIdentifierCompleted : cellIdentifier
                                  containingTableView:tableView
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:nil];
        cell.delegate = delegate;
    }
    [IUtils resetTableViewCell:cell];
    return cell;
}

@end
