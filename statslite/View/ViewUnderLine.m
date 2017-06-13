//
//  ViewUnderLine.m
//  statslite
//
//  Created by Daniel on 4/17/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "ViewUnderLine.h"

@implementation ViewUnderLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setup];
}


- (void)setup {
    
    
    CGRect rect = self.bounds;
    rect.size.height = 1;
    
    self.underline = [[UIView alloc] initWithFrame:rect];
    self.underline.backgroundColor = [UIColor darkGrayColor];
    self.underline.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.underline];
    
    
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.underline, @"view", nil];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==1)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    //
    //    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==0)]"
    //                                                                         options:0
    //                                                                         metrics:nil
    //                                                                           views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
}

- (void)setUnderLineColor:(UIColor *)underLineColor {
    
    self.underline.backgroundColor = underLineColor;
}

@end
