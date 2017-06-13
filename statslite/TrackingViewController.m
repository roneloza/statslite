//
//  TrackingViewController.m
//  statslite
//
//  Created by rone loza on 6/7/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "TrackingViewController.h"
#import "TrackingTableViewCell.h"
#import "TrackingItem.h"
#import "LocationManager.h"
#import "NetworkManager.h"
#import "DataBaseManagerSqlite.h"
#import "TableClause.h"
#import "JSONParserManager.h"
#import "UserProfile.h"
#import "Constants.h"
#import "NSString+Utils.h"
#import <CoreLocation/CoreLocation.h>

#import "UIAlertViewManager.h"

#define kTrackingTableViewCell @"TrackingTableViewCell"

@interface TrackingViewController ()<CLLocationManagerDelegate>

/**
 *@brief NSArray of *TrackingItem
 **/
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) LocationManager *locationManager;

@property (nonatomic, strong) NSString *trackingGroup;
@property (nonatomic, assign) CLLocationCoordinate3D coordinate;
@property (nonatomic, strong) NSString *dateString;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[LocationManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    __weak TrackingViewController *wkself = self;
    
    [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackingTableViewCell forIndexPath:indexPath];
    
    __weak TrackingItem *item = [self.data objectAtIndex:indexPath.row];
    
    NSString *h = @"Hora";
    NSString *lt = @"Latitud";
    NSString *lgt = @"Longitud";
    NSString *alt = @"Altitud";
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@ : %@\n%@ : %@\n%@ : %@\n%@ : %@", h, item.date, lt, item.latitude, lgt, item.longitude, alt, item.altitude];
    
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:UIColorFromHex(kColorRedStas), NSForegroundColorAttributeName , nil];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrString addAttributes:attr range:[text rangeOfString:h]];
    [attrString addAttributes:attr range:[text rangeOfString:lt]];
    [attrString addAttributes:attr range:[text rangeOfString:lgt]];
    [attrString addAttributes:attr range:[text rangeOfString:alt]];
    
    cell.textView.attributedText = attrString;
    return cell;
}

#pragma mark - CLLocationManagerDelegate

//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    
//    __weak TrackingViewController *wkself = self;
//    
//    //BOOL locationServicesAuthorized = [weakSelf.locationManager isLocationServicesAuthorized];
//    
//    if ([wkself.locationManager isLocationServicesEnabledAndAuthorized]) {
//        
//        if ([wkself.paramSelected.valora isEqualToString:@"1"]) {
//            
//            [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypeCamera];
//        }
//        else {
//            
//            [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^{
//                
//                [UIAlertViewManager progressHUShow];
//            }];
//        }
//    }
//    else {
//        
//        [UIAlertViewManager progressHUDDismis];
//    }
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    AppDebugECLog(@"didFailWithError: %@", error);
    
    [UIAlertViewManager progressHUDDismis];
    
    __weak TrackingViewController *wkself = self;
    
    [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:nil];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([error.domain compare:kCLErrorDomain options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            if (error.code == kCLErrorDenied && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                
                [UIAlertViewManager showAlertWithTitle:@"" message:NSLocalizedString(@"msg_errorDenied", @"") cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_settings_label",@""), nil] onDismiss:^(NSInteger buttonIndex){
                    
                    if (buttonIndex == 1) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
            }
            else {
                
                
                NSString *message = (error.code == kCLErrorDenied ?
                                     NSLocalizedString(@"msg_errorDenied", @"")
                                     : (error.code == kCLErrorNetwork ?
                                        NSLocalizedString(@"msg_errorNetwork", @"")
                                        : NSLocalizedString(@"msg_errorLocationUnknown", @"")));
                
                [UIAlertViewManager showAlertWithTitle:@"" message:message
                                     cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                                     otherButtonTitles:nil
                                             onDismiss:nil];
                
            }
        }
    }
    
    if (wkself.buttonStart.selected) {
        
        wkself.buttonStart.selected = NO;
        
        wkself.buttonStart.backgroundColor = UIColorFromHex(kColorRedStas);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    AppDebugECLog(@"didUpdateLocations");
    
    __weak TrackingViewController *wkself = self;
    
    for (__weak CLLocation *newLocation in locations) {
        
        AppDebugECLog(@"%@", locations);
        
        CLLocationAccuracy horizontalAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
        
        AppDebugECLog(@"timestamp:%@", [[NSString alloc] initWithFormat:@"%f", howRecent]);
        AppDebugECLog(@"horizontalAccuracy:%@", [[NSString alloc] initWithFormat:@"%f", horizontalAccuracy]);
        
        if (fabs(howRecent) <= 5.0f || fabs(horizontalAccuracy) <= 100.0f ) {
            
//            [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:^{
//                
//                if (wkself.buttonStart.isSelected) {
//                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        
//                        [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:nil];
//                    });
//                }
//            }];
            
            wkself.coordinate = CLLocationCoordinate3DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.altitude);
            
            [wkself requestInsertTrackingWithCoordinate:wkself.coordinate completion:^(NSString *data, NSError *error) {
                
                [wkself successRequestInsertTrackingWithData:data error:error];
            }];
            
            break;
        }
    }
}

#pragma mark - IBActions

- (IBAction)buttonStartPressed:(UIButton *)sender {
    
    __weak TrackingViewController *wkself = self;
    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
     
        [wkself requestLastGroupCompletion:^(NSString *data, NSError *error) {
            
            [wkself successRequestLastGroupWithData:data error:error];
        }];
    }
    else {
        
        sender.backgroundColor = UIColorFromHex(kColorRedStas);
        
        [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:nil];
    }
    
