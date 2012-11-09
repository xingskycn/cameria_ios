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

@synthesize cameraViewController = _cameraViewController;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    
    [self loadValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    //NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = @"Tobias";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSDate *object = _objects[indexPath.row];
    
    if(!self.cameraViewController) {
        self.cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
        self.cameraViewController.cameras = [NSArray arrayWithObjects:
                                             [NSArray arrayWithObjects:@"dvd_01", @"http://root:root@lugardajoiadvdouro.dyndns.org:7000/axis-cgi/mjpg/video.cgi?camera=1&resolution=640x480&compression=30&fps=4&clock=0", nil],
                                             [NSArray arrayWithObjects:@"dvd_02", @"http://root:root@lugardajoiadvdouro.dyndns.org:7001/axis-cgi/mjpg/video.cgi?camera=1&resolution=640x480&compression=30&fps=4&clock=0", nil],
                                             [NSArray arrayWithObjects:@"dvd_03", @"http://root:root@lugardajoiadvdouro.dyndns.org:7002/axis-cgi/mjpg/video.cgi?camera=1&resolution=640x480&compression=30&fps=4&clock=0", nil],nil];
    }
    
    [self.navigationController pushViewController:self.cameraViewController animated:YES];
}


- (void)loadValues {
    ProxyRequest *proxyRequest = [[ProxyRequest alloc] initWithPath:self path:@"sale_snapshots/stats.json"];
    proxyRequest.delegate = self;
    proxyRequest.parameters = [NSArray arrayWithObjects:
                               [NSArray arrayWithObjects:@"unit", @"day", nil],
                               [NSArray arrayWithObjects:@"span", @"6", nil],
                               [NSArray arrayWithObjects:@"output", @"extended", nil], nil];
    [proxyRequest load];
}

- (void)didReceiveData:(NSDictionary *)data {
}

- (void)didReceiveError:(NSError *)error {
}

@end
