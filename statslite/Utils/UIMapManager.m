//
//  UIMapManager.m
//  statslite
//
//  Created by Daniel on 4/25/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "UIMapManager.h"
#import "Constants.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation UIMapManager

+ (void)fitBoundsMapView:(GMSMapView *)mapView withLocalities:(NSArray *)localities
              coordinate:(CLLocationCoordinate2D) coordinate{
    
    if (localities.count > 0) {
        
        GMSCoordinateBounds *bounds = nil;
        
        if (coordinate.latitude != 0.0 && coordinate.longitude != 0.0) {
            
            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:coordinate
                                                          coordinate:coordinate];
        }
        else {
            
            bounds = [[GMSCoordinateBounds alloc] init];
        }
        
        for (__weak NSValue *item in localities) {
            
            CLLocationCoordinate2D coordinate = [[self class] coordinateFromObject:item];
            bounds = [bounds includingCoordinate:coordinate];
        }
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:kPaddingBounds];
//        GMSCameraUpdate *update = [GMSCameraUpdate zoomBy:<#(float)#> atPoint:<#(CGPoint)#>];
        
        [mapView animateWithCameraUpdate:update];
    }
}

+ (NSValue *)coordinateObjectFromCoordinate:(CLLocationCoordinate2D)coordinate  {
    
//    CLLocationCoordinate2D new_coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    return [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
}

+ (CLLocationCoordinate2D)coordinateFromObject:(NSValue *)object  {
    
    CLLocationCoordinate2D coordinate;
    [object getValue:&coordinate];
    
    return coordinate;
}

+ (GMSPolyline *)drawnCoordinates:(NSArray *)data inMapView:(__weak GMSMapView *)mapView; {
    
    if (data.count < 2) return nil;
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (__weak NSValue *value in data) {
        
        CLLocationCoordinate2D coordinate = [[self class] coordinateFromObject:value];
        
        [path addCoordinate:coordinate];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];

    polyline.strokeColor = UIColorFromHex(kColorRedStas);
    polyline.strokeWidth = 5.0f;
    polyline.tappable = YES;
    polyline.map = mapView;
    polyline.title = @"";
    
    return polyline;
}

@end
