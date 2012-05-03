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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == &TCItemsObserver) {
		[self.tableView reloadData];
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
	
	[[TCPlazaController sharedController] addObserver:self forKeyPath:@"allItems" options:0 context:(void *)&TCItemsObserver];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = [_objects objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}

@end
