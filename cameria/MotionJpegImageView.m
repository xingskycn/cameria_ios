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
    id<CredentialAlertDelegate> _credentialDelegate;
    
}

@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, assign) id<CredentialAlertDelegate> credentialDelegate;

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
@synthesize credentialDelegate = _credentialDelegate;

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
    self = [super initWithTitle:NSLocalizedString(@"CredentialAlertTitle", @"") 
            message:hostName
            delegate:self
            cancelButtonTitle:NSLocalizedString(@"CancelButtonTitle", @"")
            otherButtonTitles:NSLocalizedString(@"LoginButtonTitle", @""),
            nil];
    
    if(self) {
        _credentialDelegate = delegate;

        _usernameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _usernameField.borderStyle = UITextBorderStyleBezel;
        _usernameField.backgroundColor = [UIColor whiteColor];
        _usernameField.placeholder = NSLocalizedString(@"UsernamePlaceholderText", @"");
        _usernameField.delegate = self;
        _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _usernameField.returnKeyType = UIReturnKeyNext;
        _usernameField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self addSubview:_usernameField];
        [_usernameField release];
        
        _passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordField.secureTextEntry = YES;
        _passwordField.borderStyle = UITextBorderStyleBezel;
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.placeholder = NSLocalizedString(@"PasswordPlaceholderText", @"");
        _passwordField.delegate = self;
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self addSubview:_passwordField];
        [_passwordField release];
    }
    
    return self;
}

#pragma mark - Overrides

- (void)dealloc {
    [super dealloc];
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = ALERT_HEIGHT;
    frame.origin.y = ALERT_Y_POSITION;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *username = _usernameField.text;
    _usernameField.text = @"a";
    CGSize textFieldSize = [_usernameField sizeThatFits:CGSizeZero];
    _usernameField.text = username;

    UILabel *titleLabel = nil;
    UILabel *messageLabel = nil;
    NSMutableArray *buttonViews = [NSMutableArray arrayWithCapacity:3];
    
    for (UIView *subview in self.subviews) {
        if (subview == _usernameField ||
            subview == _passwordField) {
            // continue
        }
        else if ([subview isKindOfClass:[UILabel class]]) {
            if (titleLabel == nil) {
                titleLabel = (UILabel *)subview;
            }
            else if (titleLabel.frame.origin.y > subview.frame.origin.y) {
                messageLabel = titleLabel;
                titleLabel = (UILabel *)subview;
            }
            else {
                messageLabel = (UILabel *)subview;
            }
        }
        else if ([subview isKindOfClass:[UIImageView class]]) {
            // continue
        }
        else if ([subview isKindOfClass:[UITextField class]]) {
            // continue
        }
        else {
            [buttonViews addObject:subview];
        } 
    }
    
    CGFloat buttonViewTop = 0.0;
    for (UIView *buttonView in buttonViews) {
        CGRect buttonViewFrame = buttonView.frame;
        buttonViewFrame.origin.y = 
        self.bounds.size.height - buttonViewFrame.size.height - BUTTON_MARGIN;
        buttonView.frame = buttonViewFrame;
        buttonViewTop = CGRectGetMinY(buttonViewFrame);
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

-    (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [self cancelButtonIndex]) {
        if (_credentialDelegate) {
            [_credentialDelegate credentialAlertCancelled:self];
        }
    }
    else if (_credentialDelegate) {
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
    if (textField.text.length == 0) {
        // continue
    }
    else if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField) {
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

@synthesize url = _url;
@synthesize username = _username;
@synthesize password = _password;
@synthesize allowSelfSignedCertificates = _allowSelfSignedCertificates;
@synthesize allowClearTextCredentials = _allowClearTextCredentials;
@dynamic isPlaying;

- (BOOL)isPlaying {
    return !(_connection == nil);
}

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _url = nil;
        _receivedData = nil;
        _username = nil;
        _password = nil;
        _allowSelfSignedCertificates = NO;
        
        if (_endMarkerData == nil) {
            uint8_t endMarker[2] = END_MARKER_BYTES;
            _endMarkerData = [[NSData alloc] initWithBytes:endMarker length:2];
        }
        
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

#pragma mark - Overrides

- (void)dealloc {
    if (_connection) {
        [_connection cancel];
        [self cleanupConnection];
    }
    
    if (_url) {
        [_url release];
    }
    
    if (_username) {
        [_username release];
    }
    
    if (_password) {
        [_password release];
    }
    
    [super dealloc];
}

#pragma mark - Public Methods

- (void)play {
    // in case the connection is already set no need
    // to anything more (it's already playing)
    if (_connection) {}
    
    // otherwise in case the url is set, creates a new
    // connection triggering the start of the motion
    else if (_url) {
        _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:_url]
                                                      delegate:self];
    }
}

- (void)pause {
    if (_connection) {
        [_connection cancel];
        [self cleanupConnection];
    }
}

- (void)clear {
    self.image = nil;
}

- (void)stop {
    [self pause];
    [self clear];
}

#pragma mark - Private Methods

- (void)cleanupConnection {
    if (_connection) {
        [_connection release];
        _connection = nil;
    }
    
    if (_receivedData) {
        [_receivedData release];
        _receivedData = nil;
    }
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // releases the currently allocated data (no more data
    // pending for the current response) and creates a new
    // mutable data for the new response
    if (_receivedData) { [_receivedData release]; }
    _receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
    
    NSRange endRange = [_receivedData rangeOfData:_endMarkerData
                                          options:0
                                            range:NSMakeRange(0, _receivedData.length)];
    
    long long endLocation = endRange.location + endRange.length;
    if (_receivedData.length >= endLocation) {
        NSData *imageData = [_receivedData subdataWithRange:NSMakeRange(0, endLocation)];
        UIImage *receivedImage = [UIImage imageWithData:imageData];
        if (receivedImage) { self.image = receivedImage; }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self cleanupConnection];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL allow = NO;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        allow = _allowSelfSignedCertificates;
    }
    else {
        allow = _allowClearTextCredentials;
    }
    
    return allow;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0 &&
        _username && _username.length > 0 &&
        _password && _password.length > 0) {
        NSURLCredential *credentials = 
            [NSURLCredential credentialWithUser:_username
                                       password:_password
                                    persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [self cleanupConnection];
        
        CredentialAlertView *loginAlert = [[CredentialAlertView alloc] initWithDelegate:self
                                                                                forHost:_url.host];
        loginAlert.username = self.username;
        [loginAlert show];
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error {
    [self cleanupConnection];
}

#pragma mark - CredentialAlertView Delegate Methods

- (void)credentialAlertCancelled:(CredentialAlertView *)alert {
    // releases the alert window not going to
    // be used for anything more (avoids leaks)
    [alert release];
}

- (void)credentialAlertSaved:(CredentialAlertView *)alert {
    // stores both the usedname and password values retrived
    // from the alert window and then releases the alert window
    self.username = alert.username;
    self.password = alert.password;
    [alert release];
    
    // tries to sttart playing the motion, now
    // using the newly set credentials
    [self play];
}

@end
