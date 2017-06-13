//
//  CheckInViewController.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "BaseViewController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
}

- (void)setupLeftMenuButton {
    
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    
    NSMutableArray *toolbarButtons = [self.toolbar.items mutableCopy];
    
    if (toolbarButtons.count > 0) {
    
        [toolbarButtons replaceObjectAtIndex:0 withObject:leftDrawerButton];
        
        //    NSArray *toolbarButtons = [[NSArray alloc] initWithObjects:leftDrawerButton,
        //                               [[UIBarButtonItem alloc] initWithTitle:@"Stats (Lite)" style:UIBarButtonItemStylePlain target:nil action:nil], nil];
        
        [self.toolbar setItems:toolbarButtons];
    }
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)adjustingHeightShow:(BOOL)show textField:(UITextField *)textField scrollView:(UIScrollView *)scrollView keyboardFrame:(CGRect)keyboardFrame {
    
    __weak BaseViewController *wkself = self;
    
    scrollView.contentInset = UIEdgeInsetsZero;
    
    
    //    __weak NSDictionary *userInfo = notification.userInfo;
    //
    //    CGRect keyboardFrame = [(NSValue *)(userInfo[UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    
    //    CGFloat changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1);
    
    CGRect convertRectkeyboard = keyboardFrame;
    convertRectkeyboard.origin.y = wkself.view.bounds.size.height - keyboardFrame.size.height;
    
    CGRect convertRectTextField = [textField convertRect:textField.bounds toView:wkself.view];
    
    CGFloat changeInHeight = 0;
    
    if ((convertRectTextField.origin.y + convertRectTextField.size.height) >= convertRectkeyboard.origin.y) {
        
        changeInHeight = (convertRectTextField.origin.y + convertRectTextField.size.height) - convertRectkeyboard.origin.y;
    }
    
    //    changeInHeight = changeInHeight * (show ? 1 : -1);
    
    ////
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.bottom = changeInHeight;
    scrollView.contentInset = contentInset;
    //
    //    UIEdgeInsets scrollContentInset = wkself.scrollView.scrollIndicatorInsets;
    //    scrollContentInset.bottom = changeInHeight;
    //    wkself.scrollView.scrollIndicatorInsets = scrollContentInset;
    
    [scrollView setContentOffset:CGPointMake(0, changeInHeight) animated:YES];
}

- (void)dispatchOnMainQueue:(void(^)(void))block; {
    
    if ([NSThread isMainThread]) {
        
        if (block) block();
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), (block ? block : nil));
    }
}

@end
