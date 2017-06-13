//
//  LocationManager.h
//  statslite
//
//  Created by Daniel on 12/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kCLDistanceFilterFiftyMeters 50.0
#define kCLDistanceFilterOneHundredMeters 100.0
#define kCLDistanceFilterFiveHundredMeters 500.0

struct CLLocationCoordinate3D {
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    CLLocationDegrees altitude;
};
typedef struct CLLocationCoordinate3D CLLocationCoordinate3D;

CLLocationCoordinate3D CLLocationCoordinate3DMake(CLLocationDegrees latitude, CLLocationDegrees longitude, CLLocationDistance altitude);


NSDictionary* getBoundaries(double lat, double lng, double distance, double earthRadius);

@interface LocationManager: NSObject<CLLocationManagerDelegate>

//+ (LocationManager *)shared;

@property (nonatomic, weak) id<CLLocationManagerDelegate> delegate;
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
@property (nonatomic, assign) CLLocationDistance distanceFilter;

- (void)startUpdatingLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void (^)(BOOL success))completion;

- (void)stopUpdatingLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void(^)(void))completion;

- (void)requestAuthorizationLocationServicesWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void (^)(BOOL success))completion;

- (BOOL)isLocationServicesEnabledAndAuthorized;
- (BOOL)isLocationServicesAuthorized;

@end
