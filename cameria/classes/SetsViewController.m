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

#import "SetsViewController.h"

@implementation SetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Sets", @"Sets");
        self.tabBarItem.image = [UIImage imageNamed:@"icon-sets.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // sets the table view initialy hidden so that no invalid
    // items are displayed (correct visuals) ant then set the
    // no separator style in the table view to avoid collisions
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // creates the patter image to be used for both the view background
    // and the table view background color
    UIImage *patternImage = [UIImage imageNamed:@"main-background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:patternImage];

    // creates the structure for both the logout and the refresh
    // buttons and then adds them to the left anr right of the
    // navigation panel
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LogoutButtonTitle", @"Logout")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(logoutClick:)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RefreshButtonTitle", @"Refresh")
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(refreshClick:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    
    // in case no sets are currently defined must load the
    // values (initial values loading) this should trigger a
    // remote call to retrieve the data
    if(!self.sets) { [self loadValues]; }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.sets) { return [self.sets count]; }
    else { return 0; }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HMFilterCell cellSize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // creates the cell identifier string and uses it to retrieve
    // the cell reusing it in case it exists or creating a new one
    // otherwise (performance oriented)
    static NSString *cellIdentifier = @"Cell";
    HMFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HMFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // retrieves the "logical" set structure associated
    // with the current row
    NSDictionary *set = self.sets[indexPath.row];
    
    // retrieves the sequence of cameras from the set and
    // uses it to contruct the final cameras string
    NSArray *cameras = [set valueForKey:@"cameras"];
    NSString *camerasString = [NSString stringWithFormat:@"%d %@", [cameras count], NSLocalizedString(@"cameras", @"cameras")];

    // updates the cell text label with the set's associated
    // with the current row name
    cell.title = [set valueForKey:@"name"];
    cell.subTitle = camerasString;
    cell.sideImage = [[UIImage imageNamed:@"icon-sets.png"] roundWithRadius:4];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // removes the selection indication from the "just" selected element
    // this is considered to be the default behavior
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // onvers the row index into a string representation and uses it to
    // retieve the camera view handler associated with the current index
    NSString *rowString = [NSString stringWithFormat:@"%d", indexPath.row];
    UIViewController<CameraViewHandler> *cameraViewHandler = [self.cameraControllers valueForKey:rowString];

    if(!cameraViewHandler) {
        // checks if the current device is a phone or rather an pad device for
        // the first case the camera controller should be displayed, otherwise
        // the mosaic view shoud be disaplyed (for the pad)
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cameraViewHandler = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
        } else {
            cameraViewHandler = [[MosaicViewController alloc] initWithNibName:@"MosaicViewController" bundle:nil];
        }

        NSDictionary *set = self.sets[indexPath.row];
        NSString *name = [set valueForKey:@"name"];
        NSArray *cameras = [set valueForKey:@"cameras"];

        NSMutableArray *_cameras = [[NSMutableArray alloc] init];

        for(int index = 0; index < [cameras count]; index++) {
            NSDictionary *camera = cameras[index];

            NSString *_id = [camera valueForKey:@"id"];
            NSString *protocol = [camera valueForKey:@"protocol"];
            NSString *username = [camera valueForKey:@"username"];
            NSString *password = [camera valueForKey:@"password"];
            NSString *_url = [camera valueForKey:@"url"];
            NSString *_camera = [camera valueForKey:@"camera"];
            NSString *resolution = [camera valueForKey:@"resolution"];
            NSString *compression = [camera valueForKey:@"compression"];
            NSString *fps = [camera valueForKey:@"fps"];
            NSString *clock = [camera valueForKey:@"clock"];

            NSString *url = [NSString stringWithFormat:@"%@://%@:%@@%@/axis-cgi/mjpg/video.cgi?camera=%@&compression=%@&fps=%@&clock=%@",
                             protocol,
                             username,
                             password,
                             _url,
                             _camera,
                             compression,
                             fps,
                             clock, nil];
            if(resolution) { url = [NSString stringWithFormat:@"%@&resolution=%@", url, resolution]; }

            [_cameras addObject:[[NSArray alloc] initWithObjects:_id, url, nil]];
        }
        
        // sets the title in the camera view controller with the name
        // of the current set to be populated
        cameraViewHandler.title = name;

        // updates the reference to the cameras sequence in the camera view
        // handler with the "just" constructed list of camera tuples
        cameraViewHandler.cameras = _cameras;
    }

    [self.cameraControllers setValue:cameraViewHandler forKey:rowString];
    [self.navigationController pushViewController:cameraViewHandler animated:YES];
}

- (IBAction)logoutClick:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences removeObjectForKey:@"username"];
    [preferences removeObjectForKey:@"objectId"];
    [preferences removeObjectForKey:@"sessionId"];

    // retrieves the reference to the current application delegate
    // and unsets the camera view controller reference in it, no need
    // to stop cameras that are already stopped
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate reset];

    // tries to load the "new" value in order to trigger the display
    // of the login screen (no authentication)
    [self loadValues];
}

- (IBAction)refreshClick:(id)sender {
    [self loadValues];
}

- (void)reset {
    self.sets = nil;
    self.tableView.hidden = YES;
    [self.tableView reloadData];
}

- (void)loadValues {
    _proxyRequest = [[ProxyRequest alloc] initWithPath:self path:@"sets.json"];
    _proxyRequest.delegate = self;
    _proxyRequest.parameters = [NSArray arrayWithObjects: nil];
    [_proxyRequest load];
}

- (void)didSend {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceive {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didReceiveData:(NSDictionary *)data {
    self.sets = [data valueForKey:@"sets"];
    self.cameraControllers = [[NSMutableDictionary alloc] init];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)didReceiveError:(NSError *)error {
    self.tableView.hidden = YES;
}

@end
