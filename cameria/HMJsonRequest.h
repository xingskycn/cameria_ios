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

#import "HMJsonRequestDelegate.h"

@interface HMJsonRequest : NSObject {
    @private
    NSURL *_url;
    NSArray *_parameters;
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    NSObject<HMJsonRequestDelegate> *_delegate;
}

/**
 * The url of the resource to be retrieved
 * by the json request.
 */
@property (nonatomic) NSURL *url;

/**
 * The sequence of tuples containing the various
 * parameters to be sent to the server.
 *
 * These parameters will be encoded into get parameters
 * (under the url) in case the current request is of
 * type get.
 */
@property (nonatomic) NSArray *parameters;

/**
 * The connection to be used for the retrieval
 * of the resources.
 */
@property (nonatomic) NSURLConnection *connection;

/**
 * The buffer to be used to store the received
 * data while the data transfer is not complete.
 */
@property (nonatomic) NSMutableData *receivedData;

/**
 * The delegate object that will be notified about
 * the changes in the connection from a json point
 * of view.
 *
 * In case this value is set notifications will be sent
 * for both errors and data receivals.
 */
@property (nonatomic) NSObject<HMJsonRequestDelegate> *delegate;

- initWithUrl:(NSURL *)url;
- initWithUrlString:(NSString *)urlString;
- initWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters;
- (void)load;

@end
