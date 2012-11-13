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

#import "Dependencies.h"

#import "AppDelegate.h"
#import "MosaicView.h"
#import "CameraViewHandler.h"
#import "CameraViewController.h"

@interface MosaicViewController : UIViewController<CameraViewHandler, UIGestureRecognizerDelegate> {
    @private
    bool _navigationVisible;
    NSArray *_cameras;
    NSMutableArray *_cameraViews;
    CameraViewController *_cameraViewController;
    MosaicView *_mosaicView;
}

@property (nonatomic) NSMutableArray *cameraViews;
@property (nonatomic) CameraViewController *cameraViewController;
@property (nonatomic) IBOutlet MosaicView *mosaicView;

@end
