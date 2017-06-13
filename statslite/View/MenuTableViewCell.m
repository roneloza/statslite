//
//  MenuTableViewCell.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Constants.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = UIColorFromHex((selected ? kColorMenuCellSelected : kColorMenuCell));
    
}

@end
