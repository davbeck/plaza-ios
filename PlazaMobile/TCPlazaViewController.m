//
//  TCMasterViewController.m
//  PlazaMobile
//
//  Created by David Beck on 5/2/12.
//  Copyright (c) 2012 TheCity. All rights reserved.
//

#import "TCPlazaViewController.h"

#import "PlazaKit.h"
#import "TCTopicCell.h"


const UInt8 TCItemsObserver;


@implementation TCPlazaViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeItems:) name:TCPlazaWillChangeItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddItems:) name:TCPlazaDidAddItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveItems:) name:TCPlazaDidRemoveItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeItems:) name:TCPlazaDidChangeItemsNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[[TCPlazaController sharedController] removeObserver:self forKeyPath:@"allItems" context:(void *)&TCItemsObserver];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidAppear:(BOOL)animated
{
	[[TCPlazaController sharedController] loadAll];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [TCPlazaController sharedController].allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];

	TCItem *item = [[TCPlazaController sharedController].allItems objectAtIndex:indexPath.row];
	cell.item = item;
	
    return cell;
}

#pragma mark - Notifications

- (void)willChangeItems:(NSNotification *)notification
{
	[self.tableView beginUpdates];
}

- (void)didAddItems:(NSNotification *)notification
{
	for (TCItem *item in [notification.userInfo objectForKey:TCPlazaNewItemsKey]) {
		NSUInteger index = [[TCPlazaController sharedController].allItems indexOfObject:item];
		NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (void)didRemoveItems:(NSNotification *)notification
{
	for (TCItem *item in [notification.userInfo objectForKey:TCPlazaOldItemsKey]) {
		NSUInteger index = [[TCPlazaController sharedController].allItems indexOfObject:item];
		NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (void)didChangeItems:(NSNotification *)notification
{
	[self.tableView endUpdates];
}



//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = [_objects objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}

@end
