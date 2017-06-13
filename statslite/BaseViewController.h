//
//  CheckInViewController.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (void)dispatchOnMainQueue:(void(^)(void))block;

- (void)adjustingHeightShow:(BOOL)show textField:(UITextField *)textField scrollView:(UIScrollView *)scrollView keyboardFrame:(CGRect)keyboardFrame;
@end
