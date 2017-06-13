//
//  MenuHeaderView.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "MenuHeaderView.h"

@implementation MenuHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup:(CGRect)frame {
    
    //MenuHeaderView *menuHeaderView= [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    
    //menuHeaderView.frame = self.bounds;
    //[self addSubview:menuHeaderView];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        [self setup:frame];
    }
    
    return self;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    CGRect frame = CGRectZero;
    
    [self setup:frame];
}

@end
