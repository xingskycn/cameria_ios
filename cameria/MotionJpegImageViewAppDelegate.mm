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

#import "MotionJpegImageViewAppDelegate.h"

@implementation MotionJpegImageViewAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // creates the url to be used in the visualization of
    // the data in the motion image view
    NSURL *url = [NSURL URLWithString:@"http://root:root@lugardajoiadvdouro.dyndns.org:7000/axis-cgi/mjpg/video.cgi?camera=1&resolution=640x480&compression=30&fps=4&clock=0"];

    // creates the motion jpeg image view with the currently
    // defined frame and sets the url in it for the loading
    // of the image (simple usage)
    _imageView = [[MotionJpegImageView alloc] initWithFrame:self.window.frame];
    _imageView.url = url;
    
    // adds the image view to the window and starts
    // playing the image (downloads content)
    [self.window addSubview:_imageView];
    [_imageView play];
    
    // makes the window visible and the returns
    // in success to the caller
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // pauses the image view to avoid extra
    // usage of traffic (bandwidth waste)
    [_imageView pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // resumes the playback of the image views
    // bandwidth is used again
    [_imageView play];
}

- (void)dealloc {
    // releases the window and the image view
    // references no more need to hold them
    [_window release];
    [_imageView release];
    
    [super dealloc];
}

@end
