//
//  PlanViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "PlanViewController.h"
#import "CreatePlanViewController.h"
#import "Plan.h"
#import "Target.h"
#import "Progress.h"
#import "Unit.h"
#import "Const.h"
#import "IUtils.h"
#import "DeleteUtils.h"
#import "ODRefreshControl.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

static NSString * const kDidDeletePlanNotification = @"DidDeletePlanNotification";

@interface PlanViewController () <UIActionSheetDelegate>
@property(strong, nonatomic) NSArray *plans;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) DeleteUtils *deleteUtils;
@property(strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation PlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.navigationItem setTitle:[NSString stringWithFormat:@"Plans for \"%@\"", self.target.name]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreatePlan:) name:kDidCreatePlanNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeletePlan:) name:kDidDeletePlanNotification object:nil];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];

    self.deleteUtils = [DeleteUtils new];

    [IUtils setRightBarAddButton:self action:@selector(createPlanPressed)];

    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"plan view appear"];
}

- (void)createPlanPressed
{
    [TestFlight passCheckpoint:@"create plan pressed"];

    UIStoryboard *createPlanStoryboard = [UIStoryboard storyboardWithName:@"CreatePlan" bundle:nil];
    CreatePlanViewController *createPlanVC = [createPlanStoryboard instantiateViewControllerWithIdentifier:@"CreatePlanViewController"];
    createPlanVC.target = self.target;
    UINavigationController *createPlanNav = [[UINavigationController alloc] initWithRootViewController:createPlanVC];
    [self presentViewController:createPlanNav animated:YES completion:nil];
}

- (void)didCreatePlan:(NSNotification *)notification
{
    [self refresh];
}

- (void)didDeletePlan:(NSNotification *)notification
{
    [self refresh];
}

- (void)pullToRefresh:(ODRefreshControl *)refreshControl {
    [self refresh];
}

- (void)refresh
{
    PFQuery *query = [Plan query];
    [query whereKey:@"target" equalTo:self.target];
    [query includeKey:@"target"];
    [query includeKey:@"creator"];
    [query includeKey:@"tasks"];
    [query orderByDescending:@"updatedAt"];

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(getPlans:error:)];
}

- (void)getPlans:(NSArray *)results error:(NSError *)error
{
    [SVProgressHUD dismiss];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }

    self.plans = results;

    [self.tableView reloadData];
    [self.rc endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.plans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [IUtils recycleCellFromTableView:tableView];
    Plan *plan = [self.plans objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d %@s in %d days", plan.total, [Unit getNameForValue:plan.unit], [plan getTaskSpan]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"created by %@ %@", plan.creator.username, [IUtils relativeDate:plan.createdAt]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TestFlight passCheckpoint:@"select plan"];

    self.selectedIndex = indexPath;
    [self createProgress];
}

- (void)createProgress {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Start this plan?"]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Start", nil];
    [sheet showInView:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    } else {
        Progress *progress = [Progress object];
        progress.plan = [self.plans objectAtIndex:self.selectedIndex.row];
        [SVProgressHUD showWithStatus:@"Creating progress..." maskType:SVProgressHUDMaskTypeGradient];
        [progress saveWithTarget:self selector:@selector(saveProgressWithResult:error:)];
    }
}

- (void)saveProgressWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create progress" error:error];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateProgressNotification object:self];
    [self.tabBarController setSelectedIndex:0];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Plan *plan = [self.plans objectAtIndex:indexPath.row];
    return [plan.creator.objectId isEqualToString:[PFUser currentUser].objectId];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestFlight passCheckpoint:@"delete plan"];

        Plan *plan = [self.plans objectAtIndex:indexPath.row];
        [self.deleteUtils delete:@"plan" object:plan inView:self.tabBarController.tabBar withNotificationName:kDidDeletePlanNotification];
    }
}

@end
