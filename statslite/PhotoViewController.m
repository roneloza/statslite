//
//  PhotoViewController.m
//  statslite
//
//  Created by Daniel on 4/25/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "PhotoViewController.h"
#import "FireBaseManager.h"
#import "PreferencesManager.h"
#import "FileManager.h"
#import "UserProfile.h"
#import "JSONParserManager.h"
#import "Constants.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshImage];
}

- (void)refreshImage {
    
    __weak PhotoViewController *wkself = self;
    
    UserProfile *userProfile = [JSONParserManager userProfile];
    
//    NSString *pathFirebaseFile = [PreferencesManager getPhotoCheckInForKey:[[NSString alloc] initWithFormat:@"%d", self.checkinId]];
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%d", userProfile.idusuario, (int)self.checkinId];
    
    NSString *pathFileFirebase = [[NSString alloc] initWithFormat:@"%@/%@/%@", kFIREBASE_CHECKIN_FOLDER, userProfile.idusuario, fileName];
    
    if (pathFileFirebase.length > 0) {
     
        [FireBaseManager downloadPathFile:pathFileFirebase completion:^(NSData *data, NSError *error) {
            
            if (!error && data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [wkself.spinner stopAnimating];
                    wkself.photoImageView.image = [[UIImage alloc] initWithData:data];
                    [wkself.photoImageView setNeedsLayout];
                });
            }
        }];
    }
    else {
        
        [wkself.spinner stopAnimating];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonPress:(UIButton *)sender {
    
    if (self.presentingViewController) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
