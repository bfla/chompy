//
//  CYChomp.h
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CYChomp : NSManagedObject

@property (nonatomic) int calories;
@property (nonatomic) BOOL burned;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * timeChomped;

//@property (nonatomic, retain) UIImage * thumbnail;
//@property (nonatomic, retain) NSData * thumbnailData;

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * chompKey;

//-(void)setThumbnailFromImage:(UIImage *)image;

@end
