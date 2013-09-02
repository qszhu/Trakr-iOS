//
//  ProgressViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressDetailViewController.h"
#import "Progress.h"
#import "IUtils.h"
#import "SelectPlanViewController.h"
#import "Plan.h"
#import "Target.h"
#import "TestFlight.h"

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"My Progress"];

    [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"progress view appear"];
}

- (void)newPlanPressed {
    [TestFlight passCheckpoint:@"new plan pressed"];

    SelectPlanViewController *selectPlanVC = [[SelectPlanViewController alloc] init];
    selectPlanVC.progressVC = self;
    [self.navigationController pushViewController:selectPlanVC animated:YES];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Progress class])];
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        [query whereKey:@"creator" equalTo:user];
    }
    [query includeKey:@"plan"];
    [query includeKey:@"plan.target"];
    return query;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    Progress *progress = [[Progress alloc] initWithParseObject:object];
    cell.textLabel.text = progress.plan.target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d tasks", progress.completions.count, progress.plan.tasks.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select progress"];

    ProgressDetailViewController *progressDetailVC = [[ProgressDetailViewController alloc] init];
    PFObject *progress = [self.objects objectAtIndex:indexPath.row];
    progressDetailVC.progressId = progress.objectId;
    [self.navigationController pushViewController:progressDetailVC animated:YES];
}

@end