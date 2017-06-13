//
//  CheckInViewController.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "CheckInViewController.h"
#import "Constants.h"
#import "CheckinTableViewCell.h"
#import "ParamInput.h"
#import "LocationManager.h"
#import "NetworkManager.h"
#import "PreferencesManager.h"
#import "UserProfile.h"
#import "JSONParserManager.h"
#import "UICameraManager.h"
#import "FireBaseManager.h"
#import "TextFieldIconRight.h"
#import "NetworkManager.h"
#import "UIImage+Utils.h"
#import "ParamCollectionViewCell.h"
#import "NSString+Utils.h"
#import "UIAlertViewManager.h"
#import "UnderLineTextView.h"
#import <CXAlertView/CXAlertView.h>

#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <FirebaseStorage/FirebaseStorage.h>


@interface CheckInViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) LocationManager *locationManager;

@property (nonatomic, weak) ParamInput *paramSelected;

@property (nonatomic, assign) CLLocationCoordinate3D coordinate;

@property (nonatomic, strong) NSData *photoData;

/**
 * @brief NSArray of *ParamInput
 **/
@property (nonatomic, strong) NSArray *data;
@property(nonatomic, strong) CXAlertView *alertCause;
@property(nonatomic, strong) UITextView *causetextView;

@property(nonatomic, assign) NSInteger checkinId;

@end

@implementation CheckInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CheckInViewController *wkself = self;
    
    wkself.locationManager = [[LocationManager alloc] init];
    
    wkself.coordinate = CLLocationCoordinate3DMake(0.0f, 0.0f, 0.0f);
    
    [wkself handleDisplayLink:nil];
    
    [UIAlertViewManager progressHUDSetMaskBlack];
    
    [UIAlertViewManager progressHUShow];
    
    [wkself requestParamImputsCompletion:^(NSArray *data, NSError *error) {
        
        [wkself successRequestParam:data error:error];
    }];
}

- (void)requestParamImputsCompletion:(void (^)(NSArray *data, NSError *error))completion {
    
    [NetworkManager getParamImputsWithCompletion:^(NSArray *data, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                        
                        if (completion) completion(data, error);
                    }
                    else {
                        
                        [NetworkManager getParamImputsWithCompletion:^(NSArray *data, NSError *error) {
                            
                            if (completion) completion(data, error);
                        }];
                    }
                }];
            }
            else  {
                
                if (completion) completion(data, error);
            }
        }
        else {
            
            if (completion) completion(data, error);
        }
    }];
}

- (void)successRequestParam:(NSArray *)data error:(NSError *)error {
    
    __weak CheckInViewController *wkself = self;
    
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
        
        wkself.data = data;
        
        [wkself dispatchOnMainQueue:^{
            
            [wkself.collectionView reloadData];
        }];
    }
    
    [UIAlertViewManager progressHUDDismis];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.frameInterval = 1;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    __weak CheckInViewController *wkself = self;
    
    [wkself.displayLink invalidate];
    wkself.displayLink = nil;
    
    [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:nil];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSString *dateString = [NSString localDateStringWithName:userProfile.nomzonahoraria format:@"hh:mm:ss a"];
    
    self.timeLabel.text = dateString;
}

