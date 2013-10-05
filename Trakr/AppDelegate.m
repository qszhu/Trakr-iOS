//
//  AppDelegate.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "AppDelegate.h"
#import "TaskViewController.h"
#import "TargetViewController.h"
#import "MainViewController.h"
#import "Target.h"
#import "Task.h"
#import "Plan.h"
#import "Completion.h"
#import "Progress.h"
#import "TestFlight.h"

@implementation AppDelegate

- (void)parseInit:(NSDictionary *)launchOptions {
    [Target registerSubclass];
    [Task registerSubclass];
    [Plan registerSubclass];
    [Completion registerSubclass];
    [Progress registerSubclass];
    [Parse setApplicationId:@"vWqZkcSCvOlkcGltPDBYwy9Gt5k1cZyBMI32WVpl"
                  clientKey:@"bligFq7ajuGKzzM17eTRUp5PQRd8aUv6frJ8rAU0"];

//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

//    [PFUser logOut];

    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TestFlight takeOff:@"530feffc-44ab-461c-bc5d-bdfd5fa53fe6"];

    [self parseInit:launchOptions];
/*
    ProgressViewController *progressVC = [ProgressViewController new];
    UINavigationController *progressNav = [[UINavigationController alloc] initWithRootViewController:progressVC];
    progressNav.tabBarItem.title = @"Progress";
    progressNav.tabBarItem.image = [UIImage imageNamed:@"first"];
*/
    TaskViewController *taskVC = [TaskViewController new];
    UINavigationController *taskNav = [[UINavigationController alloc] initWithRootViewController:taskVC];
    taskVC.tabBarItem.title = @"Tasks";
    taskVC.tabBarItem.image = [UIImage imageNamed:@"second"];

    TargetViewController *targetVC = [TargetViewController new];
    UINavigationController *targetNav = [[UINavigationController alloc] initWithRootViewController:targetVC];
    targetVC.tabBarItem.title = @"Targets";
    targetVC.tabBarItem.image = [UIImage imageNamed:@"first"];

    MainViewController *mainVC = [[MainViewController alloc] init];
    [mainVC setViewControllers:@[taskNav, targetNav] animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:mainVC];
    [self.window makeKeyAndVisible];

    return YES;
}

@end