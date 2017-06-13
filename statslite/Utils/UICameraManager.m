//
//  UICameraManager.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/15/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "UICameraManager.h"
#import "UIAlertViewManager.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@implementation UICameraManager

+ (BOOL)isCameraUseAuthorized {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    return status == AVAuthorizationStatusAuthorized;
}

+ (void)requestPersmissionsCameraControllerFromViewController:(__weak id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)controller
                                                   sourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        
        
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // Will get here on both iOS 7 & 8 even though camera permissions weren't required
                // until iOS 8. So for iOS 7 permission will always be granted.
                if (granted) {
                    // Permission has been granted. Use dispatch_async for any UI updating
                    // code because this block may be executed in a thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[self class] startCameraControllerFromViewController:controller sourceType:sourceType];
                    });
                    
                } else {
                    // Permission has been denied.
                }
            }];
        } else {
            // We are on iOS <= 6. Just do what we need to do.
            
            [[self class] startCameraControllerFromViewController:controller sourceType:sourceType];
        }
    }
}

+ (void)startCameraControllerFromViewController:(__weak id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)controller
                                     sourceType:(UIImagePickerControllerSourceType)sourceType {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized ||
        status == AVAuthorizationStatusNotDetermined) {
        
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.delegate = controller;
        
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary ||
            sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
            
            cameraUI.sourceType = sourceType;
            
            // Displays a control that allows the user to choose picture or
            // movie capture, if both are available:
            cameraUI.mediaTypes =
            [UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypePhotoLibrary];
            
            // Hides the controls for moving & scaling pictures, or for
            // trimming movies. To instead show the controls, use YES.
            [(UIViewController *)controller presentViewController:cameraUI animated:YES completion:NULL];
        }
        else {
            
            // Unvailable camera Simulator
            if (!([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ||
                (controller == nil)) {
                
                cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                // Displays a control that allows the user to choose picture or
                // movie capture, if both are available:
                cameraUI.mediaTypes =
                [UIImagePickerController availableMediaTypesForSourceType:
                 UIImagePickerControllerSourceTypePhotoLibrary];
                
                // Hides the controls for moving & scaling pictures, or for
                // trimming movies. To instead show the controls, use YES.
                [(UIViewController *)controller presentViewController:cameraUI animated:YES completion:NULL];
            }
            else {
                
                cameraUI.sourceType = sourceType;
                
                // Displays a control that allows the user to choose picture or
                // movie capture, if both are available:
                cameraUI.mediaTypes =
                [UIImagePickerController availableMediaTypesForSourceType:
                 UIImagePickerControllerSourceTypeCamera];
                
                // Hides the controls for moving & scaling pictures, or for
                // trimming movies. To instead show the controls, use YES.
                [(UIViewController *)controller presentViewController:cameraUI animated:YES completion:NULL];
            }
        }
    }
    else {
        
        [UIAlertViewManager showAlertWithTitle:@""
                                       message:NSLocalizedString(@"msg_cameraServicesDenied", @"")
                             cancelButtonTitle:NSLocalizedString(@"btn_ok_label",@"")
                             otherButtonTitles:(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [[NSArray alloc] initWithObjects:NSLocalizedString(@"btn_prefs_label",@""), nil] : nil)
                                     onDismiss:^(NSInteger buttonIndex){
                                         
                                         if (buttonIndex == 1) {
                                             
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
                                         }
                                     }];
    }
}

+ (BOOL)isCameraAvailable {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
