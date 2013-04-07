//
//  SpeakersViewController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"

@interface SpeakersViewController : FrontViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
}
@property (nonatomic, strong) UITableView *tableView;

@end
