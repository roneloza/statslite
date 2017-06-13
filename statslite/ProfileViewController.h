//
//  ProfileViewController.h
//  statslite
//
//  Created by rone shender loza aliaga on 4/16/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "BaseViewController.h"

@class Item;

@interface ProfileViewController : BaseViewController

/**
 *@brief NSArray of *Item
 **/
@property (nonatomic, strong) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)saveProfileButtonPress:(UIBarButtonItem *)sender;
- (IBAction)showCameraButtonPress:(UIBarButtonItem *)sender;
- (IBAction)showPhotosButtonPress:(UIBarButtonItem *)sender;

- (void)hideKeyBoardTextField;
@end
