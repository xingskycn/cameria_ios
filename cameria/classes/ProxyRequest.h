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
}

@property (nonatomic, weak) NSObject<ProxyRequestDelegate> *delegate;
@property (nonatomic) UIViewController *controller;
@property (nonatomic) NSString *path;
@property (nonatomic) NSArray *parameters;
@property (nonatomic) UIView *mask;
@property (nonatomic) UIActivityIndicatorView *maskIndicator;
@property (nonatomic) HMJsonRequest *jsonRequest;
@property (nonatomic) bool loading;
@property (nonatomic) bool useSession;

- initWithPath:(UIViewController *)controller path:(NSString *)path;
- (void)load;

@end
