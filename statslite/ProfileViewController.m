//
//  ProfileViewController.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/16/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "ProfileViewController.h"
#import "MenuItem.h"
#import "Constants.h"
#import "ProfileInputTableViewCell.h"
#import "ImageHeaderView.h"
#import "PreferencesManager.h"
#import "UserProfile.h"
#import "JSONParserManager.h"
#import "Constants.h"
#import "FileManager.h"
#import "NetworkManager.h"
#import "FireBaseManager.h"
#import "UICameraManager.h"
#import "UIImage+Utils.h"
#import "UIAlertViewManager.h"
#import "MenuTableViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#define kTableViewCellProfileHeaderHeight 140.0f
#define kTableViewCellProfileHeight 70

#define kOFFSET_FOR_KEYBOARD 80.0


@interface ProfileViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *userImageView;
@property (nonatomic, strong) NSData *photoData;
@property(nonatomic, strong) NSMutableDictionary *dictInputTextFied;

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation ProfileViewController

- (void)hideKeyBoardTextField {
    
    for (NSString *key in self.dictInputTextFied) {
        
        __weak UITextField *textfield = [self.dictInputTextFied valueForKey:key];
        
        [textfield resignFirstResponder];
    }
}

- (NSMutableDictionary *)dictInputTextFied {
    
    if (!_dictInputTextFied) {
        
        _dictInputTextFied = [[NSMutableDictionary alloc] init];
    }
    
    return _dictInputTextFied;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellIndentifierHeaderProfileInput bundle:nil] forHeaderFooterViewReuseIdentifier:kTableViewCellIndentifierHeaderProfileInput];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(.0f, .0f, .0f, .0f);
    
    [self refreshData];
}

- (void)refreshData {
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    self.data = [[NSArray alloc] initWithObjects:
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Primer Nombre", nil) content:userProfile.pnombre enabled:YES key:kUrlApiProfileParam_pnombre],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Segundo Nombre", nil) content:userProfile.snombre enabled:YES key:kUrlApiProfileParam_snombre],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Apellido Paterno", nil) content:userProfile.apaterno enabled:YES key:kUrlApiProfileParam_apaterno],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Apellido Materno", nil) content:userProfile.amaterno enabled:YES key:kUrlApiProfileParam_amaterno],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Genero", nil) content:(userProfile.genero == 0 ? @"Masculino" : @"Femenino") enabled:NO],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Estado Civil", nil) content:(userProfile.ecivil == 0 ? @"Soltero" : @"Casado") enabled:NO],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Telefono", nil) content:[[NSString alloc] initWithFormat:@"%i", (int)userProfile.ttelefono] enabled:NO],
                 [[Item alloc] initWithTitle:NSLocalizedString(@"Correo", nil) content:userProfile.ncorreo enabled:NO key:kUrlApiProfileParam_ncorreo],
                 nil];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//-(void)keyboardWillShow:(NSNotification *)notification {
//    // Animate the current view out of the way
//    
////    [self adjustingHeightShow:YES notification:notification];
//}
//
//-(void)keyboardWillHide:(NSNotification *)notification {
//    
////    [self adjustingHeightShow:NO notification:notification];
//}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.textField = textField;
}


