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

#import "HMJsonRequest.h"
#import "HMJsonRequestDelegate.h"
#import "ProxyRequestDelegate.h"
#import "LoginViewController.h"

/**
 * Responsible for the coordination of the remote calls
 * with the proper visual changes (loading mask settings).
 */
@interface ProxyRequest : NSObject<HMJsonRequestDelegate> {
    @private
    NSObject<ProxyRequestDelegate> *_delegate;
    UIViewController *_controller;
    NSString *_path;
    NSArray *_parameters;
    UIView *_mask;
    UIActivityIndicatorView *_maskIndicator;
    HMJsonRequest *_jsonRequest;
    bool _loading;
    bool _useSession;
}

@property (strong) NSObject<ProxyRequestDelegate> *delegate;
@property (strong) UIViewController *controller;
@property (strong) NSString *path;
@property (strong) NSArray *parameters;
@property (strong) UIView *mask;
@property (strong) UIActivityIndicatorView *maskIndicator;
@property (strong) HMJsonRequest *jsonRequest;
@property bool loading;
@property bool useSession;

- initWithPath:(UIViewController *)controller path:(NSString *)path;
- (void)load;

@end
