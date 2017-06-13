//
//  UIMapManager.h
//  statslite
//
//  Created by Daniel on 4/25/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kPaddingBounds 80.0f

@class GMSMapView, GMSPolyline;

@interface UIMapManager : NSObject

/**
 * @brief fitBoundsMapView
 * @param localities NSArray of *NSValue
 **/
+ (void)fitBoundsMapView:(GMSMapView *)mapView withLocalities:(NSArray *)localities
              coordinate:(CLLocationCoordinate2D)coordinate;

+ (NSValue *)coordinateObjectFromCoordinate:(CLLocationCoordinate2D)coordinate;

+ (CLLocationCoordinate2D)coordinateFromObject:(NSValue *)object;

/**
 * @brief drawn coordinates in map view.
 * @param coordinates NSArray of * NSValue
 * @returns GMSPolyline
 **/
+ (GMSPolyline *)drawnCoordinates:(NSArray *)coordinates inMapView:(__weak GMSMapView *)mapView;

@end
