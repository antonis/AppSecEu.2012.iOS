//
//  MenuView.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ZBarReaderDelegate> {
    UITableView *menuTable_;
    NSArray *cellContents_;
}

@end
