//
//  TrackingGroupViewController.h
//  statslite
//
//  Created by rone loza on 6/8/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "BaseViewController.h"

@interface TrackingGroupViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
