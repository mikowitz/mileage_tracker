//
//  Mileage.h
//  MileageTracker
//
//  Created by Michael Berkowitz on 11/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Mileage :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * oilChanged;
@property (nonatomic, retain) NSNumber * mileage;

@end



