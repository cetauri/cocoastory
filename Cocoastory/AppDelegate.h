//
//  AppDelegate.h
//  Cocoabook
//
//  Created by cetauri on 13. 5. 6..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
