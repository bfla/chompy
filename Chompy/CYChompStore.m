//
//  CYChompStore.m
//  Chompy
//
//  Created by Brian Flaherty on 6/1/14.
//  Copyright (c) 2014 Restless LLC. All rights reserved.
//

#import "CYChompStore.h"
#import "CYChomp.h"
@import CoreData;

@interface CYChompStore ()

@property (nonatomic) NSMutableArray *privateChomps;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation CYChompStore

# pragma mark - External access
+ (instancetype)sharedStore
{
    static CYChompStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

# pragma mark - Initializers
// If someone calls [[CYChompStore alloc] init], let him know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[CYChompStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// The real initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Read the Chompy.xcdatamodeld and store the model characteristics
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        // Create psc to coordinate saving and loading for the models
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        // Where does the SQLite file go?
        NSString *path = self.chompArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        // Configure the psc & handle errors
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        // Create the managed object context
        // It interacts with the psc and holds model objects
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        // Load all the chomps
        [self loadAllChomps];
    }
    return self;
}

# pragma mark - Save, Edit, & Destroy Actions
- (NSString *)chompArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (CYChomp *)createChomp {
    /*double order;
     if ([self.allChomps count] == 0) {
     order = 1.0;
     } else {
     order = [[self.privateChomps lastObject] orderingValue] + 1.0;
     }
     NSLog(@"Adding after %d chomps, order = %.2f", [self.privateChomps count]), order);*/
    
    CYChomp *chomp = [NSEntityDescription insertNewObjectForEntityForName:@"CYChomp" inManagedObjectContext:self.context];
    //chomp.orderingValue = order;
    
    [self.privateChomps addObject:chomp];
    
    return chomp;
}

- (BOOL)saveChanges {
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)removeChomp:(CYChomp *)chomp {
    [self.context deleteObject:chomp];
    [self.privateChomps removeObjectIdenticalTo:chomp];
}

#pragma mark - Fetch Requests & Sets
- (NSArray *)allChomps
{
    return [self.privateChomps copy];
}

/*- (NSArray *)chompsToday
 {
 return [self.privateChomps copy];
 }*/

- (void)loadAllChomps
// Get all chomps from the db
{
    if (!self.privateChomps) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"CYChomp" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateChomps = [[NSMutableArray alloc] initWithArray:result];
    }
}

#pragma mark - Special scopes and data methods
/*-(int)totalCalsToday
 {
 
 }*/

/*- (int)totalBurnedToday
 {
 
 }*/


@end
