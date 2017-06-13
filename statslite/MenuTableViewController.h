//
//  MenuTableViewController.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL skipReloadImageProfile;

- (void)refreshProfileUser;
@end
