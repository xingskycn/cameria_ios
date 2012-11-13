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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationVisible = NO;
        self.pageIndex = 0;
        self.cameraViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // updates the scroll view frame so that it's possible to
    // use a black margin to separate the various pages
    self.scrollView.frame = CGRectMake(
        0, 0, self.scrollView.frame.size.width + BLACK_MARGIN_SIZE, self.scrollView.frame.size.height
    );

    // sets the delegate for the assiciated scroll view
    // as the current controller this should allow it to
    // handle the scroll "events"
    self.scrollView.delegate = self;

    // enables the user interaction so that the touch events
    // are gathered and correctly handled
    self.view.userInteractionEnabled = YES;

    // creates the complete set of cameras panels to be used
    // to display the cameras (eager creation), this should
    // consume some resources (depending on the range of
    // cameras to be used)
    [self createCameras];

    // retrieves the reference to the "first" camera and uses
    // its name as the title of the current view
    NSArray *camera = self.cameras[0];
    NSString *cameraName = camera[0];
    self.title = cameraName;

    // creates the tap recognizer object to be to toggle the
    // visibility of the header panels and then sets it in the
    // current scroll view panel reference
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    // creates the structure for the refresh button and then adds
    // itto the right of the navigation panel
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(refreshClick:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(pageWidth * [self.cameras count], pageHeight);
    
    // updates the current page so that the value remains
    // exactly the same as the one in the previous position
    [self setPage:self.pageIndex animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.navigationController.navigationBar setAlpha:0.0];
    [UIView commitAnimations];
    [self hideTabBar:self.tabBarController];
    self.navigationVisible = NO;

    // retrieves the reference to the current application delegate
    // and sets the camera view handler in it so that it's able
    // to stop the current cameras in case the application resigns
    // as active (provides bandwidth saving)
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.cameraViewHandler = self;

    // starts the playback of the motion in the various
    // camera views contained in the object
    [self playCameras];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setAlpha:1.0];
    [self showTabBar:self.tabBarController];
    
    // calculates the current page index using the currently set page
    // width and then stores it for latter usage
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float pageNumberFloat = self.scrollView.contentOffset.x / pageWidth;
    self.pageIndex = lround(pageNumberFloat);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // retrieves the reference to the current application delegate
    // and unsets the camera view handler reference in it, no need
    // to stop cameras that are already stopped
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.cameraViewHandler = nil;

    // pauses the playback of the motion in the various
    // camera views contained in the object
    [self pauseCameras];
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

    // calculates the current page index using the currently set page
    // width and then stores it for latter usage
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float pageNumberFloat = self.scrollView.contentOffset.x / pageWidth;
    self.pageIndex = lround(pageNumberFloat);

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if(self.navigationVisible == NO) { [[UIApplication sharedApplication] setStatusBarHidden:YES]; }

    // updates the current page so that the value remains
    // exactly the same as the one in the previous position
    [self setPage:self.pageIndex animated:NO];
}

- (IBAction)handleTap:(id)sender {
    // shows or hides the currently displayed header
    // according to the current navigation visibility
    if(self.navigationVisible) { [self hideHeader]; }
    else { [self showHeader]; }
}

- (IBAction)refreshClick:(id)sender {
    // runs the play cameras operation so that a new
    // tryout is done to the loading of the stream
    [self playCameras];
}

