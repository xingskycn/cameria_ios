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

#import "MotionJpegImageViewDelegate.h"
#import "UIImage+HMImageUtil.h"

@interface MotionJpegImageView : UIImageView {
    @private
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    bool _thumbMode;
    bool _hasThumb;
}

@property (nonatomic, readonly) UIImageView *loadingImage;
@property (nonatomic, readonly) UIImageView *errorImage;
@property (nonatomic, weak) NSObject<MotionJpegImageViewDelegate> *delegate;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, readonly) bool isPlaying;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) bool allowSelfSignedCertificates;
@property (nonatomic) bool allowClearTextCredentials;
@property (nonatomic) int borderRadius;

/**
 * Plays the image motion from the start in case
 * it's the first call or resumes the playback of
 * the motion in case the current state is paused.
 */
- (void)play;
- (void)pause;
- (void)clear;
- (void)stop;
- (void)thumb;

@end
