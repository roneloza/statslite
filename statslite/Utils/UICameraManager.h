//
//  UICameraManager.h
//  statslite
//
//  Created by rone shender loza aliaga on 4/15/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICameraManager : NSObject

+ (BOOL)isCameraUseAuthorized;
+ (void)requestPersmissionsCameraControllerFromViewController:(__weak id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)controller sourceType:(UIImagePickerControllerSourceType)sourceType;

+ (void)startCameraControllerFromViewController:(__weak id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)controller
                                     sourceType:(UIImagePickerControllerSourceType)sourceType;

+ (BOOL)isCameraAvailable;
@end
