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

@synthesize navigationVisible = _navigationVisible;
@synthesize cameras = _cameras;
@synthesize cameraViews = _cameraViews;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cameraViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // enables the user interaction so that the touch events
    // are gathered and correctly handled
    self.scrollView.userInteractionEnabled = YES;
    
    self.title = @"Camera";

    // creates the complete set of cameras panels to be used
    // to display the cameras (eager creation), this should
    // consume some resources (depending on the range of
    // cameras to be used)
    [self createCameras];

    // creates the tap recognizer object to be to toggle the
    // visibility of the header panels and then sets it in the
    // current sctroll view panel reference
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    self.wantsFullScreenLayout = YES;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(pageWidth * [self.cameras count], pageHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.navigationController.navigationBar setAlpha:0.0];
    [UIView commitAnimations];
    [self hideTabBar:self.tabBarController];
    self.navigationVisible = NO;
    
    self.navigationController.navigationBar.topItem.title = @"nova camera";
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setAlpha:1.0];
    [self showTabBar:self.tabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(pageWidth * [self.cameras count], pageHeight);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(self.navigationVisible == NO) { [[UIApplication sharedApplication] setStatusBarHidden:YES]; }
}

- (IBAction)handleTap:(id)sender {
    if(self.navigationVisible) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [self.navigationController.navigationBar setAlpha:0.0];
        [UIView commitAnimations];
        self.navigationVisible = NO;
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [self.navigationController.navigationBar setAlpha:1.0];
        [UIView commitAnimations];
        self.navigationVisible = YES;
    }
}

- (void)createCameras {
    // retrieves the size of a scroll page (both width and
    // thei height of it) to be able to position the cameraS
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    // iterates over the complete set of cameras to be
    // displayed in the current panel
    for(int index = 0; index < [self.cameras count]; index++) {
        // retrieves the current camera (for the current index) and
        // then unpacks it into the name and url
        NSArray *camera = self.cameras[index];
        NSString *cameraUrl = camera[1];
        
        // creates the "final" url structure for the current camera
        // to be used in the motion image connection
        NSURL *url = [NSURL URLWithString:cameraUrl];
        
        // retrieves the current view associated as a motion jpeg
        // image view to be used for visualization
        MotionJpegImageView *imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(index * pageWidth, 0, pageWidth, pageHeight)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        // sets the "target" url value in the image view and then
        // starts playing the motion image (loading started)
        imageView.url = url;
        [imageView play];
        
        // adds the image view panel to the scroll view push it
        // into the end of the video panels "stack"
        [self.scrollView addSubview:imageView];
    }
}

- (void) hideTabBar:(UITabBarController *) tabBarController {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    float fHeight = screenRect.size.height;
    if(UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        fHeight = screenRect.size.width;
    }
    for(UIView *view in tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            view.backgroundColor = [UIColor blackColor];
        }
    }
    [UIView commitAnimations];
}

- (void) showTabBar:(UITabBarController *) tabBarController {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - 49.0;
    
    if(UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        fHeight = screenRect.size.width - 49.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    for(UIView *view in tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
        }
    }
    [UIView commitAnimations];
}

@end