- (void)requestCheckInServiceWithTypeCheckIn:(NSInteger)typeCheckIn coordinate:(CLLocationCoordinate3D)coordinate completion:(void (^)(NSInteger responseCodeData, NSError *error))completion {
    
    __weak CheckInViewController *wkself = self;
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSString *dateString = [NSString localDateStringWithName:userProfile.nomzonahoraria format:@"dd/MM/yyyy hh:mm:ss"];
    
    NSInteger typeDevice = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 35 : 36;
    
    NSString *inputText = (wkself.causetextView ? [wkself.causetextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"");
    
    NSDictionary *postDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"0", kUrlApiCheckInParam_idempresa,
                                  @"0", kUrlApiCheckInParam_idsucursal,
                                  @"0", kUrlApiCheckInParam_idhorario,
                                  @"0", kUrlApiCheckInParam_idturno,
                                  userProfile.idusuario, kUrlApiCheckInParam_idusuario,
                                  [NSString stringWithFormat:@"%d",(int)userProfile.idzonahoraria], kUrlApiCheckInParam_idzonahoraria,
                                  dateString, kUrlApiCheckInParam_sfmarcacion,
                                  [NSString stringWithFormat:@"%d",(int)typeCheckIn], kUrlApiCheckInParam_tmarcacion,
                                  [NSString stringWithFormat:@"%d",(int)typeDevice], kUrlApiCheckInParam_tdispositivo,
                                  @"0.0.0.0", kUrlApiCheckInParam_ip,
                                  @"00:00:00:00", kUrlApiCheckInParam_mac,
                                  [NSString stringWithFormat:@"%f", coordinate.latitude], kUrlApiCheckInParam_latitud,
                                  [NSString stringWithFormat:@"%f", coordinate.longitude], kUrlApiCheckInParam_longitud,
                                  inputText, kUrlApiCheckInParam_justificacion,
                                  userProfile.idusuario, kUrlApiCheckInParam_ucreacion,
                                  [NSString stringWithFormat:@"%f", coordinate.altitude], kUrlApiCheckInParam_altitud,
                                  @"38", kUrlApiCheckInParam_tplataforma,
                                  [[UIDevice currentDevice] systemVersion], kUrlApiCheckInParam_vplataforma,
                                  wkself.paramSelected.valora,kUrlApiCheckInParam_valora,
                                  nil];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager checkInUserParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                // Get token for Authorize
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                        
                        if (completion) completion(responseCodeData, error);
                    }
                    else {
                        
                        [NetworkManager checkInUserParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
                            
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

- (void)successCheckInWithResponseCodeData:(NSInteger)responseCodeData error:(NSError *)error {
    
    // Success service
    __weak CheckInViewController *wkself = self;
    
    if (error) {
        
        if (error.code == kCFURLErrorUserCancelledAuthentication) {
            
        }
        else if (error.code == kCFURLErrorNotConnectedToInternet) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorCheckInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
    }
    else {
        
        if (responseCodeData == kUrlApiCheckInResponseCodeError0 ||
            responseCodeData == kUrlApiCheckInResponseCodeError1 ||
            responseCodeData == kUrlApiCheckInResponseCodeError2) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorCheckInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            [wkself dispatchOnMainQueue:^{
               
                [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:wkself.paramSelected.valore cancelButtonTitle:NSLocalizedString(@"btn_ok_label", nil) otherButtonTitles:nil onDismiss:nil];
                
                wkself.checkinId = responseCodeData;
                
                if ([wkself.paramSelected.valora isEqualToString:@"1"]) {
                    
                    [wkself putPhotoDataToFirebaseWithIdentifier:responseCodeData];
                }
            }];
        }
    }
    
    [UIAlertViewManager progressHUDDismis];
}

- (void)showAlertCause {
    
    __weak CheckInViewController *wkself = self;
    
    if (!wkself.alertCause) {
        
        wkself.causetextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
        wkself.causetextView.backgroundColor = [UIColor clearColor];
        wkself.causetextView.font = [UIFont systemFontOfSize:14.0f];
        wkself.causetextView.autocorrectionType = UITextAutocorrectionTypeNo;
        
        wkself.alertCause = [[CXAlertView alloc] initWithTitle:NSLocalizedString(@"msg_inputCause", nil) contentView:wkself.causetextView cancelButtonTitle:NSLocalizedString(@"btn_cancel_label", nil)];
        
        [wkself.alertCause addButtonWithTitle:NSLocalizedString(@"btn_ok_label", nil) type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        
            [wkself.alertCause dismiss];
            
            if ([wkself.paramSelected.valora isEqualToString:@"1"]) {
                
                [UIAlertViewManager showAlertWithTitle:@"" message:NSLocalizedString(@"msg_pickerPhotoCheckIn", @"") cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_cancel_label",@""), nil] onDismiss:^(NSInteger buttonIndex){
                    
                    if (buttonIndex == 0) {
                        
                        [wkself.locationManager requestAuthorizationLocationServicesWithDelegate:wkself completion:^(BOOL success){
                            
                            if (success) {
                            
                                [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypeCamera];
                            }
                        }];
                    }
                }];
            }
            else {
                
                [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^(BOOL success) {
                    
                    if (success) {
                        
                        [UIAlertViewManager progressHUShow];
                    }
                }];
            }
        }];
        
        [wkself.alertCause setDidDismissHandler:^(CXAlertView *alertView) {
            
            [wkself.causetextView resignFirstResponder];
            wkself.causetextView.delegate = nil;
        }];
    }
    
    CXAlertButtonItem *alertButton = [wkself.alertCause.buttons objectAtIndex:1];
    alertButton.enabled = NO;
    [alertButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [wkself.alertCause show];
    
    [wkself.causetextView becomeFirstResponder];
    wkself.causetextView.delegate = wkself;
    wkself.causetextView.text = @"";
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    __weak CheckInViewController *wkself = self;
    
    //BOOL locationServicesAuthorized = [weakSelf.locationManager isLocationServicesAuthorized];
    
    if ([wkself.locationManager isLocationServicesEnabledAndAuthorized]) {
        
        if ([wkself.paramSelected.valora isEqualToString:@"1"]) {
            
            [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else {
            
            [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^(BOOL success) {
                
                if (success) {
                    
                    [UIAlertViewManager progressHUShow];
                }
            }];
        }
    }
    else {
        
        [UIAlertViewManager progressHUDDismis];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    AppDebugECLog(@"didFailWithError: %@", error);
    
    [UIAlertViewManager progressHUDDismis];
    
    __weak CheckInViewController *wkself = self;
    
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
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    AppDebugECLog(@"didUpdateLocations");
    
    __weak CheckInViewController *wkself = self;
    
    //BOOL locationServicesAuthorized = [wkself.locationManager isLocationServicesAuthorized];
    
//    CLLocation *newLocation = [locations lastObject];
    
//    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];

//    fabs(howRecent) <= 15.0 &&
//    && [newLocation verticalAccuracy] >= 0.0
    
    for (__weak CLLocation *newLocation in locations) {
     
        AppDebugECLog(@"%@", locations);
        
        CLLocationAccuracy horizontalAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
        
        AppDebugECLog(@"timestamp:%@", [[NSString alloc] initWithFormat:@"%f", howRecent]);
        AppDebugECLog(@"horizontalAccuracy:%@", [[NSString alloc] initWithFormat:@"%f", horizontalAccuracy]);
        
        if (fabs(howRecent) <= 5.0f || fabs(horizontalAccuracy) <= 100.0f ) {
            
            [wkself.locationManager stopUpdatingLocationWithDelegate:wkself completion:nil];
            
            wkself.coordinate = CLLocationCoordinate3DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.altitude);
            
            [wkself requestCheckInServiceWithTypeCheckIn:[wkself.paramSelected.idparametrodetalle integerValue] coordinate:wkself.coordinate completion:^(NSInteger responseCodeData, NSError *error) {
                
                [wkself  successCheckInWithResponseCodeData:responseCodeData error:error];
            }];
            
            break;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    picker.delegate = nil;
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    __weak NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    __weak NSURL *refURL = [info objectForKey: UIImagePickerControllerReferenceURL];
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo
        && !refURL) {
        
        UIImage *originalImage = (UIImage *) [info objectForKey:
                                              UIImagePickerControllerOriginalImage];
        
        // Save the new image (original or edited) to the Camera Roll
        //UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
        
        //self.mediaImageView.image = originalImage;
        
        UIImage *newOriginalImage = [UIImage scaleImage:originalImage toSize:CGSizeMake(256,256)];
        
        self.photoData = UIImageJPEGRepresentation(newOriginalImage, 1.0f);
    }
    // Handle a still image from library
    else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo
             && refURL) {
        
        UIImage *originalImage = (UIImage *) [info objectForKey:
                                              UIImagePickerControllerOriginalImage];
        
        //self.mediaImageView.image = originalImage;
        
        UIImage *newOriginalImage = [UIImage scaleImage:originalImage toSize:CGSizeMake(256,256)];
        
        self.photoData = UIImageJPEGRepresentation(newOriginalImage, 1.0f);
    }
    // Handle a movie capture
    else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo
             && !refURL) {
        
        __weak NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([movieURL path])) {
            
            UISaveVideoAtPathToSavedPhotosAlbum([movieURL path], nil, nil, nil);
        }
        
        //[self generateThumbnailImageFromMoviePath:movieURL];
        
    }
    // Handle a movie from library
    else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo
             && refURL) {
        
        //__weak NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //[self generateThumbnailImageFromMoviePath:movieURL];
    }
    
    // Start update Locations.
    
    CheckInViewController *wkself = self;
    
    [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^(BOOL success) {
        
        if (success) {
            
            [UIAlertViewManager progressHUShow];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Firebase

- (void)putPhotoDataToFirebaseWithIdentifier:(NSInteger)identifier {

    if (self.photoData) {
        
        [UIAlertViewManager progressHUShow];
        
        UserProfile *userProfile = [JSONParserManager userProfile];
        
        NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%i", userProfile.idusuario, (int)identifier];
        
        NSString *pathFileFirebase = [[NSString alloc] initWithFormat:@"%@/%@/%@", kFIREBASE_CHECKIN_FOLDER, userProfile.idusuario, fileName];
        
        [FireBaseManager uploadPathFile:pathFileFirebase fromData:self.photoData completion:^(NSError * _Nullable error) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(error ? @"msg_checkInErrorUploadPhoto" : @"msg_checkInSuccessUploadPhoto", nil) cancelButtonTitle:NSLocalizedString(@"btn_ok_label", nil) otherButtonTitles:nil onDismiss:nil];
            
//            [PreferencesManager addPhotoCheckIn:pathFileFirebase forKey:[[NSString alloc] initWithFormat:@"%d", identifier]];
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    __weak CXAlertButtonItem *alertButton = [self.alertCause.buttons objectAtIndex:1];
    
    alertButton.enabled = ([text length] > 0);

}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckInViewController *wkself = self;
    
    ParamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParamCollectionViewCell" forIndexPath:indexPath];
    cell.paramButton.layer.cornerRadius = cell.paramButton.bounds.size.width * 0.5f;
    
    cell.paramButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // you probably want to center it
    cell.paramButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    
    __weak ParamInput *param = wkself.data[indexPath.row];
    
    cell.paramButton.tag = indexPath.item;
    
    cell.paramButton.backgroundColor = ([param.valord isEqualToString:@"1"] ? UIColorFromHex(kColorRedStas) : [UIColor lightGrayColor]);
    
    [cell.paramButton setTitle:[param.nombre stringByReplacingOccurrencesOfString:@" " withString:@"\n"] forState:UIControlStateNormal];
    
    [cell.paramButton removeTarget:wkself action:@selector(paramButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.paramButton addTarget:wkself action:@selector(paramButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)paramButtonPress:(UIButton *)sender {
    
    __weak CheckInViewController *wkself = self;
    
    wkself.paramSelected = wkself.data[sender.tag];
    
    [UIAlertViewManager showAlertWithTitle:@"" message:wkself.paramSelected.valorc cancelButtonTitle:NSLocalizedString(@"btn_yes_label", nil) otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_no_label", nil), nil] onDismiss:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            
            if ([wkself.paramSelected.valorb isEqualToString:@"1"]) {
                
                [wkself showAlertCause];
            }
            else {
                
                if ([wkself.paramSelected.valora isEqualToString:@"1"]) {
                    
                    [UIAlertViewManager showAlertWithTitle:@"" message:NSLocalizedString(@"msg_pickerPhotoCheckIn", @"") cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_cancel_label",@""), nil] onDismiss:^(NSInteger buttonIndex){
                        
                        if (buttonIndex == 0) {
                            
                            [wkself.locationManager requestAuthorizationLocationServicesWithDelegate:wkself completion:^(BOOL success){
                                
                                if (success) {
                                 
                                    [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypeCamera];
                                }
                            }];
                        }
                    }];
                }
                else {
                    
                    [wkself.locationManager startUpdatingLocationWithDelegate:wkself completion:^(BOOL success) {
                        
                        if (success) {
                            
                            [UIAlertViewManager progressHUShow];
                        }
                    }];
                }
            }
        }
    }];
}

@end
