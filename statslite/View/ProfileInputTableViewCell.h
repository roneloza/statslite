//
//  ProfileInputTableViewCell.h
//  statslite
//
//  Created by rone shender loza aliaga on 4/16/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldUnderLine.h"

@interface ProfileInputTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TextFieldUnderLine *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@end
