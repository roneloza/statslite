//
//  UIAlertViewUsingBlock.m
//  ElComercioMovil
//
//  Created by Mar on 8/6/14.
//  Copyright (c) 2014 Empresa Editora El Comercio. All rights reserved.
//

#import "UIAlertViewUsingBlock.h"
#import "Constants.h"

//@implementation UIAlertViewDelegate
//
//
//@end

@interface UIAlertViewUsingBlock()

@end

@implementation UIAlertViewUsingBlock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIAlertViewUsingBlock *)alertViewWithTitle:(NSString*)title
                                      message:(NSString*)message
                            cancelButtonTitle:(NSString*)cancelButtonTitle
                            otherButtonTitles:(NSArray*)otherButtons
                                    onDismiss:(void(^)(NSInteger buttonIndex))block {
    
    
    UIAlertViewUsingBlock *alert = [[UIAlertViewUsingBlock alloc] initWithTitle:title
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:cancelButtonTitle
                                                              otherButtonTitles:nil];
    
    alert.dismissBlock = block;
    
    for(NSString *buttonTitle in otherButtons) {
        
        [alert addButtonWithTitle:buttonTitle];
    }
    
    __weak UIAlertViewUsingBlock *wkself = alert;
    
    alert.delegate = wkself;
    
    return alert;
}

+ (void)showAlertViewWithTitle:(NSString*)title
                                      message:(NSString*)message
                                     duration:(NSTimeInterval)duration {
    
    NSTimeInterval min = 1;
    NSTimeInterval max = 60;
    
    if (duration < min || duration > max) duration = min;
    
    UIAlertViewUsingBlock *alert = [[UIAlertViewUsingBlock alloc] initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    alert.dismissBlock = nil;
    
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+ (void)showAlertViewWithTitle:(NSString*)title
                       message:(NSString*)message
                      duration:(NSTimeInterval)duration
                         completion:(void (^)(void))completion {
    
    NSTimeInterval min = 1;
    NSTimeInterval max = 60;
    
    if (duration < min || duration > max) duration = min;
    
    UIAlertViewUsingBlock *alert = [[UIAlertViewUsingBlock alloc] initWithTitle:title
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:nil];
    alert.dismissBlock = nil;
    
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        if (completion) completion();
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertViewUsingBlock *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.dismissBlock) alertView.dismissBlock(buttonIndex);
}

- (void)dealloc {
    
    AppDebugECLog(@"deallocating %@", NSStringFromClass([self class]));
}

@end
