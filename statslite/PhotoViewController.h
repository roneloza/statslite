//
//  PhotoViewController.h
//  statslite
//
//  Created by Daniel on 4/25/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, assign) NSInteger checkinId;
@end
