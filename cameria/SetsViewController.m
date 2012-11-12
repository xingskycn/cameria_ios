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

@synthesize cameraControllers = _cameraControllers;
@synthesize sets = _sets;
@synthesize tableView = _tableView;

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
    
    // retrieves the pattern image to be used and sets it in
    // the current view (should be able to change the background)
    UIImage *patternImage = [UIImage imageNamed:@"main-background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    // creates the structure for both the logout and the refresh
    // buttons and then adds them to the left anr right of the
    // navigation panel
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(logoutClick:)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self.sets[indexPath.row] valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // removes the selection indication from the "just" selected element
    // this is considered to be the default behavior
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // onvers the row index into a string representation and uses it to
    // retieve the camera view controller associated with the current index
    NSString *rowString = [NSString stringWithFormat:@"%d", indexPath.row];
    CameraViewController *cameraViewController = [self.cameraControllers valueForKey:rowString];
    
    if(!cameraViewController) {
        cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
        
        NSDictionary *set = self.sets[indexPath.row];
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

        // updates the reference to the cameras sequence in the camera view
        // controller with the "just" constructed list of camera tuples
        cameraViewController.cameras = _cameras;
    }
    
    [self.cameraControllers setValue:cameraViewController forKey:rowString];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

- (IBAction)logoutClick:(id)sender {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences removeObjectForKey:@"username"];
    [preferences removeObjectForKey:@"objectId"];
    [preferences removeObjectForKey:@"sessionId"];
    
    [self loadValues];
}

- (IBAction)refreshClick:(id)sender {
    [self loadValues];
}

- (void)loadValues {
    ProxyRequest *proxyRequest = [[ProxyRequest alloc] initWithPath:self path:@"sets.json"];
    proxyRequest.delegate = self;
    proxyRequest.parameters = [NSArray arrayWithObjects: nil];
    [proxyRequest load];
}

- (void)didReceiveData:(NSDictionary *)data {
    self.sets = [data valueForKey:@"sets"];
    self.cameraControllers = [[NSMutableDictionary alloc] init];
    [self.tableView reloadData];
}

- (void)didReceiveError:(NSError *)error {
}

@end
