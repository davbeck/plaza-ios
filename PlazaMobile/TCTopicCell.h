//
//  TCTopicCell.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCItem;


@interface TCTopicCell : UITableViewCell

@property (nonatomic, strong) TCItem *item;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

@end
