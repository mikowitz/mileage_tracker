//
//  RootViewController.m
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "RootViewController.h"
#import "MileageTrackerAppDelegate.h"
#import "NewMileageViewController.h"
#import "Mileage.h"

@implementation RootViewController
@synthesize mileageArray, managedObjectContext, addButton;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(void)addMileage {
  NewMileageViewController *newMVController = [[NewMileageViewController alloc] initWithNibName:@"NewMileageViewController" bundle:nil];
  
  newMVController.title = @"New Mileage Record";
  newMVController.navController = self;

  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Mileage" style:UIBarButtonItemStylePlain target:self action:nil];
  self.navigationItem.backBarButtonItem = backButton;  
  [backButton release];
  
  MileageTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  [delegate.navController pushViewController:newMVController animated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mileage" inManagedObjectContext:managedObjectContext];
  [request setEntity:entity];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  NSError *error;
  NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  [self setMileageArray:mutableFetchResults];
  [mutableFetchResults release];
  [request release];
  
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMileage)];
  self.navigationItem.rightBarButtonItem = addButton;
  mileageArray = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  Mileage *lastOilChange = nil;
  Mileage *lastMileage;
  bool dobreak = false;
  if ([mileageArray count] > 0) {
    for (int i = 0; !dobreak && i < [mileageArray count]; i++) {
      lastMileage = [mileageArray objectAtIndex:i];
      if (1 == [lastMileage.oilChanged intValue]) {
        lastOilChange = [mileageArray objectAtIndex:i];
        dobreak = true;
        break;
      }
    }
    Mileage *lastRecord = [mileageArray objectAtIndex:0];
    int lastOilChangeInt = (int)[lastOilChange.mileage intValue];
    int lastRecordInt = (int)[lastRecord.mileage intValue];
    int diffSinceOilChange = 3000 - (lastRecordInt - lastOilChangeInt);
    self.title = [NSString stringWithFormat:@"%i", diffSinceOilChange];
  } else {
    int diffSinceOilChange = 3000;
    self.title = [NSString stringWithFormat:@"%i", diffSinceOilChange];
  }


}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [mileageArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  Mileage *mileage = (Mileage *)[mileageArray objectAtIndex:indexPath.row];


  cell.textLabel.text = [NSString stringWithFormat:@"%@", mileage.mileage];
  if (1 == [mileage.oilChanged intValue]) {
    cell.detailTextLabel.text = @"Oil Change";
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObject *eventToDelete = [mileageArray objectAtIndex:indexPath.row];
    [managedObjectContext deleteObject:eventToDelete];
    
    [mileageArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
      NSLog(@"Deletion failed!");
    }
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  [managedObjectContext release];
  [mileageArray release];
  [addButton release];
  [super dealloc];
}


@end

