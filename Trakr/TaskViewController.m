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

@interface TaskViewController ()
@property(strong, nonatomic) NSArray *progresses;
@property(strong, nonatomic) NSArray *lateTodos;
@property(strong, nonatomic) NSArray *todayTodos;
@property(strong, nonatomic) NSArray *tomorrowTodos;
@property(strong, nonatomic) NSArray *futureTodos;
@end

static NSString *const kSectionLate = @"Late";
static NSString *const kSectionToday = @"Today";
static NSString *const kSectionTomorrow = @"Tomorrow";
static NSString *const kSectionFuture = @"This Week";

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"My Tasks"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    Todo *todo = [[self todosAtSection:indexPath.section] objectAtIndex:(NSUInteger) indexPath.row];
    if (!todo.isCompleted) {
        CompleteTaskViewController *completeTaskVC = [[CompleteTaskViewController alloc] init];
        completeTaskVC.todo = todo;
        [self presentViewController:completeTaskVC animated:YES completion:nil];
    }
}

@end