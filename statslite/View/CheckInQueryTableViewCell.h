//
//  CheckInQueryTableViewCell.h
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewUnderLine;
@interface CheckInQueryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *showMapButton;
@property (weak, nonatomic) IBOutlet UIButton *showPhotoButton;
@property (weak, nonatomic) IBOutlet ViewUnderLine *viewUnderLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightInfoTextView;

@property (nonatomic, assign) CGFloat heightChanged;

@end