//    [wkself.locationManager requestAuthorizationLocationServicesWithDelegate:wkself completion:^{
//        
//        
//    }];
}

#pragma mark - Network

- (void)requestLastGroupCompletion:(void (^)(NSString *data, NSError *error))completion {
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager postLastTrackingGroupWithCompletion:^(NSString *responseCodeData, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                        
                        if (completion) completion(responseCodeData, error);
                    }
                    else {
                        
                        [NetworkManager postLastTrackingGroupWithCompletion:^(NSString *responseCodeData, NSError *error) {
                            
                            if (completion) completion(responseCodeData, error);
                        }];
                    }
                }];
            }
            else  {
                
                if (completion) completion(responseCodeData, error);
            }
        }
        else {
            
            if (completion) completion(responseCodeData, error);
        }
    }];
}

- (void)successRequestLastGroupWithData:(NSString *)responseCodeData error:(NSError *)error {
    
    __weak TrackingViewController *wkself = self;
    
    //    [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_checkin_params];
    if (error) {
        
        if (error.code == kCFURLErrorUserCancelledAuthentication) {
            
        }
        else if (error.code == kCFURLErrorNotConnectedToInternet) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorSignInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
    }
    else {
        
        wkself.trackingGroup = responseCodeData;
        
        if (![wkself.trackingGroup isEqualToString:@"-1"]) {
        
            [wkself dispatchOnMainQueue:^{
               
                [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^(BOOL success) {
                    
                    wkself.buttonStart.selected = success;
                    
                    wkself.buttonStart.backgroundColor = (success ? [UIColor lightGrayColor] : UIColorFromHex(kColorRedStas));
                }];
            }];
        }
    }
    
    [UIAlertViewManager progressHUDDismis];
}

- (void)requestInsertTrackingWithCoordinate:(CLLocationCoordinate3D)coordinate completion:(void (^)(NSString *data, NSError *error))completion {
    
    __weak TrackingViewController *wkself = self;
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    wkself.dateString = [NSString localDateStringWithName:userProfile.nomzonahoraria format:@"dd/MM/yyyy hh:mm:ss"];
    
//    NSInteger typeDevice = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 35 : 36;
    
    NSDictionary *postDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  userProfile.idusuario, kUrlInsertTrackingParam_idusuario,
                                  wkself.dateString, kUrlInsertTrackingParam_sfecha,
                                  [NSString stringWithFormat:@"%f", coordinate.latitude], kUrlInsertTrackingParam_latitud,
                                  [NSString stringWithFormat:@"%f", coordinate.longitude], kUrlInsertTrackingParam_longitud,
                                  [NSString stringWithFormat:@"%f", coordinate.altitude], kUrlInsertTrackingParam_altitud,
                                  [NSString stringWithFormat:@"%d", ([wkself.trackingGroup intValue] + 1)], kUrlInsertTrackingParam_idgrupotracking,
                                  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"35" : @"36"), kUrlInsertTrackingParam_tdispositivo,
                                  @"38", kUrlInsertTrackingParam_tplataforma,
                                  [[UIDevice currentDevice] systemVersion], kUrlInsertTrackingParam_vplataforma,
                                  @"0.0.0.0", kUrlInsertTrackingParam_ip,
                                  @"00:00:00:00", kUrlInsertTrackingParam_mac,
                                  nil];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager postInsertTrackingWithParams:postDataDict completion:^(NSString *responseCodeData, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                        
                        if (completion) completion(responseCodeData, error);
                    }
                    else {
                        
                        [NetworkManager postInsertTrackingWithParams:postDataDict completion:^(NSString *responseCodeData, NSError *error) {
                            
                            if (completion) completion(responseCodeData, error);
                        }];
                    }
                }];
            }
            else  {
                
                if (completion) completion(responseCodeData, error);
            }
        }
        else {
            
            if (completion) completion(responseCodeData, error);
        }
    }];
}

- (void)successRequestInsertTrackingWithData:(NSString *)responseCodeData error:(NSError *)error {
    
    __weak TrackingViewController *wkself = self;
    
    //    [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_checkin_params];
    if (error) {
        
        if (error.code == kCFURLErrorUserCancelledAuthentication) {
            
        }
        else if (error.code == kCFURLErrorNotConnectedToInternet) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorSignInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
    }
    else {
        
        NSDictionary *keyPairs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  wkself.dateString, @"date",
                                  [NSString stringWithFormat:@"%f", wkself.coordinate.latitude], @"latitude",
                                  [NSString stringWithFormat:@"%f", wkself.coordinate.longitude], @"longitude",
                                  [NSString stringWithFormat:@"%f", wkself.coordinate.altitude], @"altitude",
                                  wkself.trackingGroup, @"tracking",
                                  nil];
        
        [[DataBaseManagerSqlite class] insertFromClassName:@"TrackingItem" keyPairs:keyPairs where:nil];
        
        wkself.data = [[DataBaseManagerSqlite class]
                       selectFromClassName:@"TrackingItem"
                       where:[[NSArray alloc] initWithObjects:
                              [[TableClause alloc] initWithKey:@"tracking" value:wkself.trackingGroup operatorCondition:@"=" operatorExpression:nil], nil]];
        
        [wkself dispatchOnMainQueue:^{
           
            [wkself.tableView reloadData];
        }];
    }
    
    [UIAlertViewManager progressHUDDismis];
}

@end
