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


const UInt8 TCLoadingObserverRef;
#define TCLoadingObserver ((void *)&TCLoadingObserverRef)


@implementation TCPlazaViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == TCLoadingObserver) {
		if (![TCPlazaController sharedController].loading) {
            [self.refreshControl endRefreshing];
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

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
	[[TCPlazaController sharedController] addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionOld context:TCLoadingObserver];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TCPlazaWillChangeItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TCPlazaDidAddItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TCPlazaDidRemoveItemsNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TCPlazaDidChangeItemsNotification object:nil];
	[[TCPlazaController sharedController] removeObserver:self forKeyPath:nil context:TCLoadingObserver];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidAppear:(BOOL)animated
{
	[[TCPlazaController sharedController] loadAll];
    [self.refreshControl beginRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showItem"] || [[segue identifier] isEqualToString:@"showCalendar"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TCItem *item = [[TCPlazaController sharedController].allItems objectAtIndex:indexPath.row];
        [[segue destinationViewController] setItem:item];
    }
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
	TCItem *item = [[TCPlazaController sharedController].allItems objectAtIndex:indexPath.row];
	
    TCTopicCell *cell;
	if ([item isKindOfClass:[TCEvent class]]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
	}

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


#pragma mark - Actions

- (IBAction)refresh:(id)sender
{
    [[TCPlazaController sharedController] loadAll];
}

@end
