//
//  SpeakerViewController.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeakerViewController.h"


@implementation SpeakerViewController

@synthesize speaker;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [speaker objectForKey:@"name"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return [[speaker allKeys] count]-1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                cell.textLabel.text = [speaker objectForKey:@"name"];
                break;
            case 1:
                cell.textLabel.text = [speaker objectForKey:@"headline"];
                break;
            case 2:
                cell.textLabel.text = [speaker objectForKey:@"email"]?[speaker objectForKey:@"email"]:[speaker objectForKey:@"web"]?[speaker objectForKey:@"web"]:[speaker objectForKey:@"twitter"]?[speaker objectForKey:@"twitter"]:@"";
                cell.textLabel.textColor = [UIColor blueColor];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                break;
            case 3:
                cell.textLabel.text = [speaker objectForKey:@"web"]?[speaker objectForKey:@"web"]:[speaker objectForKey:@"twitter"]?[speaker objectForKey:@"twitter"]:[speaker objectForKey:@"email"]?[speaker objectForKey:@"email"]:@"";
                cell.textLabel.textColor = [UIColor blueColor];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                break;
            case 4:
                cell.textLabel.text = [speaker objectForKey:@"twitter"]?[speaker objectForKey:@"twitter"]:[speaker objectForKey:@"email"]?[speaker objectForKey:@"email"]:[speaker objectForKey:@"web"]?[speaker objectForKey:@"web"]:@"";
                cell.textLabel.textColor = [UIColor blueColor];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                break;
        }
            
    } else {
        cell.textLabel.text = [speaker objectForKey:@"bio"];
        cell.textLabel.numberOfLines = 0; // Multiline
    }    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 34;		
	} else {
		NSString *summary = [speaker objectForKey:@"bio"];
		CGSize s = [summary sizeWithFont:[UIFont systemFontOfSize:15] 
					   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
						   lineBreakMode:UILineBreakModeWordWrap];
		return s.height + 16; // Add padding
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Open URL
	if (indexPath.section == 0 && indexPath.row > 1) {
        NSString *link = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        if ([link isEqualToString:[speaker objectForKey:@"email"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",link]]]; 
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }
	}
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[speaker release];
    [super dealloc];
}

@end
