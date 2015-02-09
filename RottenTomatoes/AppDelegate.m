//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Charlie Hu on 2/4/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  MoviesViewController *movieVc = [[MoviesViewController alloc] init];
  movieVc.mediaType = MOVIE;
  UINavigationController *movieNvc = [[UINavigationController alloc] initWithRootViewController:movieVc];
  movieNvc.tabBarItem.title = @"Box Office";
  movieNvc.tabBarItem.image = [UIImage imageNamed:@"movie_16.png"];

  MoviesViewController *dvdVc = [[MoviesViewController alloc] init];
  dvdVc.mediaType = DVD;
  UINavigationController *dvdNvc = [[UINavigationController alloc] initWithRootViewController:dvdVc];
  dvdNvc.tabBarItem.title = @"DVDs";
  dvdNvc.tabBarItem.image = [UIImage imageNamed:@"dvd_16.png"];

  // Configure the tab bar controller with the two navigation controllers
  UITabBarController *tbc = [[UITabBarController alloc] init];
  tbc.viewControllers = @[movieNvc, dvdNvc];

  self.window.rootViewController = tbc;

  //self.window.rootViewController = nvc;

  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
