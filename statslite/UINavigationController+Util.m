//
//  UINavigationController+Util.m
//  statslite
//
//  Created by Daniel on 4/18/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "UINavigationController+Util.h"

@implementation UINavigationController (Util)

- (UIViewController *)rootViewController {
    
    if (self.viewControllers.count > 0 ) {
        
        return [self.viewControllers objectAtIndex:0];
    }
    
    return nil;
}

@end
