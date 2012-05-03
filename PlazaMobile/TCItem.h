//
//  TCItem.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCItem : NSObject

@property (nonatomic, readonly) NSString *serverID;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *bodyHTML;
@property (nonatomic, readonly) NSSet *tags;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSDate *createdAt;
@property (nonatomic, readonly) NSDate *updatedAt;

@end