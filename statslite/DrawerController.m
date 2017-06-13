
#import "DrawerController.h"
#import "Constants.h"

@interface DrawerController ()

@end

@implementation DrawerController

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setMaximumLeftDrawerWidth:240];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
//    UIViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardIdentifierMenu];
//    [self setLeftDrawerViewController:menuViewController];
//
//    UIViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboardIdentifierCheckInVC];
//    [self setCenterViewController:firstViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

@end


@implementation UIViewController (DrawerController)

- (DrawerController*)drawerController
{
    UIViewController *parentViewController = self.parentViewController;
    
    while (parentViewController != nil)
    {
        if([parentViewController isKindOfClass:[DrawerController class]])
        {
            return (DrawerController*)parentViewController;
        }
        
        parentViewController = parentViewController.parentViewController;
    }
    
    return nil;
}

@end
