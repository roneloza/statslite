//
//  MapViewController.h
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mapViewContent;
@property (weak, nonatomic) IBOutlet UIButton *closeMapButton;
- (IBAction)closeMapButtonPress:(UIButton *)sender;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

/**
 * @brief NSArray of *TrackingGroupItem
 **/
@property (nonatomic, strong) NSArray *data;

@end
