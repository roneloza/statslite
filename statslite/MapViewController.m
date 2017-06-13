//
//  MapViewController.m
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIMapManager.h"
#import "TrackingGroupItem.h"

@interface MapViewController ()

@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addMapView];
    
    [self drawnCoordinatesInMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addMapView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:self.mapViewContent.bounds camera:camera];
    
    __weak GMSMapView *mapView = self.mapView;
    
    mapView.myLocationEnabled = YES;
    
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.mapViewContent addSubview:mapView];
    
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:mapView, @"mapView", nil];
    
    [self.mapViewContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self.mapViewContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    self.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    if (CLLocationCoordinate2DIsValid(self.coordinate)) {
     
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = self.coordinate;
        marker.title = @"Lima";
        marker.snippet = @"Marcación";
        marker.map = mapView;
        
        CLLocationDegrees ltd = marker.position.latitude + 0.001;
        CLLocationDegrees lgt = marker.position.longitude + 0.001;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(ltd, lgt);
        
        [UIMapManager fitBoundsMapView:mapView
                        withLocalities:[[NSArray alloc] initWithObjects:
                                        [UIMapManager coordinateObjectFromCoordinate:marker.position],
                                        [UIMapManager coordinateObjectFromCoordinate:coordinate],nil]
                            coordinate:CLLocationCoordinate2DMake(0, 0)];
    }
}

- (void)drawnCoordinatesInMapView {
    
    __weak MapViewController *wkself = self;
    
    wkself.polyline = nil;
    
    __weak GMSMapView *mapView = wkself.mapView;
    
    NSMutableArray *coordinates = [[NSMutableArray alloc] initWithCapacity:self.data.count];
    
    for (__weak TrackingGroupItem *item in wkself.data) {
        
        NSValue *value = [[UIMapManager class] coordinateObjectFromCoordinate:CLLocationCoordinate2DMake([item.latitud doubleValue], [item.longitud doubleValue])];
        
        [coordinates addObject:value];
    }
    
    wkself.polyline = [[UIMapManager class] drawnCoordinates:coordinates inMapView:mapView];
    
    [UIMapManager fitBoundsMapView:mapView
                    withLocalities:coordinates
                        coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    
    CLLocationCoordinate2D firstCoordinate = [[UIMapManager class] coordinateFromObject:[coordinates firstObject]];
    
    CLLocationCoordinate2D lastCoordinate = [[UIMapManager class] coordinateFromObject:[coordinates lastObject]];
    
    if (CLLocationCoordinate2DIsValid(firstCoordinate) && CLLocationCoordinate2DIsValid(lastCoordinate)) {
     
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        marker1.position = firstCoordinate;
        marker1.title = @"Punto Inicial";
        marker1.snippet = @"A";
        marker1.map = mapView;
        
        GMSMarker *marker2 = [[GMSMarker alloc] init];
        marker2.position = lastCoordinate;
        marker2.title = @"Punto Final";
        marker2.snippet = @"B";
        marker2.map = mapView;
    }
}

- (IBAction)closeMapButtonPress:(UIButton *)sender {
    
    if (self.presentingViewController) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
