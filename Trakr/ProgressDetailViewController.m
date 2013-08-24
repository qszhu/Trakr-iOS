//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressDetailViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "Plan.h"
#import "Task.h"
#import "TestFlight.h"

@implementation ProgressDetailViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"progress detail view load"];

    [self.navigationItem setTitle:@"Tasks"];

    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Progress class])];
    [query includeKey:@"plan.tasks"];
    [query includeKey:@"completions"];
    [query getObjectInBackgroundWithId:self.progressId
                                target:self
                              selector:@selector(getProgress:error:)];
}

- (void)getProgress:(PFObject *)progress error:(NSError *)error {
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }
    self.progress = [[Progress alloc] initWithParseObject:progress];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.progress == nil) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return self.progress.plan.tasks.count;
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
    Task *task = [self.progress.plan.tasks objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = task.name;
    NSDate *taskDate = [IUtils dateByOffset:task.offset fromDate:self.progress.startDate];
    cell.detailTextLabel.text = [IUtils stringFromDate:taskDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end