//
//  UIImage+Utils.h
//  ElComercioMovil
//
//  Created by RLoza on 9/11/14.
//  Copyright (c) 2014 Empresa Editora El Comercio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)resizeImageToSize:(CGSize)reSize;
- (UIImage *)imageSetTintColor:(UIColor *)tintColor;

+ (UIImage *)imageNamed:(NSString *)named tintColor:(UIColor *)tintColor;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
@end