- (void)createCameras {
    // retrieves the size of a scroll page (both width and
    // thei height of it) to be able to position the cameraS
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;

    // calculates the "virtual" size of a page in order to be
    // able to use the "black margin" between pages"
    CGFloat _pageWidth = self.scrollView.frame.size.width - BLACK_MARGIN_SIZE;

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

        // creates the image view container that will contain the image
        // in order to provide capabilities for the "black margin"
        UIView *imageContainerView = [[UIView alloc] initWithFrame:CGRectMake(index * pageWidth, 0, pageWidth, pageHeight)];
        imageContainerView.backgroundColor = [UIColor blackColor];
        imageContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

        // retrieves/creates the current view associated as a motion jpeg
        // image view to be used for visualization
        MotionJpegImageView *imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(0, 0, _pageWidth, pageHeight)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.loadingImage.image = [UIImage imageNamed:@"loading.png"];
        imageView.errorImage.image = [UIImage imageNamed:@"error.png"];
        imageView.delegate = self;

        // sets the "target" url value in the image view and then
        // starts playing the motion image (loading started)
        imageView.url = url;
        [imageView play];

        // adds the image view panel to the scroll view push it
        // into the end of the video panels "stack", note that
        // the image view is contained under the image container
        [imageContainerView addSubview:imageView];
        [self.scrollView addSubview:imageContainerView];

        // adds the current view as a camera view to the current
        // camera view container object, to be used for reference
        [self.cameraViews addObject:imageView];
    }
}

- (void)playCameras {
    for(int index = 0; index < [self.cameraViews count]; index++) {
        MotionJpegImageView *cameraView = self.cameraViews[index];
        [cameraView thumb];
    }

    // retrieves the width of a page as the scroll view frame size
    // and calculates the current page number using the current position
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float pageNumberFloat = self.scrollView.contentOffset.x / pageWidth;
    NSInteger pageNumber = lround(pageNumberFloat);

    // retrieves the references to the previous and the next pages and
    // uses them to retrieve the previous and next camera views
    NSInteger previousPage = pageNumber > 0 ? pageNumber - 1 : 0;
    NSInteger nextPage = pageNumber < [self.cameraViews count] - 1 ? pageNumber + 1 : [self.cameraViews count] - 1;
    MotionJpegImageView *cameraView = self.cameraViews[pageNumber];
    MotionJpegImageView *previousCameraView = self.cameraViews[previousPage];
    MotionJpegImageView *nextCameraView = self.cameraViews[nextPage];

    // runs the play operation (starting the strem) on the various cameras
    // that are meant to be streaming (only the border ones)
    [cameraView play];
    [previousCameraView play];
    [nextCameraView play];
}

- (void)pauseCameras {
    for(int index = 0; index < [self.cameraViews count]; index++) {
        MotionJpegImageView *cameraView = self.cameraViews[index];
        [cameraView pause];
    }
}

- (void)stopCameras {
    for(int index = 0; index < [self.cameraViews count]; index++) {
        MotionJpegImageView *cameraView = self.cameraViews[index];
        [cameraView stop];
    }
}

- (void)setPage:(int)index animated:(BOOL)animated {
    // retrieves the width of a page as the scroll view frame size
    // and then used it to update the offset for the scroll content
    // in the scroll view to "reflect" the correct page position
    CGFloat pageWidth = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(index * pageWidth, 0)
                             animated:animated];
}

- (void)showHeader {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.navigationController.navigationBar setAlpha:1.0];
    [UIView commitAnimations];
    self.navigationVisible = YES;
}

- (void)hideHeader {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.navigationController.navigationBar setAlpha:0.0];
    [UIView commitAnimations];
    self.navigationVisible = NO;
}

- (void)showTabBar:(UITabBarController *) tabBarController {
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

- (void)hideTabBar:(UITabBarController *) tabBarController {
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // hides the current header to hide both the status
    // bar and the navigation controller/bar
    [self hideHeader];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // retrieves the width of a page as the scroll view frame size
    // and calculates the current page number using the current position
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float pageNumberFloat = self.scrollView.contentOffset.x / pageWidth;
    NSInteger pageNumber = lround(pageNumberFloat);

    // retrieves the camera associated with the current page and
    // then retrieves its name and sets the current title with it
    NSArray *camera = self.cameras[pageNumber];
    NSString *cameraName = camera[0];
    self.navigationController.navigationBar.topItem.title = cameraName;

    // runs the play operation on the cameras to update their
    // states according to the new page position
    [self playCameras];
}

- (void)didReceiveImage:(UIImageView *)image {
}

- (void)didFailImage:(UIImageView *)image withError:(NSError *)error {
}

@end
