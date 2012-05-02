//
//  TCPlazaController.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCPlazaController.h"

#import "PlazaKit.h"
#import "TCItem_Private.h"


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
		
		_allItems = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (id)copy
{
	return self;
}


#pragma mark - Loading

- (void)loadAll
{
	[self loadNextTopicPage];
	[self loadNextEventPage];
	[self loadNextPrayerPage];
	[self loadNextNeedPage];
	[self loadNextAlbumPage];
}

- (void)_loadPage:(NSUInteger)page withType:(NSString *)type
{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://livingstones.onthecity.org/plaza/%@.json?page=%u&per_page=10", type, page]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//		NSLog(@"items: %@", items);
		
		[items enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
			[info enumerateKeysAndObjectsUsingBlock:^(NSString *type, NSDictionary *itemInfo, BOOL *stop) {
				TCItem *item;
				
				if ([type isEqualToString:@"global_topic"]) {
					item = [[TCTopic alloc] _initWithDictionary:itemInfo];
				} else if ([type isEqualToString:@"global_need"]) {
					item = [[TCNeed alloc] _initWithDictionary:itemInfo];
				} else if ([type isEqualToString:@"global_prayer"]) {
					item = [[TCPrayer alloc] _initWithDictionary:itemInfo];
				} else if ([type isEqualToString:@"global_event"]) {
					item = [[TCEvent alloc] _initWithDictionary:itemInfo];
				} else if ([type isEqualToString:@"global_album"]) {
					item = [[TCAlbum alloc] _initWithDictionary:itemInfo];
				}
				
				if (item != nil) {
					[_allItems addObject:item];
				}
			}];
		}];
	}];
}

- (void)loadNextTopicPage
{
	[self _loadPage:1 withType:@"topics"];
}

- (void)loadNextEventPage
{
	[self _loadPage:1 withType:@"events"];
}

- (void)loadNextPrayerPage
{
	[self _loadPage:1 withType:@"prayers"];
}

- (void)loadNextNeedPage
{
	[self _loadPage:1 withType:@"needs"];
}

- (void)loadNextAlbumPage
{
	[self _loadPage:1 withType:@"albums"];
}

@end
