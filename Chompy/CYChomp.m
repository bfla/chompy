//
//  CYChomp.m
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import "CYChomp.h"

@implementation CYChomp

@dynamic calories;
@dynamic note;
@dynamic burned;
@dynamic timeChomped;
@dynamic dateCreated;
@dynamic chompKey;

- (void)awakeFromInsert
// Perform these methods when a new CMPChomp is saved to the database
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date]; // Save the date created
    
    // Save the timeChomped, if it is blank
    self.timeChomped = [NSDate date];
    
    // Save the key for this CMPChomp
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.chompKey = key;
    
}


@end
