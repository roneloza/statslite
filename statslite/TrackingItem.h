//
//  TrackingItem.h
//  statslite
//
//  Created by rone loza on 6/7/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "Item.h"

@interface TrackingItem : Item

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *altitude;
@property (nonatomic, strong) NSString *tracking;

@end
