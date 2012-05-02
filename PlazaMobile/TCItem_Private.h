//
//  TCItem_Private.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCItem.h"

@interface TCItem () {
	@protected
	NSString *_serverID;
}

- (id)_initWithDictionary:(NSDictionary *)dictionary;
- (void)_updateWithDictionary:(NSDictionary *)dictionary;

@end
