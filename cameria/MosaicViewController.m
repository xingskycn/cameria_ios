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

@synthesize cameras = _cameras;
@synthesize cameraViews = _cameraViews;
@synthesize mosaicView = _mosaicView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cameraViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createCameras];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self playCameras];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self pauseCameras];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
