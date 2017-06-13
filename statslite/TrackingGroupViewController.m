//
//  TrackingGroupViewController.m
//  statslite
//
//  Created by rone loza on 6/8/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "TrackingGroupViewController.h"
#import "Constants.h"
#import "UIAlertViewManager.h"
#import "NetworkManager.h"
#import "UserProfile.h"
#import "JSONParserManager.h"
#import "TrackingTableViewCell.h"
#import "TrackingGroupItem.h"
#import "MapViewController.h"

#define kTrackingTableViewCell @"TrackingTableViewCell"
#define kSegueToMapIdentifier @"segue_to_map"

@interface TrackingGroupViewController ()

/**
 *@brief NSArray of *TrackingGroupItem
 **/
@property (nonatomic, strong) NSArray *data;

@end

@implementation TrackingGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshButtonPressed:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackingTableViewCell forIndexPath:indexPath];
    
    __weak TrackingGroupItem *item = [self.data objectAtIndex:indexPath.row];
    
    NSString *lbl1 = @"Fecha";
    NSString *lbl2 = @"Grupo";
    NSString *lbl3 = @"Dispositivo";
    NSString *lbl4 = @"Plataforma";
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@ : %@ %@\n%@ : %@\n%@ : %@\n%@ : %@", lbl1, item.tfecha, item.thoras, lbl2, [item.idgrupotracking description], lbl3, item.tdispositivo, lbl4, item.vplataforma];
    
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:UIColorFromHex(kColorRedStas), NSForegroundColorAttributeName , nil];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrString addAttributes:attr range:[text rangeOfString:lbl1]];
    [attrString addAttributes:attr range:[text rangeOfString:lbl2]];
    [attrString addAttributes:attr range:[text rangeOfString:lbl3]];
    [attrString addAttributes:attr range:[text rangeOfString:lbl4]];
    
    cell.textView.attributedText = attrString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak TrackingGroupViewController *wkself = self;
    
    __weak TrackingGroupItem *item = [self.data objectAtIndex:indexPath.row];
    
    [wkself requestDetailTrackingGroup:[item.idgrupotracking description] completion:^(NSArray *data, NSError *error) {
        
        [wkself successRequestDetailTrackingGroupWithData:data error:error];
    }];
}

#pragma mark - Network

- (void)requestListTrackingGroupCompletion:(void (^)(NSArray *data, NSError *error))completion {
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager getListTrackingGroupWithUserName:userProfile.idusuario completion:^(NSArray *data, NSError *error) {
        
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
                        
                        [NetworkManager getListTrackingGroupWithUserName:userProfile.idusuario completion:^(NSArray *data, NSError *error) {
                            
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

- (void)successRequestListTrackingGroupWithData:(NSArray *)data error:(NSError *)error {
    
    __weak TrackingGroupViewController *wkself = self;
    
    //    [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_checkin_params];
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
            
            [wkself.tableView reloadData];
        }];
    }
    
    [UIAlertViewManager progressHUDDismis];
}

- (void)requestDetailTrackingGroup:(NSString *)trackingGroup completion:(void (^)(NSArray *data, NSError *error))completion {
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager getListDetailTrackingGroupWithUserName:userProfile.idusuario trackingGroup:trackingGroup completion:^(NSArray *data, NSError *error) {
        
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
                        
                        [NetworkManager getListDetailTrackingGroupWithUserName:userProfile.idusuario trackingGroup:trackingGroup completion:^(NSArray *data, NSError *error) {
                            
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

- (void)successRequestDetailTrackingGroupWithData:(NSArray *)data error:(NSError *)error {
    
    __weak TrackingGroupViewController *wkself = self;
    
    //    [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_checkin_params];
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
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"iddev_tracking" ascending:YES];
        
        NSArray *items = [data sortedArrayUsingDescriptors:[[NSArray alloc] initWithObjects:sortDescriptor, nil]];
        
        [wkself dispatchOnMainQueue:^{
            
            [wkself performSegueWithIdentifier:kSegueToMapIdentifier sender:items];
        }];
    }
    
    [UIAlertViewManager progressHUDDismis];
}

#pragma mark - IBActions

- (void)refreshButtonPressed:(id)sender {
    
    __weak TrackingGroupViewController *wkself = self;
    
    [wkself requestListTrackingGroupCompletion:^(NSArray *data, NSError *error) {
        
        [wkself successRequestListTrackingGroupWithData:data error:error];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueToMapIdentifier]) {
        
        __weak MapViewController *mapViewVC = (MapViewController *)segue.destinationViewController;
        
        mapViewVC.data = sender;
    }
}

@end
