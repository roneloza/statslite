//
//  ViewController.h
//  statslite
//
//  Created by Daniel on 7/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "BaseViewController.h"

@class TextFieldIconUnderLine;

@interface SignInViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TextFieldIconUnderLine *userNameTextField;
@property (weak, nonatomic) IBOutlet TextFieldIconUnderLine *userPassTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;

- (IBAction)textEditingChanged:(TextFieldIconUnderLine *)sender;

- (IBAction)loginButtonPress:(UIButton *)sender;
@end

