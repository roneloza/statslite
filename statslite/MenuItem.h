//
//  MenuItem.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface MenuItem : Item

@property (nonatomic, strong) NSArray *items;

- (id)initWithTitle:(NSString *)title items:(NSArray *)items;

@end
