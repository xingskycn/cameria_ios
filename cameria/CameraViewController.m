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

#import "CameraViewController.h"

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*self.navigationController.navigationBar.hidden = YES;*/
       /* self.navigationController.navigationBar.translucent = YES;
        self.wantsFullScreenLayout = YES;*/
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
/*    self.navigationController.navigationBar.hidden = YES;*/
    /*self.navigationController.navigationBar.translucent = YES;*/
    /*self.wantsFullScreenLayout = YES;*/
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews) {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
   /* self.tabBarController.tabBar.hidden = YES;*/
    [self hideTabBar:self.tabBarController];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
   /* self.tabBarController.tabBar.hidden = NO;*/
    [self showTabBar:self.tabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
