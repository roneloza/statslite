//
//  UIAlertViewUsingBlock.h
//  ElComercioMovil
//
//  Created by Mar on 8/6/14.
//  Copyright (c) 2014 Empresa Editora El Comercio. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^DismissBlock)(NSInteger buttonIndex);

@interface UIAlertViewUsingBlock : UIAlertView <UIAlertViewDelegate>

@property(nonatomic, copy) void(^dismissBlock)(NSInteger buttonIndex);

+ (UIAlertViewUsingBlock *)alertViewWithTitle:(NSString*)title
                                      message:(NSString*)message
                            cancelButtonTitle:(NSString*)cancelButtonTitle
                            otherButtonTitles:(NSArray*)otherButtons
                                    onDismiss:(void(^)(NSInteger buttonIndex))block;

+ (void)showAlertViewWithTitle:(NSString*)title
                       message:(NSString*)message
                      duration:(NSTimeInterval)duration;

+ (void)showAlertViewWithTitle:(NSString*)title
                       message:(NSString*)message
                      duration:(NSTimeInterval)duration
                    completion:(void (^)(void))completion;

@end
