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

#import "MosaicViewController.h"

#import "MotionJpegImageView.h"

@implementation MosaicViewController

@synthesize navigationVisible = _navigationVisible;
@synthesize cameras = _cameras;
@synthesize cameraViews = _cameraViews;
@synthesize cameraViewController = _cameraViewController;
@synthesize mosaicView = _mosaicView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationVisible = YES;
        self.cameraViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createCameras];
    
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
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // retrieves the reference to the current application delegate
    // and sets the camera view handler in it so that it's able
    // to stop the current cameras in case the application resigns
    // as active (provides bandwidth saving)
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.cameraViewHandler = self;

    [self playCameras];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // retrieves the reference to the current application delegate
    // and unsets the camera view handler reference in it, no need
    // to stop cameras that are already stopped
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.cameraViewHandler = nil;
    
    [self pauseCameras];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)refreshClick:(id)sender {
    // runs the play cameras operation so that a new
    // tryout is done to the loading of the stream
    [self playCameras];
}

- (void)createCameras {
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

        // retrieves/creates the current view associated as a motion jpeg
        // image view to be used for visualization
        MotionJpegImageView *imageView = [[MotionJpegImageView alloc] init];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.loadingImage.image = [UIImage imageNamed:@"loading.png"];
        imageView.errorImage.image = [UIImage imageNamed:@"error.png"];
        imageView.url = url;
        
        // sets the rounded corners in the image view to provide a better
        // visual effect
        [imageView.layer setMasksToBounds:YES];
        [imageView.layer setCornerRadius:2.0];

        // enables the user interaction so that the touch events
        // are gathered and correctly handled
        imageView.userInteractionEnabled = YES;
        
        // creates the tap recognizer object to be to toggle the
        // visibility of the header panels and then sets it in the
        // current scroll view panel reference
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.delegate = self;
        [imageView addGestureRecognizer:tapRecognizer];
       
        // sets the tag for the image view as the current index in iteration
        // so that it may be used latter for the selection operations
        imageView.tag = index;
        
        // adds the "motion" image view to the mosaic view to be disaplyed
        // in a sequence list
        [self.mosaicView addImageView:imageView];
    
        // adds the current view as a camera view to the current
        // camera view container object, to be used for reference
        [self.cameraViews addObject:imageView];
    }
    
    // plays the complete set of cameras, starting the stream
    // of data from the server side
    [self playCameras];
}

- (IBAction)handleTap:(id)sender {
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *) sender;
    UIView *view = recognizer.view;
    int pageIndex = view.tag;
    
    if(!self.cameraViewController) {
        self.cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
        self.cameraViewController.cameras = self.cameras;
    }
    
    // sets the "initial" page index value for the camer view controller
    // so that it's correctly displayed with such value
    self.cameraViewController.pageIndex = pageIndex;
    
    [self.navigationController pushViewController:self.cameraViewController animated:YES];
}

- (void)playCameras {
    for(int index = 0; index < [self.cameraViews count]; index++) {
        MotionJpegImageView *cameraView = self.cameraViews[index];
        [cameraView play];
    }
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

@end
