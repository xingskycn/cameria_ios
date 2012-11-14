// Hive Cameria Service
// Copyright (C) 2008-2012 Hive Solutions Lda.
//
// This file is part of Hive Cameria Service.
//
// Hive Cameria Service is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Hive Cameria Service is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Hive Cameria Service. If not, see <http://www.gnu.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision$
// __date__      = $LastChangedDate$
// __copyright__ = Copyright (c) 2008-2012 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "AppDelegate.h"

#import "SetsViewController.h"
#import "CamerasViewController.h"
#import "CreditsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // initializes the default values in the preferences structure
    // in case they don't already exist (and are defined)
    [self setDefaults];

    // creates a new window object and sets it in the current application
    // (this should be the main window of the application)
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // creates the various view controller to be used as entrance for the complete
    // sets of tabs (this are the main view controllers)
    _setsViewController = [[SetsViewController alloc] initWithNibName:@"SetsViewController" bundle:nil];
    _camerasViewController = [[CamerasViewController alloc] initWithNibName:@"CamerasViewController" bundle:nil];
    _creditsViewController = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];

    // creates the navigation view controllers for both the sets and the cameras and
    // starts them with the correct sets of view controllers
    _setsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:_setsViewController];
    _camerasNavigationViewController = [[UINavigationController alloc] initWithRootViewController:_camerasViewController];

    // creates the "main" tab bar controler then sets the various tabs in it and sets
    // it as the root view controller for the window
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[_setsNavigationViewController, _camerasNavigationViewController, _creditsViewController];
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];

    // returns success, application started with success
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // pauses the image view to avoid extra
    // usage of traffic (bandwidth waste)
    if(self.cameraViewHandler) { [self.cameraViewHandler pauseCameras]; }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // resumes the playback of the image views
    // bandwidth is used again, not that the status
    // bar must be updated to the "correct" status
    if(self.cameraViewHandler) {
        [self.cameraViewHandler playCameras];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self performSelector:@selector(updateNavigation) withObject:nil afterDelay:0];
    }
}

- (void)reset {
    // "resets" the currently selected tab to the first (this is
    // considered to be the initial value)
    _tabBarController.selectedIndex = 0;
    
    // pops the complete set if view controller in both navigation
    // controllers until the root view controller is reached
    [_setsNavigationViewController popToRootViewControllerAnimated:NO];
    [_camerasNavigationViewController popToRootViewControllerAnimated:NO];
    
    // runs the reet operation on both the sets and
    // the cameras controller (global reset)
    [_setsViewController reset];
    [_camerasViewController reset];
}

- (void)setDefaults {
    // retrieves the current preferences structure and tries to
    // retrieve the values that are considered basic, in order
    // to check if theya are already defined
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *baseUrl = [preferences valueForKey:@"baseUrl"];

    // checks various value for the presence of the value and in
    // case it's not defined sets the default value, then flushes
    // the preferences to the secondary storage
    if(baseUrl == nil) { [preferences setValue:@"https://cameria-staging.herokuapp.com/"
                                        forKey:@"baseUrl"]; }
    [preferences synchronize];
}

- (void)updateNavigation {
    if(self.cameraViewHandler.navigationVisible == YES) { return; }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

@end
