//
//  TCMasterViewController.h
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCPlazaViewController : UITableViewController

- (void)willChangeItems:(NSNotification *)notification;
- (void)didAddItems:(NSNotification *)notification;
- (void)didRemoveItems:(NSNotification *)notification;
- (void)didChangeItems:(NSNotification *)notification;

@end
