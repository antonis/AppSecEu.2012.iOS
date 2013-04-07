//
//  MapOverlay.m
//  AppSecEU
//
//  Created by Antonios Lilis on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapOverlay.h"

@implementation MapOverlay

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self != nil) {
        
        
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord1 = {
        37.969300,23.765400
    };
    return coord1;
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 1667, 1000);
    return bounds;
}


@end
