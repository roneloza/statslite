//
//  MenuTableViewController.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "MenuTableViewController.h"
#import "CheckInViewController.h"
#import "Constants.h"
#import "PreferencesManager.h"
#import "MenuItem.h"
#import "MenuTableViewCell.h"
#import "MenuHeaderView.h"
#import "MenuTitleHeaderView.h"

#import "JSONParserManager.h"
#import "UserProfile.h"
#import "Constants.h"
#import "FireBaseManager.h"
#import "FileManager.h"

#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "ProfileViewController.h"
#import "SignInViewController.h"
#import "UINavigationController+Util.h"
#import "UIImage+Utils.h"

@interface MenuTableViewController ()

/**
 *@brief NSArray of *MenuItem
 **/
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger indexPathSelectedRow;
@property (nonatomic, weak) UIImageView *userImageView;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexPathSelectedRow = NSNotFound;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *options1 = [[NSArray alloc] initWithObjects:
                         [[Item alloc] initWithTitle:@"Marcación" content:nil enabled:YES storyBoarID:kStoryboardIdentifierCheckInVC imageNamed:@"ic_schedule"],
                         [[Item alloc] initWithTitle:@"Consultas" content:nil enabled:YES storyBoarID:kStoryboardIdentifierCheckInTableVC imageNamed:@"ic_find_in_page"],
//                        [[Item alloc] initWithTitle:@"Personas" content:nil enabled:NO imageNamed:@"ic_people"],
                         [[Item alloc] initWithTitle:@"Tracking" content:nil enabled:YES storyBoarID:kStoryboardIdentifierTrackingVC imageNamed:@"ic_my_location"],
                         [[Item alloc] initWithTitle:@"Tracking Mapa" content:nil enabled:YES storyBoarID:kStoryboardIdentifierTrackingGroupVC imageNamed:@"ic_my_location"],
//                        [[Item alloc] initWithTitle:@"Reporte" content:nil enabled:NO imageNamed:@"ic_insert_drive_file"],
                         [[Item alloc] initWithTitle:@"Mi Perfil" content:nil enabled:YES storyBoarID:kStoryboardIdentifierProfileVC imageNamed:@"ic_account_circle"],
//                        [[Item alloc] initWithTitle:@"Cambiar Clave" content:nil enabled:NO imageNamed:@"ic_lock"],
                        nil];
    
    NSArray *options2 = [[NSArray alloc] initWithObjects:
                         [[Item alloc] initWithTitle:@"Marcación" content:nil enabled:YES storyBoarID:kStoryboardIdentifierCheckInVC imageNamed:@"ic_schedule"],
                         [[Item alloc] initWithTitle:@"Consultas" content:nil enabled:YES storyBoarID:kStoryboardIdentifierCheckInTableVC imageNamed:@"ic_find_in_page"],
                         [[Item alloc] initWithTitle:@"Tracking" content:nil enabled:YES storyBoarID:kStoryboardIdentifierTrackingVC imageNamed:@"ic_my_location"],
                         [[Item alloc] initWithTitle:@"Tracking Mapa" content:nil enabled:YES storyBoarID:kStoryboardIdentifierTrackingGroupVC imageNamed:@"ic_my_location"],
//                        [[Item alloc] initWithTitle:@"Personas" content:nil enabled:NO imageNamed:@"ic_people"],
                         [[Item alloc] initWithTitle:@"Mi Perfil" content:nil enabled:YES storyBoarID:kStoryboardIdentifierProfileVC imageNamed:@"ic_account_circle"],
//                        [[Item alloc] initWithTitle:@"Cambiar Clave" content:nil enabled:NO imageNamed:@"ic_lock"],
                        nil];
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    
    self.data = [[NSArray alloc] initWithObjects:
                 [[MenuItem alloc] initWithTitle:@"Menu" items:(userProfile.idperfil == 10 ? options1 : options2)],
                 [[MenuItem alloc] initWithTitle:@"Ayuda" items:[[NSArray alloc] initWithObjects:
//                                                                 [[Item alloc] initWithTitle:@"Contactanos" content:nil enabled:NO imageNamed:@"ic_phone"],
                                                                 [[Item alloc] initWithTitle:@"Cerrar Sesión" content:nil enabled:YES imageNamed:@"ic_people"],
                                                                 nil]],
                 nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellHeaderIndentifierMenu bundle:nil] forHeaderFooterViewReuseIdentifier:kTableViewCellHeaderIndentifierMenu];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellTitleHeaderIndentifierMenu bundle:nil] forHeaderFooterViewReuseIdentifier:kTableViewCellTitleHeaderIndentifierMenu];
}

