//
//  TextFieldIconUnderLine.m
//  statslite
//
//  Created by Daniel on 4/18/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "TextFieldIconUnderLine.h"
#import "UIImage+Utils.h"

@implementation TextFieldIconUnderLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 40, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 40, 10);
}

- (void)setup {
    
    [super setup];
    
    self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    CGRect rect = self.bounds;
    rect.origin.x = 40;
    rect.size.height = 30.0f;
    rect.size.width = 30.0f;
    
    self.iconLeftImageView = [[UIImageView alloc] initWithFrame:rect];
    self.iconLeftImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconLeftImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.iconLeftImageView];
    
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.iconLeftImageView, @"iconLeftImageView", nil];
    
    
    [self addConstraints:[[NSArray alloc] initWithObjects:[NSLayoutConstraint constraintWithItem:self.iconLeftImageView
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                      multiplier:1.f constant:0.f], nil]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconLeftImageView(==30)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconLeftImageView(==30)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
   
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[iconLeftImageView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:viewsDictionary]];
    
    self.iconRightImageView = [[UIImageView alloc] initWithFrame:rect];
    self.iconRightImageView.hidden = YES;
    
    self.iconRightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconRightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconRightImageView.image = [UIImage imageNamed:@"ic_warning" tintColor:[UIColor redColor]];
    
    [self addSubview:self.iconRightImageView];
    
    viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.iconRightImageView, @"iconRightImageView", nil];
    
    
    [self addConstraints:[[NSArray alloc] initWithObjects:[NSLayoutConstraint constraintWithItem:self.iconRightImageView
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                      multiplier:1.f constant:0.f], nil]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconRightImageView(==20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconRightImageView(==20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconRightImageView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
}
@end
