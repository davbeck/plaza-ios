//
//  TCNeed.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCNeed.h"
#import "TCItem_Private.h"

@implementation TCNeed

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
	
	_serverID = [dictionary objectForKey:@"nuid"];
}

@end
