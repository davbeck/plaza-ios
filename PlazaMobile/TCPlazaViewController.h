//
//  TCMasterViewController.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface TCPlazaViewController : UITableViewController <EGORefreshTableHeaderDelegate>

- (void)willChangeItems:(NSNotification *)notification;
- (void)didAddItems:(NSNotification *)notification;
- (void)didRemoveItems:(NSNotification *)notification;
- (void)didChangeItems:(NSNotification *)notification;

@end
