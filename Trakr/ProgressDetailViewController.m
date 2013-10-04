//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressDetailViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "Plan.h"
#import "Completion.h"
#import "TestFlight.h"

@interface ProgressDetailViewController()
@property (strong, nonatomic) Progress *progress;
@end

@implementation ProgressDetailViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [Progress query];
    [query includeKey:@"plan.target"];
    [query includeKey:@"plan.tasks"];
    [query includeKey:@"completions.task"];
    [query getObjectInBackgroundWithId:self.progressId target:self selector:@selector(getProgress:error:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"progress detail view appear"];
}

- (void)getProgress:(PFObject *)progress error:(NSError *)error {
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }
    self.progress = (Progress *)progress;
    [self.navigationItem setTitle:[self.progress getName]];

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.progress == nil) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return self.progress.plan.tasks.count;
}

- (NSString *)getTaskStatus:(Task *)task {
    NSDate *taskDate = [task getDate:self.progress.startDate];
    for (Completion *completion in self.progress.completions) {
        if ([[completion.task objectId] isEqualToString:[task objectId]]) {
            return [NSString stringWithFormat:@" / %@", [IUtils stringFromDate:taskDate]];
        }
    }
    NSInteger lateDays = [IUtils daysBetween:taskDate and:[NSDate date]];
    if (lateDays > 0) {
        return [NSString stringWithFormat:@" / %d days late", lateDays];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.progress == nil) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Task *task = [self.progress.plan.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",
                                 [IUtils stringFromDate:[task getDate:self.progress.startDate]], [self getTaskStatus:task]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end