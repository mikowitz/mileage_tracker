//
//  NewMileageViewController.h
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface NewMileageViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITextField *mileageField;
  IBOutlet UISegmentedControl *oilChangedControl;
  IBOutlet UIBarButtonItem *submitButton;
  RootViewController *navController;
}
@property (nonatomic, retain) UITextField *mileageField;
@property (nonatomic, retain) UISegmentedControl *oilChangedControl;
@property (nonatomic, retain) UIBarButtonItem *submitButton;
@property (nonatomic, retain) RootViewController *navController;
@end
