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

#import "MotionJpegImageView.h"

#pragma mark CredentialAlertView Class Declaration

@class CredentialAlertView;

@protocol CredentialAlertDelegate <NSObject>

- (void)credentialAlertCancelled:(CredentialAlertView *)alert;
- (void)credentialAlertSaved:(CredentialAlertView *)alert;

@end

@interface CredentialAlertView : UIAlertView<UITextFieldDelegate, UIAlertViewDelegate> {
    @private
    UITextField *_usernameField;
    UITextField *_passwordField;
    __unsafe_unretained id<CredentialAlertDelegate> _credentialDelegate;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) id<CredentialAlertDelegate> credentialDelegate;

- (id)initWithDelegate:(id<CredentialAlertDelegate>)delegate forHost:(NSString *)hostName;

@end

#pragma mark - Constants

#define ALERT_HEIGHT 200.0
#define ALERT_Y_POSITION 55.0
#define BUTTON_MARGIN 15.0
#define TEXT_FIELD_MARGIN 5.0

#pragma mark - CredentialAlertView Implementation

@implementation CredentialAlertView

#pragma mark - Properties

@dynamic username;
@dynamic password;

- (NSString *)username {
    return _usernameField.text;
}

- (void)setUsername:(NSString *)username {
    _usernameField.text = username;
}

- (NSString *)password {
    return _passwordField.text;
}

- (void)setPassword:(NSString *)password {
    _passwordField.text = password;
}

#pragma mark - Initializers

- (id)initWithDelegate:(id<CredentialAlertDelegate>)delegate forHost:(NSString *)hostName {
    self = [super initWithTitle:NSLocalizedString(@"CredentialAlertTitle", @"Authorization Required")
                        message:hostName
                       delegate:self
              cancelButtonTitle:NSLocalizedString(@"CancelButtonTitle", @"Cancel")
              otherButtonTitles:NSLocalizedString(@"LoginButtonTitle", @"Log In"),
            nil];

    if(self) {
        _credentialDelegate = delegate;

        _usernameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _usernameField.borderStyle = UITextBorderStyleBezel;
        _usernameField.backgroundColor = [UIColor whiteColor];
        _usernameField.placeholder = NSLocalizedString(@"UsernamePlaceholderText", @"Username");
        _usernameField.delegate = self;
        _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameField.returnKeyType = UIReturnKeyNext;
        _usernameField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self addSubview:_usernameField];

        _passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordField.secureTextEntry = YES;
        _passwordField.borderStyle = UITextBorderStyleBezel;
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.placeholder = NSLocalizedString(@"PasswordPlaceholderText", @"Password");
        _passwordField.delegate = self;
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self addSubview:_passwordField];
    }

    return self;
}

#pragma mark - Overrides

