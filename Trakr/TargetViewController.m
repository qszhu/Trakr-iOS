//
//  TargetViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "TargetViewController.h"
#import "Const.h"
#import "IUtils.h"
#import "Target.h"
#import "Parse/Parse.h"
#import "DeleteUtils.h"
#import "ODRefreshControl.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

static NSString * const kDidDeleteTargetNotification = @"DidDeleteTargetNotification";

@interface TargetViewController ()
@property(strong, nonatomic) NSArray *targets;
@property(strong, nonatomic) ODRefreshControl *rc;
@property(strong, nonatomic) DeleteUtils *deleteUtils;
@property(strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation TargetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.navigationItem setTitle:@"Targets"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateTarget:) name:kDidCreateTargetNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteTarget:) name:kDidDeleteTargetNotification object:nil];

    self.rc = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.rc addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];

    self.deleteUtils = [DeleteUtils new];

    [IUtils setRightBarAddButton:self action:@selector(createTargetPressed)];

    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"target view appear"];
}

- (void)createTargetPressed
{
    [TestFlight passCheckpoint:@"create target pressed"];

    UIStoryboard *createTargetStoryboard = [UIStoryboard storyboardWithName:@"CreateTarget" bundle:nil];
    UIViewController *createTargetVC = [createTargetStoryboard instantiateViewControllerWithIdentifier:@"CreateTargetViewController"];
    [self.navigationController pushViewController:createTargetVC animated:YES];
}

- (void)didCreateTarget:(NSNotification *)notification
{
    [self refresh];
}

- (void)didDeleteTarget:(NSNotification *)notification
{
    [self refresh];
}

- (void)pullToRefresh:(ODRefreshControl *)refreshControl {
    [self refresh];
}

- (void)refresh
{
    PFQuery *query = [Target query];
    [query includeKey:@"creator"];
    [query orderByDescending:@"updatedAt"];

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeNone];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(getTargets:error:)];
}

- (void)getTargets:(NSArray *)results error:(NSError *)error
{
    [SVProgressHUD dismiss];
    if (error) {
        [IUtils showErrorDialogWithTitle:@"Error" error:error];
        return;
    }

    self.targets = results;

    [self.tableView reloadData];
    [self.rc endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.targets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [IUtils recycleCellFromTableView:tableView];
    Target *target = [self.targets objectAtIndex:indexPath.row];
    cell.textLabel.text = target.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"created by %@ %@", target.creator.username, [IUtils relativeDate:target.createdAt]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Target *target = [self.targets objectAtIndex:indexPath.row];
    return [target.creator.objectId isEqualToString:[PFUser currentUser].objectId];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestFlight passCheckpoint:@"delete target"];

        self.selectedIndex = indexPath;
        Target *target = [self.targets objectAtIndex:indexPath.row];
        [self.deleteUtils delete:@"target" object:target inView:self.view withNotificationName:kDidDeleteTargetNotification];
    }
}

@end
