//
//  TrackingViewController.h
//  statslite
//
//  Created by rone loza on 6/7/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "BaseViewController.h"

@interface TrackingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

- (IBAction)buttonStartPressed:(UIButton *)sender;

@end
