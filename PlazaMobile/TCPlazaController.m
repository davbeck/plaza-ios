//
//  TCPlazaController.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCPlazaController.h"

#import "PlazaKit.h"


@implementation TCPlazaController {
	NSMutableSet *_allItems;
	NSArray *_defaultSortDescriptors;
}

#pragma mark - Properties

- (NSArray *)allItems
{
	return [_allItems sortedArrayUsingDescriptors:_defaultSortDescriptors];
}

- (NSArray *)topics
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCTopic class]];
	}]];
}

- (NSArray *)events
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCEvent class]];
	}]];
}

- (NSArray *)prayers
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCPrayer class]];
	}]];
}

- (NSArray *)needs
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCNeed class]];
	}]];
}

- (NSArray *)albums
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCAlbum class]];
	}]];
}


#pragma mark - Initialization

static TCPlazaController *sharedInstance;

+ (TCPlazaController *)sharedController
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{
		sharedInstance = [[super alloc] init];
	});
	
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	if (sharedInstance != nil) {
		return sharedInstance;
	}
	
	return [super allocWithZone:zone];
}

- (id)init
{
	if (sharedInstance != nil) {
		return sharedInstance;
	}
	
    self = [super init];
    if (self) {
        _defaultSortDescriptors = [NSArray arrayWithObjects:
								   [NSSortDescriptor sortDescriptorWithKey:@"starting_at" ascending:NO],
								   [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO],
								   nil];
    }
    
    return self;
}

- (id)copy
{
	return self;
}

@end
