//

#import "AppDelegate.h"
#import "DataHolder.h"
#import "CameraViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    UIViewController* rootController = application.keyWindow.rootViewController;
    if ([rootController isKindOfClass: [UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootController;
        UIViewController* rootController = [navigationController topViewController];
        if ([rootController isKindOfClass: [CameraViewController class]]) {
            CameraViewController* cameraViewController = (CameraViewController*)rootController;
            [cameraViewController stopRecording];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self storeData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self loadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self storeData];
}

- (BOOL)application:(UIApplication *)application
        willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadData];
    return YES;
}

- (void) loadData {
    [[DataHolder sharedInstance] loadData];
}

- (void) storeData {
    [[DataHolder sharedInstance] storeData];
}

@end
