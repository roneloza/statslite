//
//  LocationManager.m
//  statslite
//
//  Created by Daniel on 12/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "LocationManager.h"
#import "UIAlertViewManager.h"
#import "Constants.h"

CLLocationCoordinate3D CLLocationCoordinate3DMake(CLLocationDegrees latitude, CLLocationDegrees longitude, CLLocationDistance altitude) {
    
    CLLocationCoordinate3D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    coordinate.altitude = altitude;
    
    return coordinate;
}


@interface LocationManager()

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationManager

+ (LocationManager *)shared {
    
    static LocationManager *_shared = nil;
    
    if (!_shared) {
        
        _shared = [[super allocWithZone:nil] init];
        
        _shared.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        _shared.distanceFilter = kCLDistanceFilterNone;
    }
    
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [self shared];
}

- (instancetype)init {
    
    self = [super init];
    
    self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.distanceFilter = 10.0f;
    
    return self;
}

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = self.distanceFilter;
//        _locationManager.desiredLocationFreshness = 15.0; // desired freshness in s
//        _locationManager.desiredLocationAccuracy = 100.0; // desired location accuracy in m
//        _locationManager.improvementAccuracyToGiveUpOn = 30.0; // desired improvement in m
//        _locationManager.timeToFindLocation = 30.0; // timeout to find location in s
        
    }
    
    return _locationManager;
}

- (void)requestAuthorizationLocationServicesWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void (^)(BOOL success))completion {
    
    self.delegate = delegate;
    self.locationManager.delegate = delegate;
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    BOOL success = NO;
    
//    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if ([CLLocationManager locationServicesEnabled]) {
            
            success = YES;
        }
        else {
            
            [UIAlertViewManager showAlertWithTitle:@""
                                         message:NSLocalizedString(@"msg_locationServicesDisabled", @"")
                               cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                               otherButtonTitles:nil
                                       onDismiss:nil];
        }
    }
    else if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        
        //if (code == kCLAuthorizationStatusNotDetermined &&
        if (([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] ||
             [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]))
        {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                
                [self.locationManager requestAlwaysAuthorization];
                
            }
            else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                
                [self.locationManager requestWhenInUseAuthorization];
            }
            else {
                
                AppDebugECLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
        else {
            
            [UIAlertViewManager showAlertWithTitle:@""
                                         message:NSLocalizedString(@"msg_locationServicesDenied", @"")
                               cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                               otherButtonTitles:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_prefs_label",@""), nil] : nil)
                                       onDismiss:^(NSInteger buttonIndex){
                                           
                                           if (buttonIndex == 1) {
                                               
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                                           }
                                       }];
        }
    }
    else {
        
        [UIAlertViewManager showAlertWithTitle:@""
                                       message:NSLocalizedString(@"msg_locationServicesDenied", @"")
                             cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                             otherButtonTitles:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_prefs_label",@""), nil] : nil)
                                     onDismiss:^(NSInteger buttonIndex){
                                         
                                         if (buttonIndex == 1) {
                                             
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                                         }
                                     }];
    }
    
    if (completion) completion(success);
}

- (void)startUpdatingLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void (^)(BOOL success))completion  {
    
    self.delegate = delegate;
    self.locationManager.delegate = delegate;
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    BOOL success = NO;
    
//    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
//        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if ([CLLocationManager locationServicesEnabled]) {
            
            success = YES;
            
            [self.locationManager startUpdatingLocation];
        }
        else {
            
            [UIAlertViewManager showAlertWithTitle:@""
                                           message:NSLocalizedString(@"msg_locationServicesDisabled", @"")
                                 cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                                 otherButtonTitles:nil
                                         onDismiss:nil];
        }
    }
    else if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        
        //if (code == kCLAuthorizationStatusNotDetermined &&
        if (([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] ||
             [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]))
        {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                
                [self.locationManager requestAlwaysAuthorization];
                
            }
            else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                
                [self.locationManager requestWhenInUseAuthorization];
            }
            else {
                
                AppDebugECLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
        else {
            
            [UIAlertViewManager showAlertWithTitle:@""
                                           message:NSLocalizedString(@"msg_locationServicesDenied", @"")
                                 cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                                 otherButtonTitles:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_prefs_label",@""), nil] : nil)
                                         onDismiss:^(NSInteger buttonIndex){
                                             
                                             if (buttonIndex == 1) {
                                                 
                                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                                             }
                                         }];
        }
    }
    else {
        
        [UIAlertViewManager showAlertWithTitle:@""
                                       message:NSLocalizedString(@"msg_locationServicesDenied", @"")
                             cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                             otherButtonTitles:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_prefs_label",@""), nil] : nil)
                                     onDismiss:^(NSInteger buttonIndex){
                                         
                                         if (buttonIndex == 1) {
                                             
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                                         }
                                     }];
    }
    
    if (completion) completion(success);
}

- (void)stopUpdatingLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate completion:(void (^)(void))completion {
    
    AppDebugECLog(@"stopUpdatingLocation");
    
    [self.locationManager stopUpdatingLocation];
    
    self.delegate = nil;
    self.locationManager.delegate = nil;
    
    if (completion) completion();
}

//- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
//    
//    _desiredAccuracy = desiredAccuracy;
//    self.locationManager.desiredAccuracy = _desiredAccuracy;
//}
//
//- (void)setDistanceFilter:(CLLocationDistance)distanceFilter {
//    
//    _distanceFilter = distanceFilter;
//    self.locationManager.distanceFilter = _distanceFilter;
//}

- (BOOL)isLocationServicesEnabledAndAuthorized {
    
    // Shows benefits and use GPS
    BOOL locationServiceStatusAuthorized = ([CLLocationManager locationServicesEnabled] && [self isLocationServicesAuthorized]);
    
    return locationServiceStatusAuthorized;
}

- (BOOL)isLocationServicesAuthorized {
    
    CLAuthorizationStatus code = [CLLocationManager authorizationStatus];
    
    BOOL locationStatusAuthorized = (code != kCLAuthorizationStatusDenied &&
                                     code != kCLAuthorizationStatusNotDetermined &&
                                     code != kCLAuthorizationStatusRestricted);
    
    return locationStatusAuthorized;
}

@end
