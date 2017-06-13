//
//  MenuItem.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (id)initWithTitle:(NSString *)title items:(NSArray *)items {
    
    if ((self = [super init])) {
        
        self.title = title;
        _items = items;
    }
    
    return self;
}

@end
