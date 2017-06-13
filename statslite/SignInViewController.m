//
//  ViewController.m
//  statslite
//
//  Created by Daniel on 7/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "SignInViewController.h"
#import "Constants.h"
#import "NetworkManager.h"
#import "PreferencesManager.h"
#import "UIAlertViewManager.h"
#import <MMDrawerController/MMDrawerController.h>
#import "JSONParserManager.h"
#import "CheckInViewController.h"
#import "MenuTableViewController.h"
#import "TextFieldIconUnderLine.h"
#import "UIImage+Utils.h"

#import <libkern/OSAtomic.h>

@interface SignInViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIAlertViewManager progressHUDSetMaskBlack];
    
    //self.loginView.layer.cornerRadius = self.loginView.bounds.size.width * 0.02f;
    //self.loginView.layer.borderWidth = 1.0f;
    //self.loginView.layer.borderColor = [UIColorFromHex(kColorLoginButtonBorder) CGColor];
    
//    [self.userNameTextField becomeFirstResponder];
//    
//    self.userNameTextField.delegate = self;
//    self.userPassTextField.delegate = self;
    
    self.userNameTextField.iconLeftImageView.image = [UIImage imageNamed:@"ic_account_circle" tintColor:[UIColor lightGrayColor]];
    self.userPassTextField.iconLeftImageView.image = [UIImage imageNamed:@"ic_lock" tintColor:[UIColor lightGrayColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.userNameTextField.delegate = self;
    self.userPassTextField.delegate = self;
    
    [self.userNameTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.userNameTextField.delegate = nil;
    self.userPassTextField.delegate = nil;
    
    self.userNameTextField.text = @"";
    self.userPassTextField.text = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textEditingChanged:(TextFieldIconUnderLine *)sender {
    
    NSString *text = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[sender iconRightImageView] setHidden:!([text length] == 0)];
}

- (IBAction)loginButtonPress:(UIButton *)sender {
    
    NSString *userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *userPass = [self.userPassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (userName.length > 0 && userPass.length > 0) {
        
        [self requestSigninService];
    }
    else {
        
        NSString *text = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [[self.userNameTextField iconRightImageView] setHidden:!([text length] == 0)];
        
        text = [self.userPassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [[self.userPassTextField iconRightImageView] setHidden:!([text length] == 0)];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.scrollView endEditing:YES];
    
    if (textField == self.userNameTextField) {
        
        [self.userPassTextField becomeFirstResponder];
    }
    else {
        
//        [textField resignFirstResponder];
        [self loginButtonPress:nil];
    }
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.textField = textField;
}


-(void)keyboardWillShow:(NSNotification *)notification {
    // Animate the current view out of the way
    
    __weak NSDictionary *userInfo = notification.userInfo;
    
    self.keyboardFrame = [(NSValue *)([userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    
    [self adjustingHeightShow:YES textField:self.textField scrollView:self.scrollView keyboardFrame:self.keyboardFrame];
    
    //    [self adjustingHeightShow:YES notification:notification];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    __weak NSDictionary *userInfo = notification.userInfo;
    
    self.keyboardFrame = [(NSValue *)([userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    
    [self adjustingHeightShow:NO textField:self.textField scrollView:self.scrollView  keyboardFrame:self.keyboardFrame];
    
    //    [self adjustingHeightShow:NO notification:notification];
}

#pragma mark - Fetch Data

- (void)requestSigninService {
    
    __weak SignInViewController *wkself = self;
    
    NSString *userName = [wkself.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *userPass = [wkself.userPassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *postDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  userName, kUrlApiUserParamName,
                                  userPass, kUrlApiUserParamPass,
                                  kUrlApiUserParamEncryptVal, kUrlApiUserParamEncrypt,
                                  nil];
    
    [UIAlertViewManager progressHUShow];
    
    [NetworkManager signInUserPassWithParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
        
        if (error) {
            
            if (error.code == kCFURLErrorUserCancelledAuthentication) {
                
                // Get token for Authorize
                
                NSDictionary *postDictToken = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               kUrlApiTokenParamNameVal, kUrlApiTokenParamName,
                                               kUrlApiTokenParamPassVal, kUrlApiTokenParamPass, nil];
                
                [NetworkManager getTokenWithParams:postDictToken completion:^(NSString *newToken, NSError *error) {
                    
                    if (error) {
                       
                        if (error.code == kCFURLErrorNotConnectedToInternet) {
                            
                            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
                        }
                        else {
                            
                            [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorSignInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
                        }
                    }
                    else {
                        
                        [wkself requestSigninServiceRetry:YES];
                    }
                    
                }];
            }
            else if (error.code == kCFURLErrorNotConnectedToInternet) {
                
                [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_notConnectedToInternet", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
            }
            else {
                
                [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_errorSignInService", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
            }
        }
        else {
            
            if (responseCodeData == kUrlApiUserResponseCodeSuccess) {
                
                [wkself requestSigninServiceRetry:NO];
            }
            else if (responseCodeData == kUrlApiUserResponseCodeNoUser) {
                
                [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_userName_fail", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
            }
            else if (responseCodeData == kUrlApiUserResponseCodeNoPass) {
                
                [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_userPass_fail", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
            }
        }
    }];
}

- (void)requestSigninServiceRetry:(BOOL)retry {
    
    __weak SignInViewController *wkself = self;
    
    NSString *userName = [wkself.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *userPass = [wkself.userPassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *postDataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  userName, kUrlApiUserParamName,
                                  userPass, kUrlApiUserParamPass,
                                  kUrlApiUserParamEncryptVal, kUrlApiUserParamEncrypt,
                                  nil];
    
    if (retry) {
        
        [NetworkManager signInUserPassWithParams:postDataDict completion:^(NSInteger responseCodeData, NSError *error) {
            
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
                
                if (responseCodeData == kUrlApiUserResponseCodeSuccess) {
                    
                    [NetworkManager getUserInfoPassWithUserName:userName completion:^(NSString *jsonStringData, NSError *error) {
                        
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
                            
                            [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_user_info];
                            
                            [wkself synchShowController];
                        }
                    }];
                }
                else if (responseCodeData == kUrlApiUserResponseCodeNoUser) {
                    
                    [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_userName_fail", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
                }
                else if (responseCodeData == kUrlApiUserResponseCodeNoPass) {
                    
                    [UIAlertViewManager showAlertDismissHUDWithTitle:@"" message:NSLocalizedString(@"msg_userPass_fail", nil) cancelButtonTitle:NSLocalizedString(@"btn_close_label", nil) otherButtonTitles:nil onDismiss:nil];
                }
            }
        }];
        
    }
    else {
        
        [NetworkManager getUserInfoPassWithUserName:userName completion:^(NSString *jsonStringData, NSError *error) {
            
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
                
                [PreferencesManager setPreferencesString:jsonStringData forKey:kJson_Key_user_info];
                
                [wkself synchShowController];
            }
        }];
    }

}

- (void)synchShowController {
    
    __weak SignInViewController *wkself = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIAlertViewManager progressHUDDismis];
        
        [wkself performSegueWithIdentifier:kSegueIdentifiShowDrawer sender:nil];
        
//        [wkself.textField resignFirstResponder];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueIdentifiShowDrawer]) {
        
        MMDrawerController *destinationViewController = (MMDrawerController *) segue.destinationViewController;
        
        // Instantitate and set the center    view controller.
        CheckInViewController *centerViewController = (CheckInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboardIdentifierCheckInVC];
        
        [PreferencesManager setPreferencesBOOL:YES forKey:kPrefUserLoged];
        
        [destinationViewController setCenterViewController:(UIViewController *)centerViewController];
        
        // Instantiate and set the left drawer controller.
        MenuTableViewController *leftDrawerViewController = (MenuTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboardIdentifierMenu];
        leftDrawerViewController.skipReloadImageProfile = YES;
        
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
    }
}

@end
