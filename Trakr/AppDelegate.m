//
//  AppDelegate.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgressViewController.h"
#import "TaskViewController.h"
#import "SettingsViewController.h"
#import "MainViewController.h"
#import "Target.h"
#import "Task.h"
#import "Plan.h"
#import "TestFlight.h"

@implementation AppDelegate

- (void)parseInit:(NSDictionary *)launchOptions {
    [Target registerSubclass];
    [Task registerSubclass];
    [Plan registerSubclass];
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

    ProgressViewController *progressVC = [[ProgressViewController alloc] init];
    UINavigationController *progressNav = [[UINavigationController alloc] initWithRootViewController:progressVC];
    progressNav.tabBarItem.title = @"Progress";
    progressNav.tabBarItem.image = [UIImage imageNamed:@"first"];

    TaskViewController *taskVC = [[TaskViewController alloc] init];
    UINavigationController *taskNav = [[UINavigationController alloc] initWithRootViewController:taskVC];
    taskVC.tabBarItem.title = @"Task";
    taskVC.tabBarItem.image = [UIImage imageNamed:@"second"];

    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    SettingsViewController *settingsVC = [settingsStoryboard instantiateInitialViewController];
    UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    settingsVC.tabBarItem.title = @"Settings";
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"second"];

    MainViewController *mainVC = [[MainViewController alloc] init];
    [mainVC setViewControllers:@[taskNav, progressNav, settingsNav] animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:mainVC];
    [self.window makeKeyAndVisible];

    return YES;
}

@end