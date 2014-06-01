//
//  CYChompStore.h
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYChomp;

@interface CYChompStore : NSObject

@property (nonatomic, readonly) NSArray *allChomps;

+ (instancetype)sharedStore;

- (CYChomp *)createChomp;
- (void)removeChomp:(CYChomp *)chomp;
- (BOOL)saveChanges;

@end
