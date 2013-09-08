//
//  TaskViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TaskViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "Task.h"
#import "SVProgressHUD.h"
#import "Todo.h"
#import "Plan.h"
#import "Target.h"
#import "CompleteTaskViewController.h"
#import "Completion.h"
#import "ODRefreshControl.h"
#import "Setting.h"
#import "LogInViewController.h"
#import "TestFlight.h"

@interface TaskViewController ()
@property(strong, nonatomic) NSArray *progresses;
@property(strong, nonatomic) NSArray *lateTodos;
@property(strong, nonatomic) NSArray *todayTodos;
@property(strong, nonatomic) NSArray *tomorrowTodos;
@property(strong, nonatomic) NSArray *futureTodos;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) Todo *todo;
@end

static NSString *const kSectionLate = @"Late";
static NSString *const kSectionToday = @"Today";
static NSString *const kSectionTomorrow = @"Tomorrow";
static NSString *const kSectionFuture = @"This Week";

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"My Tasks"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kDidLoginNotification object:nil];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self refresh];
}

- (void)didLogin:(NSNotification *)notification {
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"task view appear"];
}

- (void)pullToRefresh:(ODRefreshControl *)refreshControl {
    [self refresh];
}

- (void)refresh {
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Progress class])];
        [query whereKey:@"creator" equalTo:user];
        [query includeKey:@"plan"];
        [query includeKey:@"plan.target"];
        [query includeKey:@"plan.tasks"];
        [query includeKey:@"completions"];

        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(getPlans:error:)];
    }
}

- (void)getPlans:(NSArray *)results error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        [array addObject:[[Progress alloc] initWithParseObject:object]];
    }
    self.progresses = [NSArray arrayWithArray:array];
    [self reloadTasks];

    [self.tableView reloadData];
    [self.rc endRefreshing];
    [TestFlight passCheckpoint:@"task list reloaded"];
}

- (NSArray *)getTodoForType:(TaskType)taskType {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Progress *progress in self.progresses) {
        for (Task *task in [progress getTasksForType:taskType]) {
            Todo *todo = [[Todo alloc] init];
            todo.progress = progress;
            todo.task = task;
            for (Completion *completion in progress.completions) {
                if ([[[completion.task getParseObject] objectId] isEqualToString:[[task getParseObject] objectId]]) {
                    todo.completion = completion;
                }
            }
            [array addObject:todo];
        }
    }
    return [NSArray arrayWithArray:array];
}

- (void)reloadTasks {
    self.lateTodos = [self getTodoForType:TaskTypeLate];
    self.todayTodos = [self getTodoForType:TaskTypeToday];
    self.tomorrowTodos = [self getTodoForType:TaskTypeTomorrow];
    self.futureTodos = [self getTodoForType:TaskTypeFuture];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return kSectionToday;
        case 2:
            return kSectionTomorrow;
        case 3:
            return kSectionFuture;
        default:
            return kSectionLate;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return self.todayTodos == nil ? 0 : self.todayTodos.count;
        case 2:
            return self.tomorrowTodos == nil ? 0 : self.tomorrowTodos.count;
        case 3:
            return self.futureTodos == nil ? 0 : self.futureTodos.count;
        default:
            return self.lateTodos == nil ? 0 : self.lateTodos.count;
    }
}

- (NSArray *)todosAtSection:(NSInteger)section {
    switch (section) {
        case 1:
            return self.todayTodos;
        case 2:
            return self.tomorrowTodos;
        case 3:
            return self.futureTodos;
        default:
            return self.lateTodos;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSArray *todos = [self todosAtSection:indexPath.section];
    Todo *todo = [todos objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = todo.progress.plan.target.name;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!todo.isCompleted) {
        NSDate *taskDate = [IUtils dateByOffset:todo.task.offset fromDate:todo.progress.startDate];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@",
                                                               todo.task.name, [IUtils stringFromDate:taskDate]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : completed in %d minutes",
                                                               todo.task.name, todo.completion.cost / 60];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName : @1};
        cell.textLabel.attributedText = [[NSAttributedString alloc]
                initWithString:cell.textLabel.text
                    attributes:attributes];
        cell.detailTextLabel.attributedText = [[NSAttributedString alloc]
                initWithString:cell.detailTextLabel.text
                    attributes:attributes];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select todo"];

    Todo *todo = [[self todosAtSection:indexPath.section] objectAtIndex:(NSUInteger) indexPath.row];
    if (todo.isCompleted) {
        return;
    }
    if ([Setting taskShouldShowTimer]) {
        [self showCompleteTaskTimer:todo];
    } else {
        [self showCompleteTaskDialog:todo];
    }
}

- (void)showCompleteTaskTimer:(Todo *)todo {
    CompleteTaskViewController *completeTaskVC = [[CompleteTaskViewController alloc] init];
    completeTaskVC.todo = todo;
    [self presentViewController:completeTaskVC animated:YES completion:nil];
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        // TODO: DRY
        Completion *completion = [[Completion alloc] init];
        completion.task = self.todo.task;
        completion.cost = 0;
        completion.date = [NSDate date];
        self.todo.progress.completions = [self.todo.progress.completions arrayByAddingObject:completion];
        [SVProgressHUD showWithStatus:@"Completing task..." maskType:SVProgressHUDMaskTypeGradient];
        [self.todo.progress saveWithTarget:self selector:@selector(saveProgress:error:)];
    }
}

- (void)saveProgress:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot complete task" error:error];
    }
}

@end