- (void)setFrame:(CGRect)frame {
    frame.size.height = ALERT_HEIGHT;
    frame.origin.y = ALERT_Y_POSITION;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // retrieves the username as text in the username field
    // and then sets a dummy text in the username field and
    // measures the size of the text field
    NSString *username = _usernameField.text;
    _usernameField.text = @"a";
    CGSize textFieldSize = [_usernameField sizeThatFits:CGSizeZero];
    _usernameField.text = username;

    // sarts the reference to the title label, the message
    // label and the array to hold the button views
    UILabel *titleLabel = nil;
    UILabel *messageLabel = nil;
    NSMutableArray *buttonViews = [NSMutableArray arrayWithCapacity:3];

    // iterates over the complete set of subviews to update
    // them and position them
    for(UIView *subview in self.subviews) {
        // in case the current subview is either the username
        // field or the password field, continue the loop
        if(subview == _usernameField || subview == _passwordField) {
            continue;
        }
        // in case the current subview is a label
        else if([subview isKindOfClass:[UILabel class]]) {
            if(titleLabel == nil) {
                titleLabel = (UILabel *) subview;
            }
            else if(titleLabel.frame.origin.y > subview.frame.origin.y) {
                messageLabel = titleLabel;
                titleLabel = (UILabel *) subview;
            }
            else {
                messageLabel = (UILabel *) subview;
            }
        }
        // in case the current subview is a image view
        else if([subview isKindOfClass:[UIImageView class]]) {
        }
        // in case the current subview is a text field
        else if([subview isKindOfClass:[UITextField class]]) {
        }
        // otherwise the current subview is considered to be
        // a button and is added to the button views
        else {
            [buttonViews addObject:subview];
        }
    }

    for(UIView *buttonView in buttonViews) {
        CGRect buttonViewFrame = buttonView.frame;
        buttonViewFrame.origin.y = self.bounds.size.height - buttonViewFrame.size.height - BUTTON_MARGIN;
        buttonView.frame = buttonViewFrame;
    }

    CGRect labelFrame = messageLabel.frame;
    CGRect textFieldFrame = CGRectMake(labelFrame.origin.x,
                                       labelFrame.origin.y + labelFrame.size.height + TEXT_FIELD_MARGIN,
                                       labelFrame.size.width,
                                       textFieldSize.height);
    _usernameField.frame = textFieldFrame;
    [self bringSubviewToFront:_usernameField];

    textFieldFrame.origin.y += textFieldFrame.size.height + TEXT_FIELD_MARGIN;
    _passwordField.frame = textFieldFrame;
    [self bringSubviewToFront:_passwordField];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == [self cancelButtonIndex]) {
        if(_credentialDelegate) {
            [_credentialDelegate credentialAlertCancelled:self];
        }
    }
    else if(_credentialDelegate) {
        [_credentialDelegate credentialAlertSaved:self];
    }

    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.text.length == 0) {
    }
    else if(textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    }
    else if(textField == _passwordField) {
        [textField resignFirstResponder];
    }

    return NO;
}

@end

#pragma mark - Constants

#define END_MARKER_BYTES { 0xFF, 0xD9 }

static NSData *_endMarkerData = nil;

#pragma mark - Private Method Declarations

@interface MotionJpegImageView () <CredentialAlertDelegate>

- (void)cleanupConnection;

@end

#pragma mark - Implementation

@implementation MotionJpegImageView

@dynamic isPlaying;

- (bool)isPlaying {
    return !(_connection == nil);
}

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if(self) {
        _url = nil;
        _receivedData = nil;
        _username = nil;
        _password = nil;
        _allowSelfSignedCertificates = NO;
        _borderRadius = 0;

        if(_endMarkerData == nil) {
            uint8_t endMarker[2] = END_MARKER_BYTES;
            _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
        }

        self.contentMode = UIViewContentModeScaleAspectFit;

        // creates the placeholder images to be used in the current
        // motion image view
        [self createImages];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if(self) {
        _url = nil;
        _receivedData = nil;
        _username = nil;
        _password = nil;
        _allowSelfSignedCertificates = NO;
        _borderRadius = 0;

        if(_endMarkerData == nil) {
            uint8_t endMarker[2] = END_MARKER_BYTES;
            _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
        }

        self.contentMode = UIViewContentModeScaleAspectFit;

        // creates the placeholder images to be used in the current
        // motion image view
        [self createImages];
    }

    return self;
}

#pragma mark - Overrides

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self positionImages];
}

#pragma mark - Public Methods

- (void)play {
    // unsets the thumb mode, the stream is meant to
    // be started in "continuous" mode
    _thumbMode = NO;

    // in case the connection is already set no need
    // to anything more (it's already playing)
    if(_connection) {}

    // otherwise in case the url is set, creates a new
    // connection triggering the start of the motion
    else if(_url) {
        _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url]
                                                      delegate:self];
    }
}

- (void)pause {
    // in case there is no connection currently
    // set returns immediately, nothing to be done
    if(!_connection) { return; }

    // cancels the current connection and runs
    // the cleanup operation in it
    [_connection cancel];
    [self cleanupConnection];
}

- (void)clear {
    // unsets the reference to the image, this should
    // hide the image from being displayed
    self.image = nil;
}

- (void)stop {
    [self pause];
    [self clear];
}

