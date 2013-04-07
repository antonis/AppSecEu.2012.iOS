//
//  EventMapViewController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#import <MapKit/MapKit.h>

@class AbstractActionSheetPicker;

@interface EventMapViewController : FrontViewController<MKMapViewDelegate> {
    NSMutableArray* groupTransport;
    NSMutableArray* groupDIT;
    NSMutableArray* groupYa;
    NSMutableArray* groupPalamas;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;

@end
