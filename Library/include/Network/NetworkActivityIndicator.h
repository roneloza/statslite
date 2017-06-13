//
//  NetworkActivityIndicator.h
//  Network
//
//  Created by Rone Loza on 4/2/14.
//  Copyright (c) 2014 Empresa Editora El Comercio. All rights reserved.
//

#import <Foundation/Foundation.h>

/// \brief
/// An NetworkActivityIndicator object provides support to manage the indicator of network activity on or off.
///
@interface NetworkActivityIndicator : NSObject

+ (NetworkActivityIndicator *)shared;

/// \brief
/// Increments the counter global of the network activity and \b show the network activity indicator.
///
- (void)startActivity;

/// \brief
/// Decrements the counter global of the network activity and if counter global is \b zero then \b hides the network activity indicator.
///
- (void)stopActivity;

/// \brief
/// Reset the counter global of the network activity to zero and then \b hides the network activity indicator.
///
- (void)resetActivity;

/// \brief
/// The counter global of indicator of network activity.
/// If is \b zero the indicator of network activity will hide.
///
@property (nonatomic, assign, readonly) volatile int32_t counter_network_activity;


@end
