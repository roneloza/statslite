
#import <MMDrawerController/MMDrawerController.h>

@interface DrawerController : MMDrawerController

@end

@interface UIViewController (DrawerController)

@property(nonatomic, strong, readonly) DrawerController *drawerController;

@end