//
//  RootViewController.h
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mileage.h"

@interface RootViewController : UITableViewController {
  IBOutlet NSMutableArray *mileageArray;
  IBOutlet NSManagedObjectContext *managedObjectContext;
  IBOutlet UIBarButtonItem *addButton;
}
@property (nonatomic, retain) IBOutlet NSMutableArray *mileageArray;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
-(void)addMileage;
@end
