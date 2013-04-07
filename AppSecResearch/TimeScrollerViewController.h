//
//  RootViewController.h
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.

#import <UIKit/UIKit.h>

#import "TimeScroller.h"
#import "FrontViewController.h"

@class AbstractActionSheetPicker;

@interface TimeScrollerViewController : FrontViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, TimeScrollerDelegate> {
    UITableView *_tableView;
    TimeScroller *_timeScroller;
    
    NSMutableArray *data;
    NSInteger selectedTrack;
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;

@end
