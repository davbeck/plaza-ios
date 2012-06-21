//
//  TCEvent.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCItem.h"


#define TCEventAddressCityKey @"city"
#define TCEventAddressStateKey @"state"
#define TCEventAddressZipKey @"zipcode"
#define TCEventAddressStreetKey @"street"
#define TCEventAddressLatitudeKey @"latitude"
#define TCEventAddressLongitudeKey @"longitude"


@interface TCEvent : TCItem

@property (nonatomic, readonly) NSDate *startOn;
@property (nonatomic, readonly) NSDate *endOn;

@property (nonatomic, readonly) NSDictionary *address;

@end
