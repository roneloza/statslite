//
//  CheckInViewController.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "BaseViewController.h"

@class ParamInput, TextFieldIconRight;

@interface CheckInViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet TextFieldIconRight *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
