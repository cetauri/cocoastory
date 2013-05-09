//
//  AppDelegate.m
//  Cocoabook
//
//  Created by cetauri on 13. 5. 6..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import <baas.io/Baas.h>
#import "AppDelegate.h"

#import "ViewController.h"
#import "SignInViewController.h"
@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Baasio setApplicationInfo:@"cetauri" applicationName:@"cocoastory"];
    BaasioUser *currentUser = [BaasioUser currentUser];
    if (currentUser == nil) {
        [self login];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApplication:)
                                                     name:APP_LOGIN_FINISH_NOTIFICATION object:nil];
    }else{
        [self startApplication:nil];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)login{
    SignInViewController *controller = [[SignInViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
}

- (void)startApplication:(NSNotification*) noti
{
    
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
//    BoxListViewController *boxListViewController = [[BoxListViewController alloc] init];
//    UIViewController *viewController1 = [[UINavigationController alloc] initWithRootViewController:boxListViewController];
//    
//    DownloadViewController *downloadViewController = [[DownloadViewController alloc] init];
//    UIViewController *viewController2 = [[UINavigationController alloc] initWithRootViewController:downloadViewController];
//    
//    UploadViewController *uploadViewController = [[UploadViewController alloc] init];
//    UIViewController *viewController3 = [[UINavigationController alloc] initWithRootViewController:uploadViewController];
//    
//    SettingViewController *settingViewController = [[SettingViewController alloc] init];
//    UIViewController *viewController4 = [[UINavigationController alloc] initWithRootViewController:settingViewController];
//    
//    
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
//    self.window.rootViewController = self.tabBarController;
    
}



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"imin_ios.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return __persistentStoreCoordinator;
}
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
