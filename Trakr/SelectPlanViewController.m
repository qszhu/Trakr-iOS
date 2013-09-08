//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectPlanViewController.h"
#import "IUtils.h"
#import "CreatePlanViewController.h"
#import "Plan.h"
#import "Target.h"
#import "Progress.h"
#import "ProgressViewController.h"
#import "Unit.h"
#import "SVProgressHUD.h"
#import "Const.h"
#import "TestFlight.h"

@interface SelectPlanViewController()
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation SelectPlanViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Select Plan";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreatePlan:) name:kDidCreatePlanNotification object:nil];

    [IUtils setRightBarAddButton:self action:@selector(createPlanPressed)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"select plan view appear"];
}

- (void)didCreatePlan:(NSNotification *)notification {
    [self loadObjects];
}

- (void)createPlanPressed {
    [TestFlight passCheckpoint:@"create plan pressed"];

    UIStoryboard *createPlanStoryboard = [UIStoryboard storyboardWithName:@"CreatePlan" bundle:nil];
    UINavigationController *createPlanNav = [createPlanStoryboard instantiateInitialViewController];
    [self presentViewController:createPlanNav animated:YES completion:nil];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Plan class])];
    [query includeKey:@"target"];
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

    Plan *plan = [[Plan alloc] initWithParseObject:object];
    cell.textLabel.text = plan.target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@s", plan.total, [Unit getNameForValue:plan.unit]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select plan"];

    Progress *progress = [[Progress alloc] init];
    Plan *plan = [[Plan alloc] initWithParseObject:[self.objects objectAtIndex:(NSUInteger) indexPath.row]];
    progress.plan = plan;
    [SVProgressHUD showWithStatus:@"Creating progress..." maskType:SVProgressHUDMaskTypeGradient];
    [progress saveWithTarget:self selector:@selector(saveProgressWithResult:error:)];
}

- (void)saveProgressWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if ([result boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.progressVC loadObjects];
    } else {
        [IUtils showErrorDialogWithTitle:@"Cannot create progress" error:error];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedIndex = indexPath;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete this plan?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                                  otherButtonTitles:nil];
        [sheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [TestFlight passCheckpoint:@"delete plan"];

        [SVProgressHUD showWithStatus:@"Deleting plan..." maskType:SVProgressHUDMaskTypeGradient];
        [[self.objects objectAtIndex:self.selectedIndex.row] deleteInBackgroundWithTarget:self selector:@selector(deletePlanWithResult:error:)];
    }
}

- (void)deletePlanWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot delete plan" error:error];
        return;
    }
    [self loadObjects];
}


@end