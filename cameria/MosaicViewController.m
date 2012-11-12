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

@synthesize mosaicView = _mosaicView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    for(int index = 0; index < 20; index++) {
        //        UIImageView *tobias = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        
        MotionJpegImageView *tobias = [[MotionJpegImageView alloc] init];
        tobias.url = [NSURL URLWithString:@"http://root:root@lugardajoiafa.dyndns.org:7000/axis-cgi/mjpg/video.cgi?camera=1&resolution=320x240&compression=50&fps=1&clock=0"];
        tobias.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tobias.loadingImage.image = [UIImage imageNamed:@"loading.png"];
        tobias.errorImage.image = [UIImage imageNamed:@"error.png"];
        
        [self.mosaicView addImageView:tobias];
        
        [tobias play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end