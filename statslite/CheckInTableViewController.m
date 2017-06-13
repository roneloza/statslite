//
//  CheckInTableViewController.m
//  statslite
//
//  Created by Daniel on 4/19/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "CheckInTableViewController.h"
#import "UIAlertViewManager.h"
#import "CheckInQueryTableViewCell.h"
#import "PreferencesManager.h"
#import "NetworkManager.h"
#import "UserProfile.h"
#import "JSONParserManager.h"
#import "CheckInItem.h"
#import "ViewUnderLine.h"
#import "MapViewController.h"
#import "PhotoViewController.h"
#import "Constants.h"
#import "NSString+Utils.h"

#define kTableViewCellIdentifierCheckInQuery @"CheckInQueryTableViewCell"

#define kTableViewCellCheckInQueryHeight 140
#define kTableViewCellTextViewHeight 86

@interface CheckInTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *data;
//@property (nonatomic, strong) WYPopoverController* popoverController;
@end

@implementation CheckInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = kTableViewCellCheckInQueryHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    __weak CheckInTableViewController *wkself = self;
    
    [UIAlertViewManager progressHUDSetMaskBlack];
    
    [UIAlertViewManager progressHUShow];
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSString *dateString = [NSString localDateStringWithName:userProfile.nomzonahoraria format:@"dd-MM-yyyy"];
    
    [wkself requestCheckInQueriesWithserName:userProfile.idusuario dateString:dateString completion:^(NSArray *data, NSError *error) {
        
        [wkself successRequestCheckInQueries:data error:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestCheckInQueriesWithserName:(NSString *)userName dateString:(NSString *)dateString completion:(void (^)(NSArray *data, NSError *error))completion {
    
    [NetworkManager getCheckInQueriesWithUserName:userName dateString:dateString completion:^(NSArray *data, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                        
                        if (completion) completion(data, error);
                    }
                    else {
                        
                        [NetworkManager getCheckInQueriesWithUserName:userName dateString:dateString completion:^(NSArray *checkInQueries, NSError *error) {
                            
                            if (completion) completion(data, error);
                        }];
                    }
                    
                }];
            }
            else  {
                
                if (completion) completion(data, error);
            }
        }
        else {
            
            if (completion) completion(data, error);
        }
    }];
}

- (void)successRequestCheckInQueries:(NSArray *)data error:(NSError *)error {
    
    __weak CheckInTableViewController *wkself = self;
    
    if (error) {
        
        if (error.code == kCFURLErrorUserCancelledAuthentication) {
            
        }
        
        else if (error.code == kCFURLErrorNotConnectedToInternet) {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
        else {
            
            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorSignInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
        }
    }
    else {
        
        wkself.data = data;
        
        [wkself dispatchOnMainQueue:^{
            
            if (data.count > 0) {
                
                wkself.infoTextView.hidden = YES;
                [wkself.tableView reloadData];
            }
            else {
                
                wkself.infoTextView.hidden = NO;
            }
            
            [UIAlertViewManager progressHUDDismis];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckInQueryTableViewCell *cell = (CheckInQueryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifierCheckInQuery forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.viewUnderLine.underLineColor = UIColorFromHex(kColorRedStas);
    
    __weak CheckInItem *item = [self.data objectAtIndex:indexPath.row];
    
    item.heightCell = kTableViewCellCheckInQueryHeight;
    item.heightTextViewFix = kTableViewCellTextViewHeight;
    
    NSRange range = [item.fmarcacion rangeOfString:@"T"];
    
    NSString *justify =  [item.justificacion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *formattedText = (justify.length > 0 ?
                               [[NSString alloc] initWithFormat:
                                @"%@ : %@\n"
                                "Sucursal : %@\n"
                                "Justificación : %@\n"
                                "Dispositivo : %@\n",
                                item.nomtmarcacion, (range.location != NSNotFound ? [[item.fmarcacion substringFromIndex:range.location] stringByReplacingOccurrencesOfString:@"T" withString:@""] : @""),
                                item.nomsucursal,
                                justify,
                                item.nomtdispositivo] :
                               [[NSString alloc] initWithFormat:
                                @"%@ : %@\n"
                                "Sucursal : %@\n"
                                "Dispositivo : %@\n",
                                item.nomtmarcacion, (range.location != NSNotFound ? [[item.fmarcacion substringFromIndex:range.location] stringByReplacingOccurrencesOfString:@"T" withString:@""] : @""),
                                item.nomsucursal,
                                item.nomtdispositivo]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:formattedText
                                                   attributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                               [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                                               [UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil]];
    
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(kColorRedStas) range:[formattedText rangeOfString:item.nomtmarcacion]];
    
    cell.infoTextView.attributedText = [attributedString copy];
    
    CGSize size = CGSizeMake(230, 86);
    
    [cell.infoTextView sizeToFit];
    
    CGSize newSize = cell.infoTextView.frame.size;
    
    if (newSize.height > size.height) {
        
        item.newHeightCell = (newSize.height - size.height);
        cell.constraintHeightInfoTextView.constant = kTableViewCellTextViewHeight + item.newHeightCell;
    }
    else {
        
        item.newHeightCell = 0;
        cell.constraintHeightInfoTextView.constant = kTableViewCellTextViewHeight + item.newHeightCell;
    }
    
    cell.showMapButton.tag = indexPath.row;
    
    [cell.showMapButton removeTarget:self action:@selector(showMapPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.showMapButton addTarget:self action:@selector(showMapPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.showPhotoButton.tag = indexPath.row;
    
    if ([item.valora isEqualToString:@"1"]) {
    
        [cell.showPhotoButton removeTarget:self action:@selector(showPhotoPress:) forControlEvents:UIControlEventTouchUpInside];
        [cell.showPhotoButton addTarget:self action:@selector(showPhotoPress:) forControlEvents:UIControlEventTouchUpInside];
        cell.showPhotoButton.hidden = NO;
    }
    else {
        cell.showPhotoButton.hidden = YES;
        [cell.showPhotoButton removeTarget:self action:@selector(showPhotoPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (IBAction)showMapPress:(id)sender {
    
    
    [self performSegueWithIdentifier:kSegueIdentifiShowMapButtonSegue sender:sender];
}

- (IBAction)showPhotoPress:(id)sender {
    
    [self performSegueWithIdentifier:kSegueIdentifiShowPhotoButtonSegue sender:sender];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak CheckInItem *item = [self.data objectAtIndex:indexPath.row];
    
    CGFloat heightForRow = (item.newHeightCell > 0 ? (kTableViewCellCheckInQueryHeight + item.newHeightCell) : kTableViewCellCheckInQueryHeight);
    
    return heightForRow;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueIdentifiShowMapButtonSegue]) {
        
        
        __weak CheckInItem *item = [self.data objectAtIndex:[sender tag]];
        
        MapViewController* destinationViewController = (MapViewController *)segue.destinationViewController;
        
        destinationViewController.latitude = [item.latitud doubleValue];
        destinationViewController.longitude = [item.longitud doubleValue];
    }
    else if ([segue.identifier isEqualToString:kSegueIdentifiShowPhotoButtonSegue]) {
        
        
        __weak CheckInItem *item = [self.data objectAtIndex:[sender tag]];
        
        PhotoViewController* destinationViewController = (PhotoViewController *)segue.destinationViewController;
        
        destinationViewController.checkinId = [item.idmarcacion integerValue];
    }
    
}

@end