- (void)thumb {
    // sets the thumb mode flag so that only one image
    // is loaded for the current motion jpeg
    _thumbMode = YES;

    // in case there's already a thumb in the current motion
    // image view must return immediately nothing to be done
    if(_hasThumb) { return; }

    // in case the connection is already set no need
    // to anything more (it's already playing)
    if(_connection) {}

    // otherwise in case the url is set, creates a new
    // connection triggering the start of the motion
    else if(_url) {
        _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url]
                                                      delegate:self];
    }
}

#pragma mark - Private Methods

- (void)createImages {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat x = (width / 2.0f) - (160.0f / 2.0f);
    CGFloat y = (height / 2.0f) - (150.0f / 2.0f);
    
    _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 160, 150)];
    _loadingImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    _errorImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 160, 150)];
    _errorImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _errorImage.hidden = YES;

    [self addSubview:_loadingImage];
    [self addSubview:_errorImage];
}

- (void)positionImages {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat x = (width / 2.0f) - (160.0f / 2.0f);
    CGFloat y = (height / 2.0f) - (150.0f / 2.0f);
    
    _loadingImage.frame = CGRectMake(x, y, 160, 150);
    _errorImage.frame = CGRectMake(x, y, 160, 150);
}

- (void)cleanupConnection {
    // in case the current connection is defined
    // it must have the reference unset
    if(_connection) { _connection = nil; }
    
    // in case the're currently received data set it
    // must have the reference unset
    if(_receivedData) { _receivedData = nil; }
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // creates a new mutable data for the new response
    _receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // adds the "just" received data to the buffer containing
    // the complete set of received data
    [_receivedData appendData:data];

    // tries to retrieve the end range value using the currently
    // set end marker as the reference for such calculus
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(0, _receivedData.length)];

    // calculates the end location (of the image) and in case the
    // current received data length is greater than the end location
    // retrieves the sub set of data that represents the image and sets
    // it as the current image in display
    long long endLocation = endRange.location + endRange.length;
    if(_receivedData.length >= endLocation) {
        NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(0, endLocation)];
        UIImage *receivedImage = [UIImage imageWithData:imageData];
        if(receivedImage) { self.image = [receivedImage roundWithRadius:_borderRadius]; }
        if(_thumbMode) { [self pause]; }
        _hasThumb = YES;
        _loadingImage.hidden = YES;
        _errorImage.hidden = YES;

        if(self.delegate) { [self.delegate didReceiveImage:self]; }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self cleanupConnection];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL allow = NO;
    if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        allow = _allowSelfSignedCertificates;
    }
    else {
        allow = _allowClearTextCredentials;
    }

    return allow;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if([challenge previousFailureCount] == 0 &&
        _username && _username.length > 0 &&
        _password && _password.length > 0) {
        NSURLCredential *credentials = [NSURLCredential credentialWithUser:_username
                                                                  password:_password
                                                               persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
    }
    else {
        // cancels the current authentication chalenge and runs
        // the cleanup operation in the current connection
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [self cleanupConnection];
        
        // creates a new credential alert window and populates it
        // with the currently set username then shows it
        CredentialAlertView *loginAlert = [[CredentialAlertView alloc] initWithDelegate:self
                                                                                forHost:_url.host];
        loginAlert.username = self.username;
        [loginAlert show];
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self cleanupConnection];
    
    // unsets the current image so that nothing is display
    // in the screen (black screen)
    self.image = nil;
    
    // hides the loading image and show the error image so
    // that the uses is notified about the error
    _loadingImage.hidden = YES;
    _errorImage.hidden = NO;

    if(self.delegate) { [self.delegate didFailImage:self withError:error]; }
}

#pragma mark - CredentialAlertView Delegate Methods

- (void)credentialAlertCancelled:(CredentialAlertView *)alert {
}

- (void)credentialAlertSaved:(CredentialAlertView *)alert {
    // stores both the usedname and password values retrived
    // from the alert window
    self.username = alert.username;
    self.password = alert.password;

    // tries to sttart playing the motion, now
    // using the newly set credentials
    [self play];
}

@end
