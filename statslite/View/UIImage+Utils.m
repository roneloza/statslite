//
//  UIImage+Utils.m
//  ElComercioMovil
//
//  Created by RLoza on 9/11/14.
//  Copyright (c) 2014 Empresa Editora El Comercio. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
 
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *imageFromColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageFromColor;
}

- (UIImage *)resizeImageToSize:(CGSize)reSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)imageSetTintColor:(UIColor *)tintColor {
    
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, newImage.scale);
    [tintColor set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageNamed:(NSString *)named tintColor:(UIColor *)tintColor {
    
    UIImage *image = [UIImage imageNamed:named];
    
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [tintColor set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
