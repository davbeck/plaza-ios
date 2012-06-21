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


@interface TCPlazaController ()

@property (nonatomic, strong) NSMutableSet *_allItemsUnsorted;
@property (nonatomic, readonly) NSString *_cachePath;
@property (nonatomic) NSUInteger _loadingCount;
- (void)_startLoading;
- (void)_finishLoading;

- (void)_applicationWillResignActive:(NSNotification *)notification;

@end


@implementation TCPlazaController

#pragma mark - Properties

@synthesize _allItemsUnsorted = __allItemsUnsorted;
@synthesize _loadingCount = __loadingCount;

- (NSArray *)allItems
{
    return [self._allItemsUnsorted.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 updatedAt] compare:[obj1 updatedAt]];
    }];
}

- (NSArray *)topics
{
	return [self.allItems objectsAtIndexes:[self.allItems indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj isKindOfClass:[TCTopic class]];
	}]];
}

- (NSArray *)events
{
    NSSet *events = [self._allItemsUnsorted objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return [obj isKindOfClass:[TCEvent class]];
    }];
    
	return [events.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 startOn] compare:[obj2 startOn]];
    }];
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

- (TCItem *)itemWithServerID:(NSString *)serverID
{
	return [[self._allItemsUnsorted objectsWithOptions:0 passingTest:^BOOL(TCItem *item, BOOL *stop) {
		*stop = [item.serverID isEqualToString:serverID];
		return *stop;
	}] anyObject];
}

+ (NSSet *)keyPathsForValuesAffectingLoading
{
	return [NSSet setWithObject:@"_loadingCount"];
}

- (BOOL)loading
{
	return self._loadingCount > 0;
}

- (void)_startLoading
{
	@synchronized(self) {
		self._loadingCount++;
	}
}

- (void)_finishLoading
{
	@synchronized(self) {
		self._loadingCount--;
	}
}

- (NSString *)_cachePath
{
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	return [cacheDirectory stringByAppendingPathComponent:@"TCPlaza.cache"];
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
		self._allItemsUnsorted = [NSKeyedUnarchiver unarchiveObjectWithFile:self._cachePath];
//		NSLog(@"self._allItemsUnsorted: %@", self._allItemsUnsorted);
		if (self._allItemsUnsorted == nil) {
			self._allItemsUnsorted = [[NSMutableSet alloc] init];
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}

- (id)copy
{
	return self;
}


#pragma mark - Notifications

- (void)_applicationWillResignActive:(NSNotification *)notification
{
	//archive items
//	NSLog(@"self._allItemsUnsorted: %@", self._allItemsUnsorted);
	[NSKeyedArchiver archiveRootObject:self._allItemsUnsorted toFile:self._cachePath];
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
	[self _startLoading];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://journeyon.onthecity.org/plaza/%@.json?page=%u&per_page=10", type, page]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//		NSLog(@"items: %@", items);
		
		[[NSNotificationCenter defaultCenter] postNotificationName:TCPlazaWillChangeItemsNotification object:self];
		NSMutableArray *newItems = [[NSMutableArray alloc] init];
		
		
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
					if (![self._allItemsUnsorted containsObject:item]) {
						[self._allItemsUnsorted addObject:item];
						[newItems addObject:item];
					}
				}
			}];
		}];
		
		
		[[NSNotificationCenter defaultCenter] postNotificationName:TCPlazaDidAddItemsNotification object:self userInfo:[NSDictionary dictionaryWithObject:newItems forKey:TCPlazaNewItemsKey]];
		[[NSNotificationCenter defaultCenter] postNotificationName:TCPlazaDidChangeItemsNotification object:self];
		
		[self _finishLoading];
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
