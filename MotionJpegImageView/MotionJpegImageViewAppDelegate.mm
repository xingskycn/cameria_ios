//
//  MotionJpegImageViewAppDelegate.m
//  MotionJpegImageView
//
//  Created by Matthew Eagar on 10/4/11.
//  Copyright 2011 ThinkFlood Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
