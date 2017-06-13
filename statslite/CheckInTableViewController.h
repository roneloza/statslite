//
//  CheckInTableViewController.h
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "BaseViewController.h"

@interface CheckInTableViewController : BaseViewController

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end
