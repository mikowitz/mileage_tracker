//
//  MileageTrackerAppDelegate.h
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright SmartLogic Solutions 2009. All rights reserved.
//

#import "RootViewController.h"

@interface MileageTrackerAppDelegate : NSObject <UIApplicationDelegate> {
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;	    
  NSPersistentStoreCoordinator *persistentStoreCoordinator;

  UIWindow *window;
  UINavigationController *navController;
  
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
- (NSString *)applicationDocumentsDirectory;

@end

