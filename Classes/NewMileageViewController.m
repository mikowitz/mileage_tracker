//
//  NewMileageViewController.m
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "NewMileageViewController.h"
#import "Mileage.h"
#import "MileageTrackerAppDelegate.h"

@implementation NewMileageViewController
@synthesize mileageField, oilChangedControl, submitButton, navController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


-(void)submit {
  int mostRecentMileage;
  if ([navController.mileageArray count] > 0) {
    Mileage *lastMileage = [navController.mileageArray objectAtIndex:0];
    mostRecentMileage = (int)[lastMileage.mileage intValue];
  } else {
    mostRecentMileage = 0;
  }
  
  Mileage *mileage = (Mileage *)[NSEntityDescription insertNewObjectForEntityForName:@"Mileage" inManagedObjectContext:navController.managedObjectContext];
  int currentMileage = (int)[mileageField.text intValue];
  int oilWasChanged = (int)[oilChangedControl selectedSegmentIndex];

  if (currentMileage < mostRecentMileage) {
    NSLog(@"%i, %i", currentMileage, mostRecentMileage);
    NSLog(@"too low");
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Mileage" message:@"You cannot enter mileage less than the current mileage" delegate:self cancelButtonTitle:@"Reenter mileage" otherButtonTitles:nil] autorelease];
    [alert show];
  } else {
    [mileage setMileage:[NSNumber numberWithInt:currentMileage]];
    [mileage setOilChanged:[NSNumber numberWithInt:oilWasChanged]];
    [mileage setCreatedAt:[NSDate date]];

    NSError *error;
    if (![navController.managedObjectContext save:&error]) {
      NSLog(@"saving object failed: %@", error);
    }
  
    [navController.mileageArray insertObject:mileage atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
    MileageTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController popViewControllerAnimated:YES];

    [navController.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [navController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
  self.navigationItem.rightBarButtonItem = submitButton;
}


-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
//  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Mileage" style:UIBarButtonItemStylePlain target:self action:nil];
//  self.navigationItem.backBarButtonItem = backButton;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  [mileageField release];
  [oilChangedControl release];
  [submitButton release];
  [super dealloc];
}


@end
