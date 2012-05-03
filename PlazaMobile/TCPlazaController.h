//
//  TCPlazaController.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCItem;


@interface TCPlazaController : NSObject

+ (TCPlazaController *)sharedController;

@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSArray *topics;
@property (nonatomic, readonly) NSArray *events;
@property (nonatomic, readonly) NSArray *prayers;
@property (nonatomic, readonly) NSArray *needs;
@property (nonatomic, readonly) NSArray *albums;
- (TCItem *)itemWithServerID:(NSString *)serverID;

- (void)loadAll;

@end
