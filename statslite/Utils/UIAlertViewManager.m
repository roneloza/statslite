//
//  UIAlertManager.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/14/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "UIAlertViewManager.h"
#import "UIAlertViewUsingBlock.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation UIAlertViewManager

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles onDismiss:(void (^)(NSInteger buttonIndex))onDismiss {
    
    UIAlertViewUsingBlock *alertView = [UIAlertViewUsingBlock alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles onDismiss:onDismiss];
    
    if ([NSThread isMainThread]) {
        
        [alertView show];
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alertView show];
        });
    }
}

+ (void)showAlertDismissHUDWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles onDismiss:(void (^)(NSInteger buttonIndex))onDismiss {
    
    UIAlertViewUsingBlock *alertView = [UIAlertViewUsingBlock alertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles onDismiss:onDismiss];
    
    if ([NSThread isMainThread]) {
        
        [SVProgressHUD dismiss];
        [alertView show];
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [alertView show];
        });
    }
}

+ (void)progressHUDSetMaskBlack {

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)progressHUDDismis {
    
    if ([NSThread isMainThread]) {
        
        [SVProgressHUD dismiss];
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
        });
    }
}

+ (void)progressHUShow {
    
    if ([NSThread isMainThread]) {
        
        [SVProgressHUD show];
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD show];
        });
    }
}

@end
