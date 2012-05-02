//
//  TCTopic.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCTopic.h"
#import "TCItem_Private.h"

@implementation TCTopic

@synthesize comments = _comments;

- (void)_updateWithDictionary:(NSDictionary *)dictionary
{
	[super _updateWithDictionary:dictionary];
	
	_serverID = [dictionary objectForKey:@"tuid"];
	_comments = [dictionary objectForKey:@"posts"];
}

@end
