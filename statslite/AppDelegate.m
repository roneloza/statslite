//
//  AppDelegate.m
//  statslite
//
//  Created by rone shender loza aliaga on 4/14/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import "AppDelegate.h"
#import <FirebaseAnalytics/FIRApp.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <MMDrawerController/MMDrawerController.h>
#import "Constants.h"
#import "PreferencesManager.h"
#import "DataBaseManagerSqlite.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    
    // [START storageauth]
    // Using Cloud Storage for Firebase requires the user be authenticated. Here we are using
    // anonymous authentication.
    if (![FIRAuth auth].currentUser) {
        [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable user,
                                                          NSError * _Nullable error) {
            
            
        }];
    }
    // [END storageauth]
    
    
    [GMSServices provideAPIKey:@"AIzaSyADU4NXgwPs5H7dM5Y_5K9jZ9NCsc-AKX4"];
    
    self.navigationController = ([self.window.rootViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self.window.rootViewController : nil);
    
    BOOL logged = [PreferencesManager getPreferencesBOOLForKey:kPrefUserLoged];
    
    
    if (logged) {
     
        MMDrawerController *destinationViewController = (MMDrawerController *)UIStoryboardInstantiateViewControllerWithIdentifier(kStoryboardMain,kStoryboardIdentifierDrawer);
        
        // Instantitate and set the center    view controller.
        UIViewController *centerViewController = UIStoryboardInstantiateViewControllerWithIdentifier(kStoryboardMain, kStoryboardIdentifierCheckInVC);
        
        [destinationViewController setCenterViewController:centerViewController];
        
        // Instantiate and set the left drawer controller.
        UIViewController *leftDrawerViewController = UIStoryboardInstantiateViewControllerWithIdentifier(kStoryboardMain, kStoryboardIdentifierMenu);
        
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
        
        [self.navigationController setViewControllers:[[NSArray alloc] initWithObjects:destinationViewController, nil] animated:NO];
    }
    
    [DataBaseManagerSqlite createDataBase];
    
    //    [DataBaseManagerSqlite createSchemeTableFromClassName:NSStringFromClass([DetailInfoItem class]) uniqueFields:[[NSArray alloc] initWithObjects:@"idmenu", @"idmenudetalle", nil]];
    
    [DataBaseManagerSqlite createSchemeTableFromClassName:@"TrackingItem" uniqueFields:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
