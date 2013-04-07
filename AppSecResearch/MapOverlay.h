//
//  MapOverlay.h
//  AppSecEU
//
//  Created by Antonios Lilis on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapOverlay : NSObject <MKOverlay> {
    
}

- (MKMapRect)boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
