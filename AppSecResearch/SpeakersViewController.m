//
//  SpeakersViewController.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeakersViewController.h"
#import "AppDelegate.h"
#import "SpeakerViewController.h"

@implementation SpeakersViewController

@synthesize tableView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Speakers";
    
    self.tableView = [[UITableView alloc] initWithFrame:VIEW_FRAME style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];   
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appDelegate.speakers.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	NSDictionary *item = [appDelegate.speakers objectAtIndex:indexPath.row];
	if (item) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = [item objectForKey:@"name"];
		cell.detailTextLabel.text = [item objectForKey:@"headline"];		
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Show detail
	SpeakerViewController *detail = [[SpeakerViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detail.speaker = [appDelegate.speakers objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