- (void)refreshProfileUser {
    
    
    [self refreshProfileImage];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([self.mm_drawerController.centerViewController isKindOfClass:[ProfileViewController class]]) {
        
        __weak ProfileViewController *vc = (ProfileViewController *)self.mm_drawerController.centerViewController;
        
        [vc hideKeyBoardTextField];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        
        statusBarFrame = [self.view convertRect:statusBarFrame fromView:nil];
        
        [self.tableView setContentInset:UIEdgeInsetsMake(statusBarFrame.size.height, 0, 0, 0)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    __weak MenuItem *menuItem = [self.data objectAtIndex:section];
    
    return menuItem.items.count;
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifierMenuList forIndexPath:indexPath];
    
    // Configure the cell...
    
    __weak MenuItem *menuItem = [self.data objectAtIndex:indexPath.section];
    
    __weak Item *item = [menuItem.items objectAtIndex:indexPath.row];
    
    cell.userInteractionEnabled = (item.enabled);
    
    cell.titleLabel.text = item.title;
    cell.iconImageView.image = [UIImage imageNamed:item.imageNamed tintColor:[UIColor darkGrayColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat heightForHeader = (section == 0 ? kTableViewCellHeaderHeightA : kTableViewCellHeaderHeightB);
    
    return heightForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    
    if (section == 0) {
        
        MenuHeaderView *menuHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewCellHeaderIndentifierMenu];
        
        UserProfile *userProfile = [JSONParserManager userProfile];
        
        menuHeaderView.userNameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", userProfile.pnombre, userProfile.apaterno, userProfile.amaterno];
        menuHeaderView.userEmailLabel.text = userProfile.ncorreo;
        menuHeaderView.userTypeLabel.text = userProfile.nomperfil;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.locations = [[NSArray alloc] initWithObjects:@0.0 , @1.0, nil];
        gradient.startPoint = CGPointMake(0.0, 1.0);
        gradient.endPoint = CGPointMake(1.0, 1.0);
        
        gradient.frame = menuHeaderView.bounds;
        
        gradient.colors = @[(id)UIColorFromHex(kColorMenuHeaderCellB).CGColor, (id)UIColorFromHex(kColorMenuHeaderCellA).CGColor];
        
        [menuHeaderView.userNameLabel.superview.layer insertSublayer:gradient atIndex:0];
        
        self.userImageView = menuHeaderView.userImageView;
        
        [self refreshProfileImage];
        
        headerView = menuHeaderView;
    }
    else {
        
        MenuTitleHeaderView *menuHeaderView = (MenuTitleHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewCellTitleHeaderIndentifierMenu];
        
        menuHeaderView.contentView.backgroundColor = [UIColor redColor];
        
        __weak MenuItem *item = self.data[section];
        
        menuHeaderView.titleLabel.text = item.title;
        
        headerView = menuHeaderView;
    }
    
    return headerView;
}

- (void)refreshProfileImage {
    
    __weak MenuTableViewController *wkself = self;
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
    NSString *pathFirebaseFile = [[NSString alloc] initWithFormat:@"%@/%@/%@", kFIREBASE_PHOTO_FOLDER, userProfile.idusuario, userProfile.idusuario];
    
    NSString *pathLocalFile = [FileManager appendingPathComponentAtDocumentDirectory:[[NSString alloc] initWithFormat:@"%@.jpg", [userProfile.idusuario stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    
    if ([FileManager fileExistsAtPath:pathLocalFile] && !wkself.skipReloadImageProfile) {
        
        NSData * _Nullable data = [FileManager dataFromFileAtPath:pathLocalFile];
        
        //        wkself.userImageView.image = [[UIImage alloc] initWithData:data];
        
        //        if (![NSThread isMainThread]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            wkself.userImageView.image = [[UIImage alloc] initWithData:data];
            [wkself.userImageView setNeedsLayout];
        });
        //        }
    }
    else {
        
        [FireBaseManager downloadPathFile:pathFirebaseFile completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (!error && data) {
                
                [FileManager writeFileAtPath:pathLocalFile data:data];
                
                //                wkself.userImageView.image = [[UIImage alloc] initWithData:data];
                
                //                if (![NSThread isMainThread]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    wkself.userImageView.image = [[UIImage alloc] initWithData:data];
                    [wkself.userImageView setNeedsLayout];
                });
                //                }
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.indexPathSelectedRow != indexPath.row) {
        
        __weak MenuItem *menuItem = [self.data objectAtIndex:indexPath.section];
        
        __weak Item *item = [menuItem.items objectAtIndex:indexPath.row];
        
        if ([item.title isEqualToString:@"Cerrar Sesión"]) {
            
            [PreferencesManager setPreferencesBOOL:NO forKey:kPrefUserLoged];
            
            if ([[self.navigationController rootViewController] isKindOfClass:[SignInViewController class]]) {
             
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                
                // Instantiate and set the left drawer controller.
                UIViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardIdentifierSignInVC];
                
                [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:signInViewController, nil] animated:YES];
            }
        }
        else {
            
            // Instantitate and set the center    view controller.
            UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:item.storyBoarID];
            
            [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
            
        }
    }
    else {
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    
    self.indexPathSelectedRow = self.tableView.indexPathForSelectedRow.row;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
