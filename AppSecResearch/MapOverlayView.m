//
//  MapOverlayView.m
//  AppSecEU
//
//  Created by Antonios Lilis on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapOverlayView.h"

@implementation MapOverlayView

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    
    UIImage *image          = [[UIImage imageNamed:@"venue.png"] retain];
    
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect           = [self rectForMapRect:theMapRect];
    CGRect clipRect     = [self rectForMapRect:mapRect];
    
    CGContextAddRect(ctx, clipRect);
    CGContextClip(ctx);
    
    CGContextDrawImage(ctx, theRect, imageReference);
    
    [image release]; 
    
}


@end
