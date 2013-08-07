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
#import "MainViewController.h"

@implementation AppDelegate

- (void)parseInit:(NSDictionary *)launchOptions {
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
    [self parseInit:launchOptions];

    ProgressViewController *progressVC = [[ProgressViewController alloc] init];
    UINavigationController *progressNav = [[UINavigationController alloc] initWithRootViewController:progressVC];
    progressNav.tabBarItem.title = @"Progress";
    progressNav.tabBarItem.image = [UIImage imageNamed:@"first.png"];

    TaskViewController *taskVC = [[TaskViewController alloc] init];
    UINavigationController *taskNav = [[UINavigationController alloc] initWithRootViewController:taskVC];
    taskVC.tabBarItem.title = @"Task";
    taskVC.tabBarItem.image = [UIImage imageNamed:@"second.png"];

    MainViewController *mainVC = [[MainViewController alloc] init];
    [mainVC setViewControllers:@[taskNav, progressNav] animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:mainVC];
    [self.window makeKeyAndVisible];

    return YES;
}

@end