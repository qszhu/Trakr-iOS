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
#import "Const.h"
#import "RATreeView.h"
#import "TestFlight.h"

@interface TaskViewController () <RATreeViewDelegate, RATreeViewDataSource>
@property(strong, nonatomic) NSArray *progresses;
@property(strong, nonatomic) NSDictionary *lateTodos;
@property(strong, nonatomic) NSDictionary *todayTodos;
@property(strong, nonatomic) NSDictionary *tomorrowTodos;
@property(strong, nonatomic) NSDictionary *futureTodos;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) Todo *todo;
@property(strong, nonatomic) RATreeView *treeView;
@property(nonatomic) BOOL loaded;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteTask:) name:kDidCompleteTaskNotification object:nil];
/*
    self.rc = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
 */
    self.treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;

    [self.view addSubview:self.treeView];
    [self refresh];
}

- (void)didLogin:(NSNotification *)notification {
    [self refresh];
}

- (void)didCompleteTask:(NSNotification *)notification {
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"task view appear"];
}
/*
 - (void)pullToRefresh:(ODRefreshControl *)refreshControl {
 [self refresh];
 }
 */
- (void)refresh {
    NSLog(@"refresh");
    self.loaded = NO;
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
    self.loaded = YES;
    NSLog(@"reload");
    [self.treeView reloadData];
/*
    [self.tableView reloadData];
    [self.rc endRefreshing];
 */
    [TestFlight passCheckpoint:@"task list reloaded"];
}

- (NSDictionary *)getTodoForType:(TaskType)taskType {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (Progress *progress in self.progresses) {
        NSString *key = [progress getParseObject].objectId;
        [dict setObject:[NSMutableArray new] forKey:key];
        for (Task *task in [progress getTasksForType:taskType]) {
            Todo *todo = [[Todo alloc] init];
            todo.progress = progress;
            todo.task = task;
            for (Completion *completion in progress.completions) {
                if ([[completion.task objectId] isEqualToString:[task objectId]]) {
                    todo.completion = completion;
                }
            }
            [[dict objectForKey:key] addObject:todo];
        }
        if ([[dict objectForKey:key] count] == 0) {
            [dict removeObjectForKey:key];
        }
    }
    return dict;
}

- (void)reloadTasks {
    self.lateTodos = [self getTodoForType:TaskTypeLate];
    self.todayTodos = [self getTodoForType:TaskTypeToday];
    self.tomorrowTodos = [self getTodoForType:TaskTypeTomorrow];
    self.futureTodos = [self getTodoForType:TaskTypeFuture];
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
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCompleteTaskNotification object:self];
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (!self.loaded) {
        return 0;
    }
    NSInteger res = 0;
    if (item == nil) {
        if (self.lateTodos.count > 0) res++;
        if (self.todayTodos.count > 0) res++;
        if (self.tomorrowTodos.count > 0) res++;
        if (self.futureTodos.count > 0) res++;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        res = ((NSDictionary *)item).count;
    } else if ([item isKindOfClass:[NSArray class]]) {
        res = ((NSArray *)item).count;
    }
    return res;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (item == nil) {
        switch (index) {
            case 0:
                return self.lateTodos;
            case 1:
                return self.todayTodos;
            case 2:
                return self.tomorrowTodos;
            default:
                return self.futureTodos;
        }
    }
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = item;
        return [dict objectForKey:[[dict allKeys] objectAtIndex:index]];
    }
    return [((NSArray *)item) objectAtIndex:index];
}

- (void)underlineCellText:(UITableViewCell *)cell on:(BOOL)on {
    NSDictionary *attributes = @{NSStrikethroughStyleAttributeName : on ? @1 : @0};
    if (cell.textLabel.text != nil) {
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text
                                                                        attributes:attributes];
    }
    if (cell.detailTextLabel.text != nil) {
        cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.detailTextLabel.text
                                                                              attributes:attributes];
    }
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    [self underlineCellText:cell on:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (item == self.lateTodos) {
        cell.textLabel.text = kSectionLate;
    } else if (item == self.todayTodos) {
        cell.textLabel.text = kSectionToday;
    } else if (item == self.tomorrowTodos) {
        cell.textLabel.text = kSectionTomorrow;
    } else if (item == self.futureTodos) {
        cell.textLabel.text = kSectionFuture;
    } else if ([item isKindOfClass:[NSArray class]]) {
        Todo *todo = [((NSArray *)item) objectAtIndex:0];
        cell.textLabel.text = todo.progress.plan.target.name;
    } else {
        Todo *todo = item;
        cell.textLabel.text = ((Todo *)item).task.name;
        if (!todo.isCompleted) {
            NSDate *taskDate = [IUtils dateByOffset:todo.task.offset fromDate:todo.progress.startDate];
            cell.detailTextLabel.text = [IUtils stringFromDate:taskDate];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"completed in %d minutes", todo.completion.cost / 60];
            [self underlineCellText:cell on:YES];
        }
    }
    return cell;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    if (![item isKindOfClass:[Todo class]]) return;
    [TestFlight passCheckpoint:@"select todo"];

    Todo *todo = item;
    if (todo.isCompleted) {
        return;
    }
    if ([Setting taskShouldShowTimer]) {
        [self showCompleteTaskTimer:todo];
    } else {
        [self showCompleteTaskDialog:todo];
    }
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel {
    return treeDepthLevel == 0;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo {
    return NO;
}

@end