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

#import "LoginViewController.h"

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // retrieves the references for both the username and the password
    // text field element to be used for behavior change
    UITextField *usernameField = (UITextField *) [self.view viewWithTag:1];
    UITextField *passwordField = (UITextField *) [self.view viewWithTag:2];
    
    // updates the localization string on both the username field and
    // the password field
    usernameField.placeholder = NSLocalizedString(@"UsernamePlaceholderText", @"Username");
    passwordField.placeholder = NSLocalizedString(@"PasswordPlaceholderText", @"Password");
    
    
    UIButton *signinButton = (UIButton *) [self.view viewWithTag:4];
    [signinButton setTitle:NSLocalizedString(@"Sign In", @"Sign In") forState:UIControlStateNormal];
    
    UILabel *forgotLabel = (UILabel *) [self.view viewWithTag:5];
    forgotLabel.text = NSLocalizedString(@"Forgot your password ?", @"Forgot your password ?");

    // forces the username field to become the first
    // responder (focus on the text field element)
    [usernameField becomeFirstResponder];

    // sets the current view controller as the delagate for both text
    // fields and then sets the return key as the done key and the text
    // field finished as the handler of such behavior
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
    [usernameField setReturnKeyType:UIReturnKeyDone];
    [passwordField setReturnKeyType:UIReturnKeyDone];
    [usernameField addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwordField addTarget:self
                      action:@selector(textFieldFinished:)
            forControlEvents:UIControlEventEditingDidEndOnExit];

    // retrieves the image view associated with the user settings
    // and sets the text field image to so that the corners are not
    // changed by the resizing operation
    UIImageView *imageView = (UIImageView *) [self.view viewWithTag:3];
    imageView.image = [[UIImage imageNamed:@"textfields_a.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];

    // retrieves the pattern image to be used and sets it in
    // the current view (should be able to change the background)
    UIImage *patternImage = [UIImage imageNamed:@"main-background-dark.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)textFieldFinished:(id)sender {
    // retrieves both the username and the password text field and uses
    // them to retrieve these values to be used in the authentication
    UITextField *usernameField = (UITextField *) [self.view viewWithTag:1];
    UITextField *passwordField = (UITextField *) [self.view viewWithTag:2];
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;

    // creates the base path template containing both the username and
    // the password values than formats the value using these values
    NSString *basePath = @"login.json?username=%@&password=%@";
    NSString *path = [NSString stringWithFormat:basePath, username, password];

    // creates a new proxy request to be used in the authentication procedure
    // note that this is an asynchronous call and may take some time
    _proxyRequest = [[ProxyRequest alloc] initWithPath:self path:path];
    _proxyRequest.delegate = self;
    _proxyRequest.useSession = NO;
    [_proxyRequest load];

    // sends the resign as first responder to the "broadcast" application
    // this should hide the currently present keyboard
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (void)handleException:(NSDictionary *)exception {
    // retrieves the message contained in the exception structure
    // to be able to display it in a window
    NSString *message = [exception objectForKey:@"message"];

    // creates the alert window that will be used to display the error
    // associated with the current authentication failure and then shows
    // it in a modal fashion, then returns immediately to the caller method
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LoginErrorName", @"Problem in login")
                                                    message:NSLocalizedString(message, message)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceive {
}

- (void)didReceiveData:(NSDictionary *)data {
    // checks if the current data contains an exception value and
    // in such case handles it and returns immediately
    NSDictionary *exception = [data valueForKey:@"exception"];
    if(exception) { [self handleException:exception]; return; }

    // retrieves the username, the object id and the session id
    // values from the authentication structure to be used in the
    // current persistent storage
    NSString *username = [data valueForKey:@"username"];
    NSString *objectId = [data valueForKey:@"object_id"];
    NSString *sessionId = [data valueForKey:@"session_id"];

    // retrieves the preferences object and uses it to set the "new"
    // session identifier value in it
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:username forKey:@"username"];
    [preferences setValue:objectId forKey:@"objectId"];
    [preferences setValue:sessionId forKey:@"sessionId"];
    [preferences synchronize];

    // closes the current modal window triggering the pop of the
    // previous panel (will show it again)
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveError:(NSError *)error {
}

@end
