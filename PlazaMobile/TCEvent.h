//
//  TCEvent.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCItem.h"

@interface TCEvent : TCItem

@property (nonatomic, readonly) NSDate *startOn;
@property (nonatomic, readonly) NSDate *endOn;

@end