-(void)keyboardWillShow:(NSNotification *)notification {
    // Animate the current view out of the way
    
    __weak NSDictionary *userInfo = notification.userInfo;
    
    self.keyboardFrame = [(NSValue *)([userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    
    [self adjustingHeightShow:YES textField:self.textField scrollView:self.tableView keyboardFrame:self.keyboardFrame];
    
    //    [self adjustingHeightShow:YES notification:notification];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    __weak NSDictionary *userInfo = notification.userInfo;
    
    self.keyboardFrame = [(NSValue *)([userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    
    [self adjustingHeightShow:NO textField:self.textField scrollView:self.tableView  keyboardFrame:self.keyboardFrame];
    
    //    [self adjustingHeightShow:NO notification:notification];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

//- (void)adjustingHeightShow:(BOOL)show notification:(NSNotification *)notification {
// 
//    __weak NSDictionary *userInfo = notification.userInfo;
// 
//    CGRect keyboardFrame = [(NSValue *)(userInfo[UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
// 
//    CGFloat changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1);
//    
//    UIEdgeInsets contentInset = self.tableView.contentInset;
//    contentInset.bottom += changeInHeight;
//    self.tableView.contentInset = contentInset;
//    
//    UIEdgeInsets scrollContentInset = self.tableView.scrollIndicatorInsets;
//    scrollContentInset.bottom += changeInHeight;
//    self.tableView.scrollIndicatorInsets = scrollContentInset;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.data.count;
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileInputTableViewCell *cell = (ProfileInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCellIndentifierProfileInput forIndexPath:indexPath];
    
    // Configure the cell...
    
    __weak Item *item = self.data[indexPath.row];
    
    cell.titleLabel.text = item.title;
    cell.inputTextField.text = item.content;
    cell.inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    cell.maskView.hidden = item.enabled;
    
    __weak UITextField *textField = cell.inputTextField;
    textField.delegate = self;
    
    if (item.key) {
        
        [self.dictInputTextFied setValue:textField forKey:item.key];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kTableViewCellProfileHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kTableViewCellProfileHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    
    if (section == 0) {
        
        ImageHeaderView *imageHeaderView = (ImageHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewCellIndentifierHeaderProfileInput];
        
        self.userImageView = imageHeaderView.imageView;
        
        [self refreshProfileImage];
        
        headerView = imageHeaderView;
    }
    
    return headerView;
}

#pragma mark - UI

- (void)refreshProfileImage {
    
    __weak ProfileViewController *wkself = self;
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSString *pathFirebaseFile = [[NSString alloc] initWithFormat:@"%@/%@/%@", kFIREBASE_PHOTO_FOLDER, userProfile.idusuario, userProfile.idusuario];
    
    NSString *pathLocalFile = [FileManager appendingPathComponentAtDocumentDirectory:[[NSString alloc] initWithFormat:@"%@.jpg", [userProfile.idusuario stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    if ([FileManager fileExistsAtPath:pathLocalFile]) {
        
        NSData *data = [FileManager dataFromFileAtPath:pathLocalFile];
        
        [wkself dispatchOnMainQueue:^{
           
            wkself.userImageView.image = [[UIImage alloc] initWithData:data];
            [wkself.userImageView setNeedsLayout];
        }];
 
    }
    else {
        
        [FireBaseManager downloadPathFile:pathFirebaseFile completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (!error && data) {
                
                [FileManager writeFileAtPath:pathLocalFile data:data];
                
                [wkself dispatchOnMainQueue:^{
                    
                    wkself.userImageView.image = [[UIImage alloc] initWithData:data];
                    [wkself.userImageView setNeedsLayout];
                }];
            }
        }];
    }
}

- (IBAction)saveProfileButtonPress:(UIBarButtonItem *)sender {
    
    __weak ProfileViewController *wkself = self;
    
    [wkself requestUpdateProfileWithCompletion:^(NSInteger responseCodeData, NSError *error) {
        
        [wkself successUpdateProfile:responseCodeData error:error];
    }];
}

- (void)requestUpdateProfileWithCompletion:(void (^)(NSInteger responseCodeData, NSError *error))completion {
 
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    
    NSString *sDateNow = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *postDataDict = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in self.dictInputTextFied.allKeys) {
        
        __weak UITextField *textField = [self.dictInputTextFied valueForKey:key];
        
        [postDataDict setValue:textField.text forKey:key];
        
    }
    
    NSDictionary *paramDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   userProfile.tnombre, kUrlApiProfileParam_tnombre,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.ecivil], kUrlApiProfileParam_ecivil,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.genero], kUrlApiProfileParam_genero,
                                   sDateNow, kUrlApiProfileParam_sfactualizacion,
                                   userProfile.idusuario, kUrlApiProfileParam_idusuario,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.idpersona], kUrlApiProfileParam_idpersona,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.idpersona_correo], kUrlApiProfileParam_idpersona_correo,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.idpersona_telefono], kUrlApiProfileParam_idpersona_telefono,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.ttelefono], kUrlApiProfileParam_ttelefono,
                                   [NSString stringWithFormat:@"%d",(int)userProfile.idoperador], kUrlApiProfileParam_idoperador,
                                   userProfile.ntelefono, kUrlApiProfileParam_ntelefono,
                                   userProfile.ncorreo, kUrlApiProfileParam_ncorreo,
                                   nil];
    
    [postDataDict addEntriesFromDictionary:paramDataDict];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager putProfileUserParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
        
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
                        
                        [NetworkManager putProfileUserParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
                            
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

- (void)successUpdateProfile:(NSInteger)responseCodeData error:(NSError *)error {
    
    __weak ProfileViewController *wkself = self;
    
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
        
        if (responseCodeData == kUrlApiProfileResponseCodeError1 ||
            responseCodeData == kUrlApiProfileResponseCodeError2) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorCheckInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            NSMutableDictionary *postDataDict = [[NSMutableDictionary alloc] init];
            
            for (NSString *key in self.dictInputTextFied.allKeys) {
                
                __weak UITextField *textField = [self.dictInputTextFied valueForKey:key];
                
                [postDataDict setValue:textField.text forKey:key];
            }
            
            [JSONParserManager updateProfileJSONFromDict:postDataDict];
            
            [wkself dispatchOnMainQueue:^{
               
                if ([wkself.mm_drawerController.leftDrawerViewController isKindOfClass:[MenuTableViewController class]]) {
                    
                    __weak MenuTableViewController *vc = (MenuTableViewController *)wkself.mm_drawerController.leftDrawerViewController;
                    
                    [vc refreshProfileUser];
                }
            }];
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_successUpdateProfileService", nil) cancelButtonTitle:NSLocalizedString(@"btn_ok_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
    }
}

- (IBAction)showCameraButtonPress:(UIBarButtonItem *)sender {
    
    __weak ProfileViewController *wkself = self;
    
    [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showPhotosButtonPress:(UIBarButtonItem *)sender {
    
    __weak ProfileViewController *wkself = self;
    [UICameraManager startCameraControllerFromViewController:(id)wkself sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self putPhotoDataToFirebase];
}

#pragma mark - Firebase

- (void)putPhotoDataToFirebase {
    
    if (self.photoData) {
        
        [UIAlertViewManager progressHUShow];
        
        __weak ProfileViewController *wkself = self;
        
        UserProfile *userProfile = [JSONParserManager userProfile];
        
        NSString *pathFileFirebase = [[NSString alloc] initWithFormat:@"%@/%@/%@", kFIREBASE_PHOTO_FOLDER, userProfile.idusuario, userProfile.idusuario];
        
        NSString *pathLocalFile = [FileManager appendingPathComponentAtDocumentDirectory:[[NSString alloc] initWithFormat:@"%@.jpg", [userProfile.idusuario stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
        
        [FireBaseManager uploadPathFile:pathFileFirebase fromData:wkself.photoData completion:^(NSError * _Nullable error) {
            
            [FileManager writeFileAtPath:pathLocalFile data:wkself.photoData];
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(error ? @"msg_checkInErrorUploadPhoto" : @"msg_checkInSuccessUploadPhoto", nil) cancelButtonTitle:NSLocalizedString(@"btn_ok_label", nil) otherButtonTitles:nil onDismiss:^(NSInteger buttonIndex) {
                
                wkself.userImageView.image = [[UIImage alloc] initWithData:wkself.photoData];
                [wkself.userImageView setNeedsLayout];
                
                if ([wkself.mm_drawerController.leftDrawerViewController isKindOfClass:[MenuTableViewController class]]) {
                    
                    __weak MenuTableViewController *vc = (MenuTableViewController *)wkself.mm_drawerController.leftDrawerViewController;
                    
                    [vc refreshProfileUser];
                }
            }];
        }];
    }
}

@end
